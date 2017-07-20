class Collaborator < ActiveRecord::Base
    belongs_to :wiki
  
    validates :emailid, uniqueness: { scope: :wiki_id, :message => "The user you entered is already a collaborator on this wiki." } 
    validates_format_of :emailid, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
    
end
