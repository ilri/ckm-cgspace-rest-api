class ItemSerializer < ApplicationSerializer
  attribute :item_id, key: :id
  attribute :handle do
    self.full_handle
  end

  attribute :thumbnail do
    self.thumbnail
  end

  has_many :metadata

  def thumbnail
    object.bitstreams.each do |bitstream|
      bitstream.metadata.each do |metadatum|
        if metadatum.text_value.end_with?(".jpg") then
          @thumb = metadatum.text_value
        end
      end
    end

    if !@thumb.nil? then
      CgspaceRestApi::Application.config.base_thumbnail_url + "#{self.handle}/#{@thumb}"
    else
      CgspaceRestApi::Application.config.default_thumbnail_url
    end
  end

  def handle
    !object.handle.nil? ? object.handle.handle : ''
  end

  def full_handle
    !object.handle.nil? ? CgspaceRestApi::Application.config.base_handle_url + object.handle.handle : ''
  end
end
