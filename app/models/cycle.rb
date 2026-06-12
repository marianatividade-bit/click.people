class Cycle < ApplicationRecord
  enum :status, {
    draft:            0,
    nominations_open: 1,
    validating:       2,
    evaluation_open:  3,
    calibration:      4,
    closed:           5
  }

  belongs_to :created_by, class_name: "Person", optional: true
  has_many :questions, -> { order(:position) }, dependent: :destroy
  has_many :cycle_participants, dependent: :destroy
  has_many :participants, through: :cycle_participants, source: :person
  has_many :cycle_evaluation_plans, dependent: :destroy
  has_many :nominations, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_many :cycle_results, dependent: :destroy
  has_many :pdis

  validates :name, presence: true

  def current_phase_label
    case status
    when "draft"            then "Rascunho"
    when "nominations_open" then "Indicações abertas"
    when "validating"       then "Validando indicações"
    when "evaluation_open"  then "Avaliações abertas"
    when "calibration"      then "Calibração"
    when "closed"           then "Encerrado"
    end
  end

  def open_nominations!
    update!(status: :nominations_open)
  end

  def open_validations!
    update!(status: :validating)
  end

  def open_evaluations!
    transaction do
      update!(status: :evaluation_open)
      generate_evaluation_assignments!
    end
  end

  def open_calibration!
    transaction do
      update!(status: :calibration)
      compute_results!
    end
  end

  def close!
    update!(status: :closed)
  end

  def generate_evaluation_assignments!
    cycle_participants.each do |cp|
      person = cp.person

      # Self evaluation
      evaluations.find_or_create_by!(evaluator: person, evaluated: person, evaluation_type: :self)

      # Chapter manager evaluates
      if person.chapter_manager
        evaluations.find_or_create_by!(evaluator: person.chapter_manager, evaluated: person, evaluation_type: :chapter_manager)
      end

      # Stream manager evaluates
      if person.stream_manager
        evaluations.find_or_create_by!(evaluator: person.stream_manager, evaluated: person, evaluation_type: :stream_manager)
      end

      # Approved peer nominations
      nominations.where(evaluated: person, status: :approved).each do |nom|
        evaluations.find_or_create_by!(evaluator_id: nom.nominee_id, evaluated: person, evaluation_type: :peer, nomination: nom)
      end
    end
  end

  def compute_results!
    resultado_questions = questions.where(dimension: "resultado")
    atitude_questions   = questions.where(dimension: "atitude")

    cycle_participants.each do |cp|
      person = cp.person
      person_evals = evaluations.where(evaluated: person, status: :completed)
      next if person_evals.none?

      perf  = avg_score(person_evals, resultado_questions)
      pot   = avg_score(person_evals, atitude_questions)
      pos   = nine_box_position_for(perf, pot)

      result = cycle_results.find_or_initialize_by(person: person)
      result.assign_attributes(
        performance_score:           perf,
        potential_score:             pot,
        nine_box_position:           pos,
        pre_calibration_position:    result.pre_calibration_position || pos,
        pre_calibration_performance: result.pre_calibration_performance || perf,
        pre_calibration_potential:   result.pre_calibration_potential || pot
      )
      result.save!
    end
  end

  private

  def avg_score(evals, qs)
    return nil if qs.none?
    scores = evals.flat_map { |e| e.answers.where(question: qs).pluck(:numeric_value).compact }
    scores.any? ? (scores.sum / scores.size).round(2) : nil
  end

  def nine_box_position_for(perf, pot)
    return nil if perf.nil? || pot.nil?
    cfg = nine_box_config
    x_cuts = cfg["axis_x_thresholds"] || [4.0, 7.0]
    y_cuts = cfg["axis_y_thresholds"] || [4.0, 7.0]
    x = perf <= x_cuts[0].to_f ? 0 : perf <= x_cuts[1].to_f ? 1 : 2
    y = pot  <= y_cuts[0].to_f ? 0 : pot  <= y_cuts[1].to_f ? 1 : 2
    y * 3 + x
  end
end
