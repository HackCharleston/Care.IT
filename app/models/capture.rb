class Capture
  include Mongoid::Document
  field :location, type: String
  field :time, type: String

  belongs_to :user
end
