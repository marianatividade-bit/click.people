class Notification < ApplicationRecord
  belongs_to :person

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(20) }

  def read!
    update!(read_at: Time.current) unless read?
  end

  def read?
    read_at.present?
  end
end
