require 'i18n_extensions'
module ApplicationHelper
  def display_hotel_menu
    hotel = Hotel.new
    if current_user && current_user.hotel
      hotel = Hotel.where('id = ?', current_user.hotel.id).first
    end
    if  can? 'Manage', hotel
      return true
    else
      return false
    end
  end

  def display_hotel_chain_menu
    hotel_chain = HotelChain.new
    if current_user && current_user.hotel && current_user.hotel.hotel_chain_id
      hotel_chain = HotelChain.where('id = ?', current_user.hotel.hotel_chain_id).first
    end
    if  can? 'Manage', hotel_chain
      return true
    else
      return false
    end
  end

  def display_hotel_brand_menu
    hotel_brand = HotelBrand.new
    if current_user && current_user.hotel && current_user.hotel.hotel_brand_id
      hotel_brand = HotelBrand.where('id = ?', current_user.hotel.hotel_brand_id).first
    end
    if  can? 'Manage', hotel_brand
      return true
    else
      return false
    end
  end

  def get_bypass_checkin(hotel_id)
    if Hotel.where('id = ? And checkin_bypass =?', hotel_id, 0).first
      return(true)
    else
      return(false)
    end
  end

  def get_entity_assigned_permission(role_id)
    if role_id
      if current_user.admin?
        @entities =  RolePermission.where('role_id = ? And value = ? And hotel_id is null', role_id, 1)
      else
        @entities =  RolePermission.where('role_id = ? And value = ? And hotel_id=?', role_id, 1, current_hotel.id)
      end
      return(@entities)
    else
      return(nil)
    end
  end

  def get_entity_not_assigned_permission(role_id)
    if role_id
      if current_user.admin?
        @entities =  RolePermission.where('role_id = ? And value = ? And hotel_id is null', role_id, 0)
      else
        @entities =  RolePermission.where('role_id = ? And value = ? And hotel_id=?', role_id, 0, current_hotel.id)
      end
      return(@entities)
    else
      return(nil)
    end
  end

  def  get_assigned_entity_name(entity_id)
    if entity_id
      return(Entity.where('id = ?', entity_id).pluck(:display_name).first)
    else
      return(nil)
    end
  end

  def  get_not_assigned_entity_name(entity_id)
    if entity_id
      return(Entity.where('id = ?', entity_id).pluck(:display_name).first)
    else
      return(nil)
    end
  end

  def get_permission_name(permission_id)
    if permission_id
      return(Permission.where('id = ?', permission_id).pluck(:name).first)
    else
      return(nil)
    end
  end

  def get_current_hotel_chain_logo
    hotel_chain_id = session[:hotel_chain_id]
    if hotel_chain_id.present?
      hotel_chain = HotelChain.find(hotel_chain_id)
      if hotel_chain
        return hotel_chain.icon
      end
    else
      '/assets/logo.png' # #TODO Need to replace with actual admin image logo url.
    end
  end

  def abbreviated_name(first_name,last_name)
   first_name.present? ? first_name.to_s.upcase[0] + ". " + last_name.to_s.upcase : last_name.to_s.upcase
  end

  def get_current_hotel_logo(reservation_hotel)
    hotel = reservation_hotel
    if hotel.present?
      return hotel.icon
    else
      '/assets/logo.png' # #TODO Need to replace with actual admin image logo url.
    end
  end

  # function returns symbol if currency code exists else will return currency code itself
  def get_currency_symbol(currency_code)
    currency_symbol_hash = { 'USD' => '$' }
    currency_symbol = currency_symbol_hash.key?(currency_code) ? currency_symbol_hash.fetch(currency_code) : currency_code
    currency_symbol
  end

  def logged_in?
    current_user ? true : false
  end

  def formatted_date(date)
    date.strftime("%Y-%m-%d")
  end

  def page_title
    divider = ' | '.html_safe

    app_base = Setting.community_name
    tagline = " #{divider} #{Setting.community_name}"
    title = app_base
    case controller.controller_name
    when 'base'
      title += tagline
    when 'pages'
      if @page && @page.title
        title = @page.title + divider + app_base + tagline
      end
    when 'posts'
      if @post && @post.title
        title = @post.title + divider + app_base + tagline
        title += (@post.tags.empty? ? '' : "#{divider}#{:keywords.l}: " + @post.tags[0...4].join(', '))
        @canonical_url = user_post_url(@post.user, @post)
      end
    when 'users'
      if @user && !@user.new_record? && @user.login
        title = @user.login
        title += divider + app_base + tagline
        @canonical_url = user_url(@user)
      else
        title = :showing_users.l + divider + app_base + tagline
      end
    when 'login'
      title = :login.l + divider + app_base + tagline
    end

    if @page_title
      title = @page_title + divider + app_base + tagline
    elsif title == app_base
      title = :showing.l + ' ' + controller.controller_name.humanize + divider + app_base + tagline
    end
    title
  end

  def computed_room_color(room_ready_status, checkin_inspected_only, fo_status)
    color_code = ''
    if room_ready_status
      if fo_status == VACANT
        map = { 'INSPECTED' => GREEN, 'CLEAN' => checkin_inspected_only == 'true' ? ORANGE : GREEN, 'PICKUP' => ORANGE, 'DIRTY' => RED }
        color_code = map[room_ready_status]
      else
        color_code = RED
      end
    end
    color_code
  end

  def map_created_at_time(created_at)
   date_difference = (Time.now.utc.to_date - created_at.utc.to_date).to_i
   if date_difference == 0 # same day
     created_at = created_at.strftime("%I:%M %p")
   elsif date_difference == 1
     created_at = "YESTERDAY"
   elsif date_difference <= 6
     created_at = created_at.strftime("%^A")
   else 
     created_at = created_at.strftime("%m/%d/%y")
   end
    created_at
  end


end
