namespace :casein do
  
  namespace :ckeditor do
    
    desc "Install the plugin"
    task :setup => :environment do      
      FileUtils::Verbose.cp_r "vendor/plugins/casein_ckeditor/public/javascripts/caseinckeditor", "public/javascripts/"
      FileUtils::Verbose.cp "vendor/plugins/casein_ckeditor/app/helpers/casein_ckeditor_helper.rb", "app/helpers/casein_ckeditor_helper.rb"
      FileUtils::Verbose.cp "vendor/plugins/casein_ckeditor/config/initializers/casein_ckeditor.rb", "config/initializers/casein_ckeditor.rb"
      FileUtils::Verbose.cp "vendor/plugins/casein_ckeditor/db/migrate/create_ckeditor_ck_assets.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_ckeditor_ck_assets.rb"
    end
  end
  
end