begin
  namespace :cache do
    desc "Clear the cache and redis"
    task(:clear => :environment) do
      Rails.cache.clear
      $redis.keys('otwtranslation_*').each{ |key| $redis.del(key) }
    end
  end

  namespace :cache do
    desc "Fill redis with approved translations, visible languages, and rule types"
    task(:fill_redis => :environment) do
      Otwtranslation::Translation.all.each do |t|
        $redis.set(t.cache_key, t.label) if t.approved
      end
      Otwtranslation::Language.all.each do |l|
        $redis.sadd("otwtranslation_visible_languages", l.short) if l.translation_visible
      end
      
      Otwtranslation::ContextRule.all.each do |r|
        $redis.sadd("otwtranslation_rules_for_#{r.language_short}", r.display_type)
      end
      
    end
  end

end
