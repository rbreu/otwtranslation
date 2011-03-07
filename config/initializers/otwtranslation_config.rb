require 'yaml'
require 'ostruct'

hash = YAML.load_file("#{Rails.root}/config/otwtranslation/config.yml")
OtwtranslationConfig = OpenStruct.new(hash)




