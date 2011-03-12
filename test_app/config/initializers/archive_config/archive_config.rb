
# Site configuration (needed before Initializer)
require 'ostruct'
require 'yaml'
hash = YAML.load_file("#{Rails.root}/config/config.yml")
if File.exist?("#{Rails.root}/config/local.yml") && !Rails.env.test?
  hash.merge! YAML.load_file("#{Rails.root}/config/local.yml")
end
::ArchiveConfig = OpenStruct.new(hash)

