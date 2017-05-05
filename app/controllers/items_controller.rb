class ItemsController < ApplicationController
=begin
@api {get} /items/ Request CGSpace Items
@apiName GetItems
@apiGroup Item
@apiVersion 0.2.0

@apiDescription Use this endpoint to fetch items from [CGSpace](https://cgspace.cgiar.org/). It allows querying
for items using the following options:
  - **Community** - the community under which the items are found
  - **Collection** - the immediate owning collection of items
  - **Metadata** - any metadata associated with the items. A metadatum is specified using a combination of **four(4)** parameters:
      - *namespace* - the short id for the metadatum schema, `e.g. dc, cg, etc.`
      - *element* - the second level descriptor used to identify the metadatum field, `e.g. date, authorship, etc.`
      - *qualifier* - the third level descriptor used to identify the metadatum field, `e.g. accessioned, types, etc.`
      - *value* - the actual value of the metadatum to search for, `e.g. 2017-04-20T12:08:34Z, CGIAR and advanced research institute`
  - **Options** - general purpose filtering options:
      - *page* - the page number to fetch
      - *limit* - the maximum number of items to return per page

>**Note:** To filter result by multiple metadata, separate each metadatum value using the `|` character, for example:
>
>`/items?namespace=cg|dc&element=subject|date&qualifier=ilri|issued&value=LIVESTOCK|2016-04` would mean filter items with metadata
>entries `cg.subject.ilri` containing `LIVESTOCK` and `dc.date.issued` containing `2016-04`.

@apiParam {Number} [community] The CGSpace community id under which the Items would be found.
@apiParam {Number} [collection] The id of the owning collection of the Items.
@apiParam {String} [namespace] The namespace of the Item metadata. Use the pipe `|` character for multiple values, e.g. `namespace=cg|dc`
@apiParam {String} [element] The element of the Item metadata. Use the pipe `|` character for multiple values, e.g. `element=subject|date`
@apiParam {String} [qualifier] The qualifier of the Item metadata. Use the pipe `|` character for multiple values, e.g. `qualifier=ilri|issued`
@apiParam {String} [value] The value of the Item metadata. Use the pipe `|` character for multiple values, e.g. `value=LIVESTOCK|2016-04`. These values are case insensitive; meaning `LIVESTOCK` and `livestock` would give the same results.
@apiParam {Number} [page] The page number of the Items list to fetch.
@apiParam {Number} [limit] The maximum number of elements to get per page, the highest value is 20.

@apiSuccess {Object[]} items Items from CGSpace.
@apiSuccess {Object} options Options used in querying for items including parameters sent.

@apiSampleRequest /items

@apiParamExample {json} Request-Example:
// Example Request 1: /items?community=1
{
  "community": 1
}

@apiSuccessExample {json} Success-Response:
// Example Response 1: /items?community=1
HTTP/1.1 200 OK
{
  "options": {
    "current_page": 1,
    "next_page": 2,
    "prev_page": null,
    "total_pages": 675,
    "total_count": 13489,
    "params": {
      "community": "1"
    }
  },
  "items": [
    {
      "id": 35504,
      "collection": "ILRI publishing resources",
      "handle": "https://dspacetest.cgiar.org/handle/10568/34339",
      "thumbnail": "https://dspacetest.cgiar.org/bitstream/handle/10568/34339/ILRI_MediaBriefing_Template.pdf.jpg",
      "metadata": [
        {
          "value": "Template",
          "element": "type",
          "qualifier": null,
          "namespace": "dc"
        },
        {
          "value": "2016-12-31",
          "element": "date",
          "qualifier": "issued",
          "namespace": "dc"
        },
        {
          "value": "ILRI. 2016. ILRI media briefing template. Nairobi, Kenya: ILRI.",
          "element": "identifier",
          "qualifier": "citation",
          "namespace": "dc"
        },
        ... // More Metadata entries
      ]
    }
    ... // Maximum of 20 items
  ]
}

=end
  def index
    @options = self.options(params)
    @paramGroups = self.groupParams(params)

    @items = Item.select('item.*, sorting_metadata.text_value')
                 .paginate(page: @options[:page], per_page: @options[:limit])
                 .joins('INNER JOIN "metadatavalue" AS "sorting_metadata" ON "item"."item_id" = "sorting_metadata"."resource_id"')
                 .where("sorting_metadata.metadata_field_id = 15") # dc.date.issued
                 .order("sorting_metadata.text_value DESC")
                 .distinct

    @items = @items.joins(:field_types)

    @paramGroups.each_with_index do |group, index|
      @items = @items.where("item.item_id in (?) AND item.in_archive = true AND item.discoverable = true", Item.with_metadatum(group))
    end

    if params[:community].present?
      @community = Community.find(params[:community])
      @items = @items.joins(:communities).where("community.community_id IN (?)", @community.getSubcommunityIds) if @community.present?
    end

    @items = @items.where(owning_collection: params[:collection]) if params[:collection].present?

    response = {
        options: meta_attributes(@items, {params: params.except(:page, :controller, :action)}),
        items: ActiveModel::Serializer::CollectionSerializer.new(@items, each_serializer: ItemSerializer, root: false)
    }

    render json: response
  end

  def groupParams(params)
    @namespaces = params[:namespace] ? params[:namespace].split("|") : []
    @qualifiers = params[:qualifier] ? params[:qualifier].split("|") : []
    @elements = params[:element] ? params[:element].split("|") : []
    @values = params[:value] ? params[:value].split("|") : []
    @groupedParams = []
    @maxParamNumbers = [@namespaces.length, @elements.length, @qualifiers.length, @values.length].max

    for index in 0...@maxParamNumbers do
      @paramGroup = {}
      @paramGroup[:namespace] = @namespaces[index] if @namespaces and @namespaces[index].present?
      @paramGroup[:element] = @elements[index] if @elements and @elements[index].present?
      @paramGroup[:qualifier] = @qualifiers[index] if @qualifiers and @qualifiers[index].present?
      @paramGroup[:value] = @values[index] if @values and @values[index].present?
      @groupedParams.push(@paramGroup)
    end

    @groupedParams
  end

  def options(params)
    {
        page: params[:page] && params[:page] != '' ? params[:page].to_i : Rails.configuration.x.PAGE,
        limit: params[:limit] && params[:limit] != '' ? self.least(params[:limit].to_i, Rails.configuration.x.LIMIT) : Rails.configuration.x.LIMIT
    }
  end

  def least(first, second)
    first > second ? second : first
  end

  def meta_attributes(collection, extra_meta = {})
    {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.previous_page,
        total_pages: collection.total_pages,
        total_count: collection.total_entries
    }.merge(extra_meta)
  end

end