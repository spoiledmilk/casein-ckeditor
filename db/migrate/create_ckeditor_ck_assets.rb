class CreateCkeditorCkAssets < ActiveRecord::Migration
  def self.up
    create_table :ck_assets, :force => true do |t|
      t.string :kind
      t.string :folder_name
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.datetime :upload_updated_at
      t.integer :parent_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ck_assets
  end
end