module CaseinCkeditorHelper
	
	def casein_ckeditor_area form, model, attribute, options = {}
	  id = "#{model.class.name.downcase}_#{attribute}_#{rand(999999)}"
	  output = casein_text_area(form, model, attribute, options.merge({:id => id}))
	  output + casein_ckeditor_js_code(id, '120px', options)
  end
  
  def casein_ckeditor_area_big form, model, attribute, options = {}
	  id = "#{model.class.name.downcase}_#{attribute}_#{rand(999999)}"
	  output = casein_text_area(form, model, attribute, options.merge({:id => id}))
	  output + casein_ckeditor_js_code(id, '300px', options)
  end
  
  def casein_ckeditor_js_code(id, height, options = {})
    ckeditor_options = {:width => '100%', :height => height }
    ckeditor_options[:toolbar]  = options[:ckeditor_toolbar] || CaseinCkeditor.editor_toolbar
    ckeditor_options[:customConfig] = '/javascripts/'+CaseinCkeditor.editor_config
    
    ckeditor_options[:filebrowserBrowseUrl] = '/casein/ckeditor/filebrowser?style='+(options[:paperclip_style]||"original")
    ckeditor_options[:filebrowserImageBrowseUrl] = '/casein/ckeditor/imagebrowser?style='+(options[:paperclip_style]||"original")
    
    javascript_tag("
      if (CKEDITOR.instances['#{id}']) { 
        CKEDITOR.remove(CKEDITOR.instances['#{id}']);
      }
      CKEDITOR.replace('#{id}', { #{caseinckeditor_apply_options(ckeditor_options)}});"
    )
  end
  
  protected
  
  def caseinckeditor_apply_options(options={})
    str = []
    options.each do |k, v|
      value = case v.class.to_s.downcase
        when 'string' then "'#{v}'"
        when 'hash' then "{ #{caseinckeditor_apply_options(v)} }"
        else v
      end
      str << "#{k}: #{value}"
    end
    
    str.join(',')
  end

end