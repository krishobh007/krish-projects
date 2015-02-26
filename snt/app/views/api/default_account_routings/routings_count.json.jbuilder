json.travel_agent do 
  json.routings_count @travel_agent.default_account_routings.count
end if @travel_agent.present?

json.company do
  json.routings_count @company_card.default_account_routings.count
end if @company_card.present?

json.has_conflicting_routes @has_conflicting_routes