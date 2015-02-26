json.array! @cms_components.order('name') do |cms_section|
   json.array! cms_section.to_node
end