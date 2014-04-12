class Capture
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :location, type: String
  field :time, type: String

  has_mongoid_attached_file :avatar,
    :path           => 'captures/:id/:style.:extension',
    :storage        => :s3,
    :url            => 'https://s3.amazonaws.com/digsouth/',
    :s3_credentials => Proc.new{|a| {:bucket => "digsouth", :access_key_id => ACCESS_KEY, :secret_access_key => SECRET_KEY} },
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg]
    }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  belongs_to :user
end