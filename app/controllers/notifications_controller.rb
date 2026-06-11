class NotificationsController < ApplicationController
  def index
    @notifications = current_person.notifications.recent
  end

  def mark_read
    notification = current_person.notifications.find(params[:id])
    notification.read!
    head :ok
  end

  def mark_all_read
    current_person.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path
  end
end
