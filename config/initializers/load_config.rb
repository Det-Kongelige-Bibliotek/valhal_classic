APP_CONFIG = YAML.load_file("#{Rails.root}/config/valhal.yml")[Rails.env]
PRESERVATION_CONFIG = YAML.load_file("#{Rails.root}/config/preservation_profiles.yml")[Rails.env]

