class Cargo < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:level, :name) }

  before_create -> { self.active = true if active.nil? }
end
