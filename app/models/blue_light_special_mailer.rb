class BlueLightSpecialMailer
# This class overrides the BlueLightSpecialMailer included in the BlueLightSpecial/cops gem
# so that we can use our own Mailer class

  def self.deliver_change_password(user)
    Mailer.deliver_mimi_change_password(user)
  end

  def self.deliver_welcome(user)
    Mailer.deliver_mimi_welcome(user)
  end

  def self.deliver_confirmation(user)
    Mailer.deliver_mimi_confirmation(user)
  end

end