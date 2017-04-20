class Collection < ApplicationRecord
  self.primary_key = "collection_id"
  self.table_name = "collection"

  has_many :items
  has_many :metadata, -> { where(resource_type_id: Rails.configuration.x.COLLECTION) }, foreign_key: "resource_id"

  has_one :community, through: :community_collection
  has_one :community_collection, foreign_key: :collection_id

  has_many :items, through: :collection_items
  has_many :collection_items, foreign_key: :collection_id

  def name
    self.metadata.each do |metadatum|
      if metadatum.field.field_type.short_id == 'dc' and metadatum.field.element == 'title'
        @title = metadatum.text_value
      end
    end
    @title
  end
end