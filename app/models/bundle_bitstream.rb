class BundleBitstream < ApplicationRecord
  self.primary_key = "id"
  self.table_name = "bundle2bitstream"

  belongs_to :bundle, :foreign_key => "bundle_id"
  belongs_to :bitstream, :foreign_key => "bitstream_id"
end