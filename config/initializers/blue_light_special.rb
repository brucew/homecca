require 'yaml'

begin
  configuration = YAML.load_file("#{Rails.root}/config/blue_light_special.yml")[Rails.env]
  configuration = HashWithIndifferentAccess.new(configuration)
  
  BlueLightSpecial.configure do |config|
    config.mailer_sender        = configuration[:mailer_sender]
    config.impersonation_hash   = configuration[:impersonation_hash]
    config.use_facebook_connect = configuration[:use_facebook_connect]
    config.use_delayed_job      = configuration[:use_delayed_job]
    config.facebook_api_key     = configuration[:facebook_api_key]
    config.facebook_secret_key  = configuration[:facebook_secret_key]
  end

  if configuration[:madmimi_username].present? && configuration[:madmimi_api_key].present?
    MadMimiMailer.api_settings = {
       :username  => configuration[:madmimi_username],
       :api_key   => configuration[:madmimi_api_key]
    }
  else
  end
rescue LoadError
  puts "The /config/blue_light_special.yml file is missing or broken."
end
