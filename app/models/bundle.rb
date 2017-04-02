class Bundle < ApplicationRecord
  self.primary_key = "bundle_id"
  self.table_name = "bundle"

  has_many :bundle_bitstreams, :foreign_key => "bundle_id"
  has_many :bitstreams, :through => :bundle_bitstreams
end