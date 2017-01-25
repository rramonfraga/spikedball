class WelcomeCommunityMailer < ApplicationMailer
  default from: 'Spikedball <hi@spikedball.com>'

  def welcome_community(user, community)
    @user = user
    @community = community
    mail(to: @user.email, subject: "Welcome a new SpikedBall Community! (#{@community.name})")
  end
end
