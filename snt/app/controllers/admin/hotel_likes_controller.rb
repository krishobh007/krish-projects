class Admin::HotelLikesController < ApplicationController
  before_filter :check_session

  layout 'admin'
  def get_hotel_likes
    data,status,errors = {},SUCCESS,[]
    feature_types = FeatureType.for_hotel_or_system(current_hotel.id)
    active_feature_types = current_hotel.feature_types

    data = {
      likes: feature_types.map do |feature_type|
        {
          id: feature_type.id,
          name: feature_type.value,
          is_system_defined: feature_type.is_system_features_only.to_s,
          is_active: active_feature_types.include?(feature_type).to_s
        }
      end
    }

    respond_to do |format|
      format.html { render partial: 'admin/hotel_likes/likes_list', locals: { data: data, errors: [] } }
      format.json { render json: {status:status, data: data, errors: errors} }
    end
  end

  def edit_hotel_likes
    data,status,errors = {},SUCCESS,[]
    feature_type = FeatureType.find(params[:id])
    hotel_features = feature_type.features.for_hotel_or_system(current_hotel)

    # Ensure that the feature type is not system only (these are not editable)
    if feature_type.is_system_features_only
      fail 'Editing system only feature types is not allowed!'
    else

      if feature_type.is_system_type?
        # If the feature type is for all hotels

        active_features = current_hotel.features.with_feature_type(feature_type.value)

        data = {
          type: feature_type.value,
          id: feature_type.id.to_s,
          news_papers: hotel_features.map do |feature|
            {
              id: feature.id.to_s,
              name: feature.value,
              is_checked: active_features.include?(feature).to_s
            }
          end
        }

        url = 'admin/hotel_likes/system_feature_edit'
      else
        # The feature type is for the hotel only

        data = {
          id: feature_type.id.to_s,
          name: feature_type.value,
          type: feature_type.selection_type,
          is_system_defined: feature_type.is_system_features_only.to_s,
          show_on_room_setup: (!feature_type.hide_on_room_assignment).to_s,
          options: hotel_features.map do |feature|
            {
              id: feature.id,
              name: feature.value
            }
          end
        }

        url = 'admin/hotel_likes/edit_like'
      end
    end

    respond_to do |format|
      format.html { render partial: url, locals: { data: data, errors: [] } }
      format.json { render json: {status:status, data: data, errors: errors} }
    end
  end

  def add_feature_type
    data, errors, status = {}, [], FAILURE
    feature_type = FeatureType.find(params[:id]) if params[:id]

    current_features = []

    feature_type_attributes = {
      selection_type: params[:type],
      value: params[:name],
      hotel_id: current_hotel.id,
      hide_on_room_assignment: params[:show_on_room_setup] != 'true'
    }

    if feature_type.present?
      # Update feature type and add / update / remove features
      begin
        Feature.transaction do
          params[:options].andand.each_with_index do |feature, index|
            if feature[:id].present?
              # Update existing feature
              existing_feature = Feature.find(feature[:id])
              existing_feature.update_attributes!(value: feature[:name])

              current_features << existing_feature
            else
              # Add new feature
              new_feature = feature_type.features.build(value: feature[:name], hotel_id: current_hotel.id)

              # Link feature to hotel
              current_hotel.features << new_feature if current_hotel.feature_types.include?(feature_type)

              current_features << new_feature
            end
          end

          delete_unlisted_features(feature_type, current_features, current_hotel)

          # Reload feature type to ensure new features are correctly checked
          feature_type.reload

          feature_type.update_attributes!(feature_type_attributes)
        end
      rescue ActiveRecord::RecordInvalid => ex
        errors << ex.message
      end

    else
      # Create a new feature type with its features
      feature_type = FeatureType.new(feature_type_attributes)

      params[:options].andand.each do |feature|
        feature_type.features.build(value: feature[:name], hotel_id: current_hotel.id)
      end

      if feature_type.save
        # Activate the feature type and its features for the hotel
        current_hotel.feature_types << feature_type
        current_hotel.features << feature_type.features
      else
        errors += feature_type.errors.full_messages
      end
    end

    status = SUCCESS if errors.empty?

    render json: { status: status, data: data, errors: errors }
  end

  def activate_feature_type
    feature_type = FeatureType.find(params[:id])

    is_set_active = params[:set_active] == 'true'
    has_feature_type = current_hotel.feature_types.exists?(feature_type)

    if is_set_active && !has_feature_type
      # Add the feature type to this hotel
      current_hotel.feature_types << feature_type

      # Add the existing features (system or for the hotel) for this feature type to the hotel (if we don't have any already)
      if current_hotel.features.with_feature_type(feature_type.value).empty?
        current_hotel.features += feature_type.features.for_hotel_or_system(current_hotel)
      end
    elsif !is_set_active && has_feature_type
      # Delete the feature type for this hotel
      current_hotel.feature_types.delete(feature_type)

      # Delete all features for this feature type (ONLY FOR THIS HOTEL)
      current_hotel.features.delete(current_hotel.features.with_feature_type(feature_type.value))
    end

    render json: { status: SUCCESS, data: {}, errors: [] }
  end

  def save_custom_likes
    errors, status = [], FAILURE

    hotel_feature_type = FeatureType.find(params[:id])
    if current_hotel.feature_types.include?(hotel_feature_type)
      params[:custom_likes].andand.each_with_index do |hotel_feature, index|
        is_checked = hotel_feature[:is_checked] == 'true'

        if !hotel_feature[:id].present?
          new_feature = hotel_feature_type.features.create(value: hotel_feature[:name], hotel_id: current_hotel.id)
          current_hotel.features << new_feature if is_checked && new_feature.persisted?
        else
          existing_feature = Feature.find(hotel_feature[:id])
          existing_feature.update_attributes(value: hotel_feature[:name], hotel_id: current_hotel.id)

          if is_checked
            current_hotel.features << existing_feature unless current_hotel.features.include?(existing_feature)
          else
            current_hotel.features.delete(existing_feature) if current_hotel.features.include?(existing_feature)
          end
        end
      end

      status = SUCCESS
    else
      errors << I18n.t(:feature_type_off)
    end

    render json: { status: status, data: {}, errors: errors }
  end

  def delete_custom_feature
    errors, status = [], FAILURE

    feature = Feature.find(params[:id])

    if feature.hotel_id != current_hotel.id
      errors << I18n.t(:delete_system_feature)
    elsif !feature.is_delete_allowed?
      errors << I18n.t(:feature_delete_unallowed)
    else
      current_hotel.features.delete(feature) if current_hotel.features.include?(feature)
      feature.destroy

      status = SUCCESS
    end

    render json: { status: status, data: {}, errors: errors }
  end

  private

  # Delete the features no longer listed
  def delete_unlisted_features(feature_type, current_features, current_hotel)
    feature_type.features.for_hotel_or_system(current_hotel).each do |feature|
      if !current_features.include?(feature) && feature.is_delete_allowed?
        current_hotel.features.delete(feature) if current_hotel.features.include?(feature)
        feature.destroy
      end
    end
  end
end
