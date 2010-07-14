class CkAsset < ActiveRecord::Base
  belongs_to :parent, :class_name => "CkAsset"
  has_many :children, :class_name => "CkAsset", :foreign_key => :parent_id, :dependent => :destroy
  
  has_attached_file :upload, :styles => { :ckeditor_thumb => "128x128#" }
  
  scope :root_folders, where("kind = 'folder' AND parent_id IS NULL")
  scope :folders, where(:kind => "folder")
  scope :images_and_files, where("kind != 'folder'")
  scope :images, where(:kind => "image")
  scope :files, where(:kind => "file")
  scope :in_order, order('upload_file_name ASC, folder_name ASC')
  
  def image?
    !(upload_content_type =~ /^image.*/).nil?
  end
end