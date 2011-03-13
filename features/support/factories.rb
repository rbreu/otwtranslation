require 'factory_girl'
 
Factory.define(:user) do |user|
  user.login 'Abby'
  user.email 'abby@example.com'
  user.translation_admin 'false'
  user.password 'test123'
end
