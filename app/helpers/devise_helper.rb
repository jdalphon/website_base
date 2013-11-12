module DeviseHelper
   def devise_error_messages!
    html = ""

    return html if resource.errors.empty?

    errors_number = 0
    html = ""
    saved_key = ""
    resource.errors.each do |key, value|
      if key != saved_key
        html << "<li><b>#{key}</b> #{value}</li>"
        errors_number += 1
      end
      saved_key = key
    end

    unsolved_errors = pluralize(errors_number, "unsolved error")

    html = "<div class='alert'><ul>#{html}</ul></div>"
    return html.html_safe
   end
end