class Wiki < ActiveRecord::Base
  belongs_to :user

  after_initialize :init

    def init
      self.private  ||= false  #will set the default value only if it's nil
    end

end
