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

      Otwtranslation::Language.all.each{ |l| l.add_to_cache }
      
      Otwtranslation::ContextRule.all.each do |r|
        $redis.sadd("otwtranslation_rules_for_#{r.locale}", r.display_type)
      end
      
    end
  end

end
