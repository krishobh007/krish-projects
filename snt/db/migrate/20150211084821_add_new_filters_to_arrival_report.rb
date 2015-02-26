class AddNewFiltersToArrivalReport < ActiveRecord::Migration
  def change
    Ref::ReportFilter.enumeration_model_updates_permitted = true

    Ref::ReportFilter.create(value: 'INCLUDE_COMPANYCARD_TA_GROUP', description: 'Include Company Card/TA/Group')
    Ref::ReportFilter.create(value: 'INCLUDE_GUARANTEE_TYPE', description: 'Include Guarantee Type')


    arrival_report = Report.find_by_title('Arrival')
    arrival_report.filters << Ref::ReportFilter[:INCLUDE_COMPANYCARD_TA_GROUP]
    arrival_report.filters << Ref::ReportFilter[:INCLUDE_GUARANTEE_TYPE]
  end
end
