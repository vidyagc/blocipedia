class AddAttachmentImageToWikis < ActiveRecord::Migration
  def self.up
    change_table :wikis do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :wikis, :image
  end
end
