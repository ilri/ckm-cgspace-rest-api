class Community < ApplicationRecord
  self.primary_key = "community_id"
  self.table_name = "community"

  has_one :bitstreams, foreign_key: "resource_id"
  has_one :handle, -> {where(resource_type_id: Rails.configuration.x.COMMUNITY)}, foreign_key: "resource_id"

  has_many :metadata, -> {where(resource_type_id: Rails.configuration.x.COMMUNITY)}, foreign_key: "resource_id"

  has_many :children, through: :child_communities, source: :child
  has_many :child_communities, foreign_key: :parent_comm_id, class_name: "Subcommunity"

  has_one :parent, through: :parent_community, source: :parent
  has_one :parent_community, foreign_key: :child_comm_id, class_name: "Subcommunity"

  has_many :community_collections, foreign_key: :community_id, class_name: "CommunityCollection"
  has_many :collections, through: :community_collections, source: :collection

  def name
    self.metadata.each do |metadatum|
      if metadatum.field.field_type.short_id == 'dc' and metadatum.field.element == 'title'
        @title = metadatum.text_value
      end
    end
    @title
  end

  def getSubcommunityIds
    traverse(self, [])
  end

  def traverse(element, collector)
    collector.push(element.community_id)
    element.children.each do |child|
      traverse(child, collector)
    end
    collector
  end

end