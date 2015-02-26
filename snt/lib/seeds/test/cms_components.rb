module CmsComponents
  def create_cms_components
    hotel = Hotel.first
    mycity = hotel.cms_components.create(name: 'MY_CITY', component_type: Setting.component_types[:section],
     status: Setting.component_status[:available])

    category1 = hotel.cms_components.create(name: 'CATEGORY1', component_type: Setting.component_types[:category],
     status: Setting.component_status[:available])
    category2 = hotel.cms_components.create(name: 'CATEGORY2', component_type: Setting.component_types[:category],
     status: Setting.component_status[:available])
    category3 = hotel.cms_components.create(name: 'CATEGORY3', component_type: Setting.component_types[:category],
     status: Setting.component_status[:draft])
    category4 = hotel.cms_components.create(name: 'CATEGORY4', component_type: Setting.component_types[:category],
     status: Setting.component_status[:available])
    category5 = hotel.cms_components.create(name: 'CATEGORY5', component_type: Setting.component_types[:category],
     status: Setting.component_status[:available])

    page1 = hotel.cms_components.create(name: 'PAGE1', component_type: Setting.component_types[:page],
     page_template: Setting.page_template[:poi], status: Setting.component_status[:available])
    page2 = hotel.cms_components.create(name: 'PAGE2', component_type: Setting.component_types[:page],
     page_template: Setting.page_template[:general], status: Setting.component_status[:draft])
    page3 = hotel.cms_components.create(name: 'PAGE3', component_type: Setting.component_types[:page],
     page_template: Setting.page_template[:link], status: Setting.component_status[:available])
    page4 = hotel.cms_components.create(name: 'PAGE4', component_type: Setting.component_types[:page],
     page_template: Setting.page_template[:poi], status: Setting.component_status[:available])

    ##------------- CREATING MAIN CATEGORIES FOR SECTION MY_CITY ----------------##
    CmsSectionComponent.create(parent_id: mycity.id, child_component_id: category1.id)
    CmsSectionComponent.create(parent_id: mycity.id, child_component_id: category2.id)
    CmsSectionComponent.create(parent_id: mycity.id, child_component_id: category3.id)
    CmsSectionComponent.create(parent_id: mycity.id, child_component_id: category4.id)

    ##------------- CREATING SUB CATEGORY FOR CATEGORY 4 ----------------##
    CmsSectionComponent.create(parent_id: category4.id, child_component_id: category5.id)

    ##--------------------- CREATING PAGES FOR EACH MAIN CATEGORIES  ----------------- ##
    CmsSectionComponent.create(parent_id: category1.id, child_component_id: page1.id)
    CmsSectionComponent.create(parent_id: category2.id, child_component_id: page2.id)
    CmsSectionComponent.create(parent_id: category3.id, child_component_id: page3.id)

    ##--------------------- CREATING PAGES FOR SUB_CATEGORY (CATEGORY5) ----------------- ##
    CmsSectionComponent.create(parent_id: category5.id, child_component_id: page4.id)
  end
end
