json.array! @notifications do |notification|
  # json.recipient notification.recipient
  json.actor notification.actor.username
  json.action notification.action
  json.notifiable do
    json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
  end
  json.url chatroom_path(notification.notifiable)
end
