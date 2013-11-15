module DeviseHelper
  def devise_error_messages!
    flash_messages = []
    resource.errors.each do |type, message|
    next if message.blank?
    alert_type = :danger
    text = content_tag(:div,
      content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
      type + " " + message.html_safe, :class => "alert fade in alert-#{alert_type}")
    flash_messages << text if message
       
    end
    flash_messages.join("\n").html_safe
  end
end