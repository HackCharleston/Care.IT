class Merchant
  include Mongoid::Document
  field :name, type: String
  field :token, type: String
  field :acc_no, type: String
  field :routing_no, type: String
  field :tax_id, type: String
  field :email, type: String, default: 'merchant@care.it'
  field :address, type: String
  field :devise, type: String

  validates :devise, presence: true, uniqueness: { case_sensitive: false }

  has_many :transfers
end