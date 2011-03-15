require 'factory_girl'
 
Factory.define(:user) do |user|
  user.login 'Abby'
  user.email 'abby@example.com'
  user.translation_admin 'false'
  user.password 'test123'
end

Factory.define(:language) do |language|
  language.short 'de'
  language.name 'Deutsch'
  language.right_to_left false
  language.translation_viewable true
end
