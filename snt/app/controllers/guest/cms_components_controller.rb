class Guest::CmsComponentsController < ApplicationController

  before_filter :check_session

  def sub_categories
    @parent_id = params[:parent_id]
    current_hotel = Hotel.find(params[:hotel_id]) unless current_hotel
    @parent_component = @parent_id.present? ? current_hotel.cms_components.find(@parent_id) : current_hotel.cms_components.sections.first
    @sub_categories = @parent_component.sub_categories.published
    @is_main_category =  @sub_categories.andand.first.andand.is_main_category
    @component_view_type = self.component_view_type
  end

  def component_view_type
    @is_main_category ? 'MAIN_CATEGORY' : @parent_component.component_type
  end
end
