  json.id @cms_component.id
  json.name @cms_component.name
  json.component_type @cms_component.component_type
  json.status @cms_component.status
  json.no_of_categories @cms_component.sub_categories.count
  json.parent_category @cms_component.parent_categories.where(component_type: 'CATEGORY')
  json.parent_section @cms_component.parent_categories.where(component_type: 'SECTION')
  json.icon @cms_component.icon.andand.image.andand.url(:thumb)
  json.page_template @cms_component.page_template
  json.image @cms_component.image.andand.image.andand.url(:thumb)
  json.description @cms_component.description
  json.address @cms_component.address
  json.phone @cms_component.phone
  json.website_url @cms_component.website_url
  json.latitude @cms_component.latitude
  json.longitude @cms_component.longitude
  json.last_updated @cms_component.updated_at