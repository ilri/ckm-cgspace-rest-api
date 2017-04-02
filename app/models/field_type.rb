class FieldType < ApplicationRecord
  self.primary_key = "metadata_schema_id"
  self.table_name = "metadataschemaregistry"

  has_many :fields
end