begin
  namespace :stuff do
    desc "Nuke and recreate DB, clear cache."
    task :allnew do	    
      Rake::Task['db:drop:all'].invoke 
      Rake::Task['db:create:all'].invoke 
      Rake::Task['db:migrate'].invoke 
      Rake::Task['cache:clear'].invoke 
    end
  end
end