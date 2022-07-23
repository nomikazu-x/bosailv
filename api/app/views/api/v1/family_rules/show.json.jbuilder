json.success true

json.family_rule do
  json.contact_means_memo @family_rule.contact_means_memo
  json.refuge_memo @family_rule.refuge_memo
  json.family_role_memo @family_rule.family_role_memo
  json.emergency_measure_memo @family_rule.emergency_measure_memo
  json.leave_home_memo @family_rule.leave_home_memo
  json.created_at @family_rule.created_at
  json.updated_at @family_rule.updated_at
end
