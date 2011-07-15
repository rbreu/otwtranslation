require 'yaml'
require 'ostruct'

hash = YAML.load_file("#{Rails.root}/config/otwtranslation/config.yml")
OtwtranslationConfig = OpenStruct.new(hash)

paths = []
OtwtranslationConfig.MAILS_TEMPLATE_PATHS.each do |pattern|
  paths += Dir.glob(File.join(Rails.root.to_s, pattern))
end

OtwtranslationConfig.mail_paths = paths.sort

