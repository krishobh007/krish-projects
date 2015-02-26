class Api::ReferenceValuesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  # List reference values for the type
  def index
    # Get the reference class name
    ref_class_name = "Ref::#{params[:type].to_s.camelize}"

    # Get the reference class
    ref_class = ref_class_name.safe_constantize

    # Query for results ordered by description, if the class names are equal
    @reference_values = ref_class.andand.name == ref_class_name ? ref_class.order(:description) : []
  end
end
