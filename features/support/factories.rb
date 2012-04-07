require 'factory_girl'

FactoryGirl.define do

  factory :user do 
    sequence(:login) { |i| "name#{i}" } 
    sequence(:email) { |i| "name#{i}@example.com" } 
    translation_admin false
    password 'test123'
  end


  factory :pseud do
    name "my pseud"  
    association :user  
  end


  factory :translation_admin, :parent => :user do
    translation_admin true
  end


  factory :source, :class => Otwtranslation::Source do
    sequence(:controller_action) { |i| "home#{i}#index" } 
  end


  factory :language, :class => Otwtranslation::Language do
    sequence(:name) { |i| "#{i}Deutsch" } 
    right_to_left false
    translation_visible true

    after_build {|l| l.short = l.name[0,2].downcase }
  end


  factory :phrase, :class => Otwtranslation::Phrase do
    sequence(:label) { |i| "some text #{i}" } 
    version OtwtranslationConfig.VERSION
  
    after_build do |p|
      p.key = Otwtranslation::Phrase.generate_key(p.label, p.description)
    end
  end


  factory :translation, :class => Otwtranslation::Translation do
    association :language
    association :phrase
    sequence(:label) { |i| "some foreign text #{i}" }
    approved false
  end


  factory :comment, :class => Comment do |f|
    sequence(:content) { |i| "comment number #{i}" }
    association :pseud
    approved true
    hidden_by_admin false
    ignore { f.commentable nil }

    after_build do |cmt|
      cmt.commentable_type = cmt.commentable.class.name
      cmt.commentable_id = cmt.commentable.id
    end
  end

  
  factory :possessive_rule, :class => Otwtranslation::PossessiveRule do
    association :language
    description "standard possessive rule"
    conditions [["matches all", []]]
    actions [["append", ["'s"]]]
  end


  factory :assignment_part, :class => Otwtranslation::AssignmentPart do
    association :assignee, :factory => :user
    association :assignment
    notes "some important note"
  end


  factory :assignment, :class => Otwtranslation::Assignment do
    association :source
    association :language
    description "some description"
  
    after_build do |assnm|
      assnm.parts ||= [Factory.build(:assignment_part, :assignment => assnm),
                       Factory.build(:assignment_part, :assignment => assnm)]
    end
  end
end














