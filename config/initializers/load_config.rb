APP_CONFIG = YAML.load_file(Rails.root+"config/adl.yml")[Rails.env]
PRESERVATION_CONFIG = YAML.load_file(Rails.root+"config/preservation_profiles.yml")[Rails.env]
MQ_CONFIG = YAML.load_file(Rails.root+"config/activemq.yml")[Rails.env]
