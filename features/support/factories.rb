require 'factory_girl'
 
Factory.define(:user) do |user|
  user.login 'Abby'
  user.email 'abby@example.com'
  user.translation_admin 'false'
  user.password 'test123'
end

Factory.define(:language, :class => Otwtranslation::Language) do |language|
  language.short 'en'
  language.name 'English'
  language.right_to_left false
  language.translation_visible true
end
