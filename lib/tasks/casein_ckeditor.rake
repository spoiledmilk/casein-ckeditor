namespace :casein do
  
  namespace :ckeditor do
    
    desc "Install the plugin"
    task :setup => :environment do      
      #FileUtils::Verbose.cp_r "vendor/plugins/casein-ckeditor/public/javascripts/caseinckeditor", "public/javascripts/"
      cp "public/javascripts/caseinckeditor/config.js", "public/javascripts/caseinckeditor/config.js_bkk" rescue "Nothing"
      cp_r "vendor/plugins/casein-ckeditor/public/javascripts/caseinckeditor", "public/javascripts"
      FileUtils::Verbose.cp "vendor/plugins/casein-ckeditor/app/helpers/casein_ckeditor_helper.rb", "app/helpers/casein_ckeditor_helper.rb"
      cp "config/initializers/casein_ckeditor.rb", "config/initializers/casein_ckeditor.rb_bkk" rescue "Nothing"
      FileUtils::Verbose.cp "vendor/plugins/casein-ckeditor/config/initializers/casein_ckeditor.rb", "config/initializers/casein_ckeditor.rb"
      if ENV['MIGRATION'].downcase != 'false'
        FileUtils::Verbose.cp "vendor/plugins/casein-ckeditor/db/migrate/create_ckeditor_ck_assets.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_ckeditor_ck_assets.rb"
      end
    end
  end
  
end