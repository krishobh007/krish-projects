class CheckinValidator
  def initialize(json_request)
    @missing_fields = []
    @json_data = json_request
  end

  def validate_json
    return validate_checkin  if @json_data['print_registration']
    return validate_checkin_email_folio  if @json_data['email_folio']
    return validate_checkin_issue_number if @json_data['approval_code']
  end

  def validate_checkin
    @missing_fields.push('key_track') unless  @json_data['get_key_track'].present?
    @missing_fields.push('print_registration') unless @json_data['print_registration'].present?
    @missing_fields
  end

  def validate_checkin_email_folio
  end

  def validate_checkin_approval_code
  end

  def validate_checkin_email_folio
  end
end
