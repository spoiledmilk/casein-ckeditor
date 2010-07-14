module CaseinCkeditor
  mattr_accessor :editor_config
  @@editor_config = "caseinck/config.js"
  
  mattr_accessor :editor_toolbar
  @@editor_toolbar = "CaseinCk_Basic"
  
  def self.setup
    yield self
  end
end

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :caseinck => ["caseinckeditor/ckeditor/ckeditor", "caseinckeditor/config.js"]