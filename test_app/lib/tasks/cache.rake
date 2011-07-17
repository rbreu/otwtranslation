begin
  namespace :cache do
    desc "Clear the cache."
    task(:clear => :environment) do
      Rails.cache.clear
    end
  end

  namespace :cache do
    desc "Fill redis with approved translations and vissible languages"
    task(:fill_redis => :environment) do
      Otwtranslation::Translation.all.each do |t|
        $redis.set(t.cache_key, t.label) if t.approved
      end
      Otwtranslation::Language.all.each do |l|
        $redis.sadd("owtranslation_visible_languages", l.short) if l.translation_visible
      end
    end
  end

end
