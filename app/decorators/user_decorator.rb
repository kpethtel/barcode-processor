class UserDecorator < ApplicationDecorator
  def name
    [firstname, lastname].join(" ")
  end
end
