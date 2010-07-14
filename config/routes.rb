Rails.application.routes.draw do |map|
  namespace :casein do
    match 'ckeditor/filebrowser', :to => 'casein_ckeditor#filebrowser'
    match 'ckeditor/imagebrowser', :to => 'casein_ckeditor#imagebrowser'
    match 'ckeditor/folders', :to => 'casein_ckeditor#folders'
    match 'ckeditor/connector', :to => 'casein_ckeditor#connector'
  end
end