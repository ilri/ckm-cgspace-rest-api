class CommunityCollection < ApplicationRecord
  self.primary_key = "id"
  self.table_name = "community2collection"

  belongs_to :community, foreign_key: "community_id"
  belongs_to :collection, foreign_key: "collection_id"
end