connection: "echo_aapricing"

# include all the views
include: "*.view"
fiscal_month_offset: -110

datagroup: renewals_project_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: renewals_project_default_datagroup

explore: lk_m_retention {}
explore: pmid_policy_history {}
explore: trading_kpis {}
explore: motor_renewals {}
explore: motor_sboc {}
explore: mtas {}
explore: pmid_policy_history_motor {}
explore: motor_fca_compliancy {}
explore: motor_rnl_enbp_ratio {}
