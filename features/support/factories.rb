require 'factory_girl'

Factory.sequence :user_name do |n|
  "Abby#{n}"
end

Factory.sequence :english_label do |n|
  "This is number #{n}!"
end


Factory.define(:user) do |user|
  user.login { Factory.next(:user_name) }
  user.translation_admin false
  user.password 'test123'

  user.after_build {|u|  u.email = "#{u.login}@example.com" }
end

Factory.define :translation_admin, :parent => :user do |user|
  user.translation_admin true
end


Factory.define(:language, :class => Otwtranslation::Language) do |language|
  language.name 'Deutsch'
  language.right_to_left false
  language.translation_visible true

  language.after_build {|l| l.short = l.name[0,2].downcase }
end


Factory.define(:phrase, :class => Otwtranslation::Phrase) do |phrase|
  phrase.label { Factory.next(:english_label) }
  phrase.key "123"
  phrase.version OtwtranslationConfig.DEFAULT_LANGUAGE
  
  phrase.after_build do |p|
    p.key = Otwtranslation::Phrase.generate_key(p.label, p.description)
  end
end


Factory.define(:translation, :class => Otwtranslation::Translation) do |translation|
  translation.association :language
  translation.association :phrase
  translation.label "some foreign text"
  translation.approved false
end
