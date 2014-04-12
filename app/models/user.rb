class User
  include Mongoid::Document
  include Mongoid::Paperclip

  field :first_name, type: String
  field :last_name, type: String
  field :token, type: String
  field :rule, type: String
  field :email, type: String
  field :finger_id, type: String
  field :finger, type: Boolean

  has_mongoid_attached_file :avatar,
    :path           => 'profile/:id/:style.:extension',
    :storage        => :s3,
    :url            => 'https://s3.amazonaws.com/digsouth/',
    :s3_credentials => Proc.new{|a| {:bucket => "digsouth", :access_key_id => ACCESS_KEY, :secret_access_key => SECRET_KEY} },
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg]
    }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :transfers
  has_many :captures
end
