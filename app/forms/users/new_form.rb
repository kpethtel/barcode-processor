class Users::NewForm < Form
  attribute :firstname
  attribute :lastname
  attribute :email
  attribute :password

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, email: true, length: 1..100
  validates :password, presence: true, length: {minimum: 5}
  validate :email_validation

  def sanitize
    firstname.try(:strip!)
    lastname.try(:strip!)
    email.try(:strip!)
    password.try(:strip!)
  end

  def email_validation
    return if errors[:email].any?
    return errors.add(:email, :taken) if User.where(email: email).exists?
  end

  def process
    User.create!(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
    )
  end
end
