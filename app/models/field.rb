class Field < ApplicationRecord
  self.primary_key = "metadata_field_id"
  self.table_name = "metadatafieldregistry"

  belongs_to :field_type, foreign_key: "metadata_schema_id"
  has_many :metadata
end