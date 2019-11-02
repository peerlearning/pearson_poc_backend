class Settings < Settingslogic
  source "#{Rails.root}/config/config.yml.erb"
  namespace Rails.env
  load!
end
