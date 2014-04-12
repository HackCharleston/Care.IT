class User
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :token, type: String
  field :rule, type: String
  field :email, type: String
  field :finger_id, type: String
  field :finger, type: Boolean

  validates :user, presence: true, uniqueness: { case_sensitive: false }

  has_many :captures
end
