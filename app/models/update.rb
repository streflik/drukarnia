class Update < ActiveRecord::Base
  validates_presence_of :title, :body

  has_attached_file :poster,
                    :url  =>":class/:id/:style_:filename",
                    :styles=>{
                        :thumb=>"100x100",
                        :original=>"670x215"
                    },
                    :path => "public/images/:class/:id/:style_:filename"

  def body_short
    if self.body.length>200
      self.body[0, 200]+"..."
    else
      self.body
    end
  end
end
