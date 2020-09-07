class Form
  include ActiveModel::Model
  include Virtus.model

  def self.model_name
    ActiveModel::Name.new(self, nil, "Form")
  end

  def initialize(attributes = {})
    super(attributes.respond_to?(:to_unsafe_h) ? attributes.to_unsafe_h : attributes)
    sanitize
  end

  def submit
    return unless valid?
    process
  end

  private

  def sanitize
  end

  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
end
