json.status "success"
json.errors []

json.data do 
  json.is_main_category @is_main_category.to_s
  json.component_view_type @component_view_type.to_s
  json.parent_name @parent_component.name.to_s
  json.section_url @parent_component.website_url.to_s

  json.results @sub_categories.select{ |sub_category| sub_category.has_valid_branches? } do |sub_category|
    json.component_id sub_category.id
    json.component_name sub_category.name
    json.component_type sub_category.component_type
    json.status sub_category.status
    json.description sub_category.description
    json.icon_url sub_category.icon.andand.image.andand.url(:thumb).to_s
    json.icon_name sub_category.icon.andand.image.andand.name.to_s
    json.page_template sub_category.page_template.to_s
    json.image_url sub_category.image.andand.image.andand.url(:medium).to_s
    json.image_name sub_category.image.andand.image.andand.name.to_s
    json.phone sub_category.phone.to_s
    json.website_url sub_category.website_url.to_s
    json.last_updated sub_category.updated_at.to_i
    json.address_info do 
      json.address sub_category.address.to_s
      json.latitude sub_category.latitude.to_s
      json.longitude sub_category.longitude.to_s
    end
   end
end