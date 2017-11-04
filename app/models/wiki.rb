class Wiki < ActiveRecord::Base

  belongs_to :user
  has_many :collaborators

  after_initialize :init
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "150x150#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  # before_save :assign_markdown_content, [:new, :create]

    def init
      self.private  ||= false  #will set the default value only if it's nil
    end

  # class << self
  #   def markdown
  #     Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  #   end
  # end

  # def assign_markdown_content
  #   assign_attributes({
  #     markdown_content: self.class.markdown.render(content)
  #   })
  # end

end
