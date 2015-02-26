class Api::CmsComponentsController < ApplicationController
  before_filter :check_session
  after_filter :set_parent_last_updated, :only => [:save, :destroy]

  # Method to display all the created components
  def index
    @cms_components = current_hotel.cms_components
  end

  # Method to display all the sub categories in tree view
  def tree_view
    @cms_components = current_hotel.cms_components.sections
  end

  def show
    @cms_component = current_hotel.cms_components.find(params[:id])
  end

  # Method to save the cms components
  def save
    cms_component = params[:id].present? ? current_hotel.cms_components.find(params[:id]) : current_hotel.cms_components.new
    @cms_component = cms_component
    previous_status = cms_component.status if params[:id].present?
    update_count = 0
    begin
      parent_categories = []
      existing_parent_catgories = cms_component.parent_categories
      @cms_component.save_component_attributes(params)
      if params[:parent_category].present?
        parent_category = params[:parent_category].map { |x| x[:id] }
        parent_categories += current_hotel.cms_components.where("id in (?)", parent_category)
      end
      # Assigning Parent category and Parent section
      if params[:parent_section].present?
        parent_category = params[:parent_section].map { |x| x[:id] }
        parent_categories += current_hotel.cms_components.where("id in (?)", parent_category)
      end
      
      newly_assigned_parents = (params[:parent_section].present? || params[:parent_category].present?) ? (parent_categories-existing_parent_catgories) : [] 
      newly_removed_parents = (params[:parent_section].present? || params[:parent_category].present?) ? (existing_parent_catgories-parent_categories) : []
      @cms_component.parent_categories = parent_categories 
      
      is_status_change = previous_status.nil? ? false : (previous_status != @cms_component.status)
      
      if @cms_component.is_page? && !is_status_change && @cms_component.status
        update_count = 1 
      elsif @cms_component.is_page? && is_status_change
        update_count =  @cms_component.status ? 1 : -1
        newly_assigned_parents =  @cms_component.parent_categories
      elsif @cms_component.valid_branch_count > 0 && !is_status_change && @cms_component.status
        update_count = @cms_component.valid_branch_count 
      elsif @cms_component.valid_branch_count > 0 && is_status_change
        update_count =  @cms_component.status ? @cms_component.valid_branch_count : -@cms_component.valid_branch_count
        newly_assigned_parents =  @cms_component.parent_categories
      end
      
      @cms_component.update_branch_count(newly_assigned_parents, update_count) unless update_count != 0 && newly_assigned_parents.empty?
      @cms_component.update_branch_count(newly_removed_parents, -update_count) unless update_count !=0 && newly_removed_parents.empty?
    
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
    end
  end

  # Method to delete a cms component
  def destroy
    update_count = 0
    @cms_component = current_hotel.cms_components.find(params[:id])
    @cms_component.sub_categories = []
    if @cms_component.is_page?
      update_count = -1
    elsif @cms_component.valid_branch_count > 0
      update_count = -@cms_component.valid_branch_count
    end
    @cms_component.update_branch_count(@cms_component.parent_categories, update_count)

    @cms_component.parent_categories = []
    @cms_component.destroy || render(json: @cms_component.errors.full_messages, status: :unprocessable_entity)
  end

  # Method to display the sub categories, called during delete confirmation
  def sub_categories
    @parent_id = params[:parent_id]
    @parent_component = @parent_id.present? ? current_hotel.cms_components.find(@parent_id) : current_hotel.cms_components.sections.first
    @sub_categories = @parent_component.sub_categories.published
    @is_main_category =  @sub_categories.andand.first.andand.is_main_category
  end

  def set_parent_last_updated
    @cms_component.parent_categories do | parent_category |
       parent_category.update_attribute(:updated_at, Time.now)
    end
  end
end
