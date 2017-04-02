class Metadatum < ApplicationRecord
  self.primary_key = "metadata_value_id"
  self.table_name = "metadatavalue"

  belongs_to :item, :foreign_key => "resource_id"
  belongs_to :bitstream, :foreign_key => "resource_id"
  belongs_to :field, :foreign_key => "metadata_field_id"
end