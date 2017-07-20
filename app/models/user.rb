class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :wikis
  
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :init

    def init
      self.role  ||= 'standard' 
    end
         
  def update_role(new_role, customer_id)
    update_attribute(:role, new_role)
    update_attribute(:cid, customer_id)
    
    if new_role == 'standard'
      wikis.where(:private => true).each do |wiki| #where(private: true).each do |wiki|
        wiki.update_attribute(:private, false)
        wiki.collaborators.destroy_all
      end 
    end 
  end 
end
