MY_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/my_secrets.yml")[Rails.env]
