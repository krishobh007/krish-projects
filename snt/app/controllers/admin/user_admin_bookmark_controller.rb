class Admin::UserAdminBookmarkController < ApplicationController
  before_filter :check_session

  # Create admin_menu bookmark
  def create
    # logger.debug '# '*16
    # logger.debug 'Create admin_menu bookmark'
    begin
      AdminMenuOption.find(params[:id])
      user_admin_bookmark = UserAdminBookmark.new
      user_admin_bookmark.admin_menu_option_id = params[:id]

      user_admin_bookmark.user_id = current_user.id
      if user_admin_bookmark.save
        render json: { status: SUCCESS, data: '', errors: '' }
      else
        render json: { status: FAILURE, data: '', errors: user_admin_bookmark.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { status: 'failure', data: '', errors: e.message }
    end
  end

  # Delete admin_menu bookmark
  def destroy
    # logger.debug '# '*16
    # logger.debug 'Destroy admin_menu bookmark'
    errors = []
    user_admin_bookmark = UserAdminBookmark.find_by_user_id_and_admin_menu_option_id(current_user.id, params[:id])
    if user_admin_bookmark
      user_admin_bookmark.destroy
      render json: { status: 'success', errors: errors }
    else
      render json: { status: 'failure', errors: ['BookMark Not Found'] }
    end
  end
end
