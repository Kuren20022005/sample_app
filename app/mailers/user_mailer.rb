class UserMailer < ApplicationMailer
  def account_activation
    @user = user
    mail to: user.email, subject: t("Mailer.account_activation.subject")
  end

  def password_reset
    @user = user
    mail to: user.email, subject: t("Mailer.password_reset.subject")
  end
end
