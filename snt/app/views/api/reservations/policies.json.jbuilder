json.results do
  if @applied_policy.present?
    json.cancellation_policy_id @applied_policy.andand.id
    json.penalty_type @applied_policy.andand.amount_type
    json.penalty_value @applied_policy.andand.amount
    json.calculated_penalty_amount @penalty_charge
  end
    json.deposit_amount @current_payments
end 