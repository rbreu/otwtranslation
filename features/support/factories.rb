require 'factory_girl'

Factory.sequence :user_name do |i|
  "Abby#{i}"
end

Factory.sequence :english_label do |i|
  "This is number #{i}!"
end

Factory.sequence :controller_action do |i|
  "home#{i}#index"
end


Factory.define(:source, :class => Otwtranslation::Source) do |source|
  source.controller_action { Factory.next(:controller_action) }
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
  phrase.version OtwtranslationConfig.VERSION
  
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


Factory.define(:possessive_rule, :class => Otwtranslation::PossessiveRule) do |rule|
  rule.association :language
  rule.description "standard possessive rule"
  rule.conditions  [["matches all", []]]
  rule.actions [["append", ["'s"]]]
end
