require 'factory_girl'

Factory.define(:source, :class => Otwtranslation::Source) do |f|
  f.sequence(:controller_action) { |i| "home#{i}#index" } 
end

Factory.define(:user) do |f|
  f.sequence(:login) { |i| "name#{i}" } 
  f.sequence(:email) { |i| "name#{i}@example.com" } 
  f.translation_admin false
  f.password 'test123'
end

Factory.define :translation_admin, :parent => :user do |f|
  f.translation_admin true
end


Factory.define(:language, :class => Otwtranslation::Language) do |f|
  f.sequence(:name) { |i| "#{i}Deutsch" } 
  f.right_to_left false
  f.translation_visible true

  f.after_build {|l| l.short = l.name[0,2].downcase }
end


Factory.define(:phrase, :class => Otwtranslation::Phrase) do |f|
  f.sequence(:label) { |i| "some text #{i}" } 
  f.version OtwtranslationConfig.VERSION
  
  f.after_build do |p|
    p.key = Otwtranslation::Phrase.generate_key(p.label, p.description)
  end
end


Factory.define(:translation, :class => Otwtranslation::Translation) do |f|
  f.association :language
  f.association :phrase
  f.label "some foreign text"
  f.approved false
end


Factory.define(:possessive_rule, :class => Otwtranslation::PossessiveRule) do |f|
  f.association :language
  f.description "standard possessive rule"
  f.conditions [["matches all", []]]
  f.actions [["append", ["'s"]]]
end

Factory.define(:assignment_part, :class => Otwtranslation::AssignmentPart) do |f|
  f.association :assignee, :factory => :user
  f.association :assignment
  f.notes "some important note"
  f.completed false
end

Factory.define(:assignment, :class => Otwtranslation::Assignment) do |f|
  f.association :source
  f.association :language
  f.description "some description"
  
  f.after_build do |assnm|
    assnm.parts ||= [Factory.build(:assignment_part, :assignment => assnm),
                     Factory.build(:assignment_part, :assignment => assnm)]
  end
end


