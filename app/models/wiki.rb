class Wiki < ActiveRecord::Base

  belongs_to :user

  after_initialize :init

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
