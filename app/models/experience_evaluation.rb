class ExperienceEvaluation < ApplicationRecord
  belongs_to :person
  belongs_to :evaluator, class_name: "Person", optional: true

  enum :evaluation_type, { days_20: 0, days_70: 1 }
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :person_id, uniqueness: { scope: :evaluation_type, message: "já tem avaliação deste tipo" }

  QUESTIONS = {
    days_20: [
      { key: "integration",  label: "Como está sendo a integração com o time?",         type: "scale" },
      { key: "clarity",      label: "As responsabilidades e expectativas estão claras?", type: "scale" },
      { key: "tools",        label: "Você tem acesso a todas as ferramentas necessárias?", type: "scale" },
      { key: "support",      label: "Você se sente apoiado pelo seu líder?",             type: "scale" },
      { key: "highlights",   label: "O que foi mais positivo nesses primeiros dias?",    type: "text"  },
      { key: "challenges",   label: "Quais foram os maiores desafios?",                  type: "text"  }
    ],
    days_70: [
      { key: "performance",  label: "Como avalia seu desempenho no período?",            type: "scale" },
      { key: "culture_fit",  label: "Você se identifica com a cultura da Clicksign?",   type: "scale" },
      { key: "growth",       label: "Você sente que está crescendo e aprendendo?",       type: "scale" },
      { key: "team_fit",     label: "Qual o nível de integração com o time?",            type: "scale" },
      { key: "stay",         label: "Você se vê na Clicksign daqui a um ano?",           type: "scale" },
      { key: "improvements", label: "O que poderia ser melhorado no seu onboarding?",    type: "text"  },
      { key: "next_steps",   label: "Quais são suas expectativas para os próximos meses?", type: "text" }
    ]
  }.freeze

  def questions
    QUESTIONS[evaluation_type.to_sym] || []
  end

  def type_label
    evaluation_type == "days_20" ? "Avaliação 20 dias" : "Avaliação 70 dias"
  end

  def collaborator_complete?
    questions.all? { |q| collaborator_answers[q[:key]].present? }
  end

  def leader_complete?
    questions.all? { |q| leader_answers[q[:key]].present? }
  end

  def both_complete?
    collaborator_complete? && leader_complete?
  end
end
