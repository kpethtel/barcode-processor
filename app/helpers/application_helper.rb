module ApplicationHelper
  def bootstrap_alert_class_for(type)
    case type
    when "alert", :alert
      "alert-danger"
    when "notice", :notice
      "alert-info"
    else
      raise ArgumentError, "Unknown flash type #{type}!"
    end
  end
end
