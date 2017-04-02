class Bitstream < ApplicationRecord
  self.primary_key = "bitstream_id"
  self.table_name = "bitstream"

  has_one :handle, :foreign_key => "resource_id"
  has_many :metadata, :foreign_key => "resource_id"
  has_many :fields, :through => :metadata
end