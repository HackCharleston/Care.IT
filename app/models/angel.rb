class Angel
  include Mongoid::Document
  field :name, type: String
  field :token, type: String
  field :acc_no, type: String
  field :routing_no, type: String
  field :tax_id, type: String
  field :email, type: String
  field :location, type: String

  has_many :transfers
end
