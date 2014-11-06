class Mail
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def send!
    p 'Sending email to:' + email
  end
end
