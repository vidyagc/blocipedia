class Wiki < ActiveRecord::Base
  
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  
  attr_accessor :remove_image
  before_save :delete_image 
  
  after_initialize :init
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "150x150#" } #, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  def init
    self.private  ||= false  #will set the default value only if it's nil
  end


  private

  def delete_image
    if self.remove_image =="1" && !image_updated_at_changed?
      self.image = nil
    end
  end

end
