class Pdi < ApplicationRecord
  enum :status, { not_started: 0, in_progress: 1, done: 2, cancelled: 3 }

  belongs_to :person
  belongs_to :cycle, optional: true

  validates :title, presence: true

  def progress_percent
    return 0 if actions.blank?
    done = actions.count { |a| a["done"] }
    (done.to_f / actions.size * 100).round
  end
end
