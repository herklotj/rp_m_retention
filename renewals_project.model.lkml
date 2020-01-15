connection: "echo_actian"

# include all the views
include: "*.view"
fiscal_month_offset: -11

datagroup: renewals_project_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: renewals_project_default_datagroup

explore: lk_m_retention {}
explore: pmid_policy_history {}
explore: trading_kpis {}
