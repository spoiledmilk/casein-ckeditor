class Casein::CaseinCkeditorController < Casein::CaseinController
  layout false
  protect_from_forgery :only => [] 
  
  def filebrowser
    redirect_to "/javascripts/caseinckeditor/filemanager/#{params_to_query_string(params.merge({:kind => 'file'}))}"
  end
  
  def imagebrowser
    redirect_to "/javascripts/caseinckeditor/filemanager/#{params_to_query_string(params.merge({:kind => 'image'}))}"
  end
  
  def folders
    if params[:dir] == "/" || params[:dir].blank?
      @folders = CkAsset.root_folders.in_order
    else
      @folder = CkAsset.find(params[:dir])
      @folders = @folder.children.in_order
    end
  end
  
  def connector
    if params[:mode] == "addfolder"
      addfolder
    elsif params[:mode] == "getinfo"
      getinfo
    elsif params[:mode] == "rename"
      rename      
    elsif params[:mode] == "delete"
      delete
    elsif params[:mode] == "getfolder"
      getfolder
    elsif params[:mode] == 'add'
      add
    end
  end
  
  protected
  
  def addfolder
    folder = CkAsset.new :kind => "folder", :folder_name => params[:name]
    folder.parent_id = params[:path].split("/").last
    folder.save!
    
    render :json, :text => {'Parent' => params[:path], 'Folder ID' => folder.id, 'Name' => folder.folder_name, 'Error' => '', 'Code' => 0}.to_json
  end
  
  def getinfo
    @media_file = CkAsset.find(params[:path].split("/").last)
    
    if @media_file.kind == "folder"
      render :json, :text => { 'Path' => params[:path], 'Filename' => @media_file.folder_name, 'File Type' => 'dir','''Preview' => '', 'Properties' => { 'Date Created' => '', 'Date Modified' => '', 'Height' => '', 'Width' => '', 'Size' => ''''}, 'Error' => '', 'Code' => 0 }.to_json
    else
      dimensions = Paperclip::Geometry.from_file(@media_file.upload.path)
      render :json, :text => {
        'Path' => @media_file.upload.url,
        'ID' => @media_file.id,
        'Parent ID' => (@media_file.parent.id rescue ''),
        'Filename' => @media_file.upload_file_name,
        'File Type' => @media_file.upload_file_name.split('.').last,
        'Preview' => (@media_file.image?) ? @media_file.upload.url : "/javascripts/caseinckeditor/filemanager/images/fileicons/#{@media_file.upload_file_name.split('.').last}.png",
        'Properties' => {
          'Date Created' => @media_file.created_at.strftime('%d.%m.%Y'),
  		    'Date Modified' => @media_file.updated_at.strftime('%d.%m.%Y'),
  		    'Height' => dimensions.height,
  		    'Width' => dimensions.width,
  		    'Size' => @media_file.upload_file_size
        },
        'Error' => '',
        'Code' => 0
      }.to_json
    end
  end
  
  def rename
    @folder = CkAsset.find(params[:old].split("/").last)
    old_name = @folder.folder_name
    @folder.folder_name = params[:new]
    @folder.save!
    
    render :json, :text => {'Error' => '', 'Code' => 0, 'Old Path' => params[:old], 'Old Name' => old_name, 'New Path' => params[:old], 'New Name' => @folder.folder_name}.to_json
  end
  
  def delete
    @folder = CkAsset.find(params[:path].split("/").last)
    @folder.destroy
    
    parent_path_arr = params[:path].split("/")
    parent_path_arr[-1] = ""
    
    render :json, :text => {'Error' => '', 'Code' => 0, 'Path' => params[:path], 'Parent' => parent_path_arr.join('/')}.to_json
  end
  
  def getfolder
    @folder = CkAsset.find(params[:path].split("/").last)
    @children = @folder.children.folders.in_order
    if params[:kind] == "image"
      @children += @folder.children.images.in_order
    else
      @children += @folder.children.images_and_files.in_order
    end
    
    arr = []
    @children.each do |child|
      if child.kind == 'folder'
        arr << {
          'Path' => "#{child.id}/",
          'Filename' => child.folder_name,
          'File Type' => 'dir',
          'Preview' => '/javascripts/caseinckeditor/filemanager/images/fileicons/_Open.png',
          'Properties' => {
            'Date Created' => nil,
				    'Date Modified' => nil,
				    'Height' => nil,
				    'Width' => nil,
				    'Size' => nil
			    },
			    'Error' => "",
					'Code' => 0
		    }
				
      else
        arr << {
          'Path' => "/#{child.id}",
          'Filename' => child.upload_file_name,
          'File Type' => child.upload_file_name.split('.').last,
          'Preview' => (child.image?) ? child.upload.url : "/javascripts/caseinckeditor/filemanager/images/fileicons/#{child.upload_file_name.split('.').last}.png",
          'Properties' => {
            'Date Created' => nil,
				    'Date Modified' => nil,
				    'Height' => nil,
				    'Width' => nil,
				    'Size' => nil
          },
          'Error' => '',
          'Code' => 0
        }
      end
    end
    
    render :json, :text => arr.to_json
  end
  
  def add
    media_file = CkAsset.new :upload => params[:newfile], :parent_id => params[:currentpath].split("/").last
    
    if params[:kind] == "image" && !media_file.image?
      media_file.destroy
      render :json, :text => {'Path' => params[:currentpath], 'Name' => '', 'Error' => 'The uploaded file has to be an image', 'Code' => 1}.to_json
    else
      media_file.kind = media_file.image? ? "image" : "file"
      media_file.save!
      render :json, :text => {'Path' => params[:currentpath], 'Name' => media_file.upload_file_name, 'Error' => '', 'Code' => 0}.to_json
    end
  end
  
  def params_to_query_string(params)
    str = "?"
    params.each_pair do |key, value|
      str += "#{key}=#{value}&"
    end
    str
  end
  
end