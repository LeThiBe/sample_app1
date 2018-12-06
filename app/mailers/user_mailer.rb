class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject:
      t("mailers.user_mailer.account_activation.activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.password_reset.reset")
  end
end
