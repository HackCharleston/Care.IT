class User
  include Mongoid::Document
  include Mongoid::Paperclip

  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :username, type: String
  field :street, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: String
  field :token, type: String
  field :card_token, type: String
  field :email, type: String, default: 'admin@care.it'
  field :finger_id, type: String
  field :finger, type: Boolean, default: false

  has_mongoid_attached_file :avatar,
    :path           => 'profile/:id/:style.:extension',
    :storage        => :s3,
    :url            => 'https://s3.amazonaws.com/digsouth/',
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg]
    }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :transfers
  has_many :captures

  def s3_credentials
    # {:bucket => "digsouth", :access_key_id => ACCESS_KEY, :secret_access_key => SECRET_KEY}
    {:bucket => "digsouth", :access_key_id => "AKIAJ2JAJCRFE65F6HWQ", :secret_access_key => "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"}
  end

  before_create do |user|
    unique_users = User.where({first_name: /.*#{user.username}*/}).count
    if unique_users > 1
      user.username = user.username + (unique_users + 1).to_s
    end
  end
end
