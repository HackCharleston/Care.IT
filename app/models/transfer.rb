class Transfer
  include Mongoid::Document
  field :merchant_transfer, type: String
  field :angel_transfer, type: String
  field :total, type: String

  belongs_to :angel
  belongs_to :merchant
  belongs_to :user
end
