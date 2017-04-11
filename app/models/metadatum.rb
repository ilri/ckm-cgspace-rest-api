class Metadatum < ApplicationRecord
  self.primary_key = "metadata_value_id"
  self.table_name = "metadatavalue"

  belongs_to :collection,  -> { where(resource_type_id: Rails.configuration.x.COLLECTION) }, :foreign_key => "resource_id"
  belongs_to :item, -> { where(resource_type_id: Rails.configuration.x.ITEM) }, :foreign_key => "resource_id"
  belongs_to :bitstream, -> { where(resource_type_id: Rails.configuration.x.BITSTREAM) }, :foreign_key => "resource_id"
  belongs_to :field, :foreign_key => "metadata_field_id"
end