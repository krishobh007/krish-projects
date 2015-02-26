class AdminMenu < ActiveRecord::Base
  attr_accessible :name, :description, :display_order, :available_for

  translates :name, :description

  has_many :admin_menu_options

  validates :name, :available_for, presence: true
  validates :name, uniqueness: { scope: [:available_for], case_sensitive: false }

  AVAILABLE_FOR = %w(ADMIN HOTELADMIN)
  validates :available_for, inclusion: { in: AVAILABLE_FOR }

  # TODO: This will change to logged in user_id
  # To return the formatted menu and menu options hash for UI
  def self.get_components_hash(components, parent_id, user_book_marks, current_hotel)
    components_array = []
    my_components = parent_id ? components.where('parent_id = ?', parent_id) : components.where('parent_id IS NULL')
    my_components.each do |component|
      if component.require_standalone_pms && current_hotel && current_hotel.pms_type.present?
        next
       elsif component.require_external_pms && current_hotel && !current_hotel.pms_type.present?
        next
      else
        component_hash = {}
        component_hash['id'] = component.id
        component_hash['name'] = component.name
        component_hash['action_path'] =  current_hotel ? component.action_path.sub(':id', current_hotel.id.to_s) : component.action_path
        component_hash['is_group'] = component.is_group
        component_hash['icon_class'] =  component.icon_class
        component_hash['state'] =  component.action_state
        sub_components = []
        if component.is_group
          sub_components = get_components_hash(components, component.id, user_book_marks, current_hotel)
        end

        component_hash['sub_components'] =  sub_components

        # To check Bookmarked or not
        component_hash['is_bookmarked'] = user_book_marks.map(&:id).include?(component.id) ? true :  false

        components_array.push(component_hash)
      end
    end
    components_array
  end

  def self.get_menu_hash(current_user, current_hotel)
    # Check if admin/hotel_admin menus
    if current_user.admin?
      role_menu = 'ADMIN'
    else
      role_menu = 'HOTELADMIN'
    end
    menu_list = AdminMenu.where('available_for  = ?', role_menu)
    user_book_marks = current_user.admin_menu_options

    main_menu_array = []
    menu_list.each do |menu_item|

      main_menu_hash = {}
      main_menu_hash['menu_id'] = menu_item.id
      main_menu_hash['menu_name'] = menu_item.name
      main_menu_hash['header_name'] = menu_item.description

      # Adding Options menu
      components_array = get_components_hash(menu_item.admin_menu_options, parent_id = nil, user_book_marks, current_hotel)
      main_menu_hash['components'] = components_array
      main_menu_array.push(main_menu_hash)
    end
    # As per CICO-5427
    { 'menus' => main_menu_array, bookmarks: get_bookmarks(current_user, current_hotel), 'bookmark_count' => user_book_marks.count }
  end


  def self.get_bookmarks(current_user, current_hotel)
    bookmark_array = []
    my_book_mark = current_user.admin_menu_options
    my_book_mark.each do |admin_menu|
   if admin_menu.name == 'Ext. PMS Web Services' && current_hotel && current_hotel.pms_type.andand.value != 'OWS'
        next
      else
        bookmark_hash = {}
        bookmark_hash['id'] = admin_menu.id
        bookmark_hash['name'] = admin_menu.name
        bookmark_hash['icon_class'] =  admin_menu.icon_class
        bookmark_hash['state'] =  admin_menu.action_state

        # To check Bookmarked or not
        #component_hash['is_bookmarked'] = user_book_marks.map(&:admin_menu_option_id).include?(component.id) ? true :  false

        bookmark_array.push(bookmark_hash)
      end
    end
    bookmark_array
  end

end
