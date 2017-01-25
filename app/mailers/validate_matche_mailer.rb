class ValidateMatcheMailer < ApplicationMailer
  default from: 'Spikedball <info@spikedball.com>'

  def validate_match(user, match)
    @user = user
    @match = match
    mail(to: @user.email, subject: "Validate Your Match!")
  end
end
