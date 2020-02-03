view: trading_kpis {
  derived_table: {
    sql:
select
  pmid.*
  ,f.broker_nb_sales as broker_nb_sales_forecast
  ,f.nb_sales_102 as nb_102_sales_forecast
  ,f.nb_sales_103 as nb_103_sales_forecast
  ,f.broker_rnw_sales as broker_rnw_sales_forecast
  ,f.rnw_sales_102 as rnw_102_sales_forecast
  ,f.rnw_sales_103 as rnw_103_sales_forecast
  ,f.xq_sales_102 as xq_102_sales_forecast
  ,f.xq_sales_103 as xq_103_sales_forecast
  ,case when to_date(pmid.policy_start_mth) = (to_date(sysdate) - day(to_date(sysdate)) +1) then 'This Month'
        when months_between(pmid.policy_start_mth,(to_date(sysdate) - day(to_date(sysdate)) +1)) = 1 then 'Next Month'
        when months_between(pmid.policy_start_mth,(to_date(sysdate) - day(to_date(sysdate)) +1)) = -1 then 'Last Month'
        when months_between(pmid.policy_start_mth,(to_date(sysdate) - day(to_date(sysdate)) +1)) > 1 then 'Future Months'
        else 'Other' end as current_month
  ,case when pmid.policy_start_mth >= '2019-02-01' and pmid.policy_start_mth < '2020-02-01' then 'FY20'
        when pmid.policy_start_mth >= '2020-02-01' and pmid.policy_start_mth < '2021-02-01' then 'FY21'
        when pmid.policy_start_mth >= '2021-02-01' and pmid.policy_start_mth < '2022-02-01' then 'FY22'
        when pmid.policy_start_mth >= '2022-02-01' and pmid.policy_start_mth < '2023-02-01' then 'FY23'
        else 'Unknown' end as Financial_Year
from
  (
    select
      to_date(policy_start_mth) as policy_start_mth
      ,sum(case when nb_sw_flag = 'New Business' then aauicl_ind_102 else 0 end) as NB_sales_102_actual
      ,sum(case when nb_sw_flag = 'New Business' then aauicl_ind_103 else 0 end) as NB_sales_103_actual
      ,sum(case when nb_sw_flag = 'New Business' then broker_ind else 0 end) as NB_broker_sales_actual
      ,sum(case when nb_sw_flag = 'Renewal' then aauicl_ind_102 else 0 end) as RN_sales_102_actual
      ,sum(case when nb_sw_flag = 'Renewal' then aauicl_ind_103 else 0 end) as RN_sales_103_actual
      ,sum(case when nb_sw_flag = 'Renewal' then broker_ind else 0 end) as RN_broker_sales_actual
      ,sum(case when nb_sw_flag = 'Switch' then aauicl_ind_102 else 0 end) as SW_sales_102_actual
      ,sum(case when nb_sw_flag = 'Switch' then aauicl_ind_103 else 0 end) as SW_sales_103_actual
      ,sum(case when nb_sw_flag = 'Switch' then broker_ind else 0 end) as SW_broker_sales_actual
    from
      lk_m_policy_history
    where annual_cover_start_dttm = schedule_cover_start_dttm and status = 'P' and cfi_ind=0 and (to_date(sysdate) - to_date(annual_cover_start_dttm)) <= 365
    group by  policy_start_mth
  )pmid
left join
  lk_m_forecast f
  on pmid.policy_start_mth = f.inception_month
     ;;
  }

  dimension: policy_start_month{
    type: date_month
    sql:  policy_start_mth ;;
  }

  dimension: Financial_Year{
    type: string
    sql:  Financial_Year ;;
  }

  dimension: Current_Month {
    type: string
    sql:current_month;;
  }




  measure: broker_total_forecast {
    type: number
    sql: sum(broker_nb_sales_forecast + broker_rnw_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: broker_total_actuals {
    type: number
    sql: sum(nb_broker_sales_actual + rn_broker_sales_actual) ;;
    value_format_name: decimal_0
  }

  measure: broker_total_diff {
    type: number
    sql: ${broker_total_actuals}-${broker_total_forecast} ;;
    value_format_name: decimal_0
  }



  measure: aauicl_total_forecast {
    type: number
    sql: sum(nb_102_sales_forecast + nb_103_sales_forecast + rnw_102_sales_forecast + rnw_103_sales_forecast + xq_102_sales_forecast + xq_103_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: aauicl_total_actuals {
    type: number
    sql: sum(NB_sales_102_actual + NB_sales_103_actual + RN_sales_102_actual + RN_sales_103_actual + SW_sales_102_actual + SW_sales_103_actual) ;;
    value_format_name: decimal_0
  }

  measure: aauicl_total_diff {
    type: number
    sql: ${aauicl_total_actuals}-${aauicl_total_forecast} ;;
    value_format_name: decimal_0
  }



  measure: broker_nb_forecast {
    type: number
    sql: sum(broker_nb_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: broker_nb_actuals {
    type: number
    sql: sum(nb_broker_sales_actual) ;;
    value_format_name: decimal_0
  }

  measure: broker_nb_diff {
    type: number
    sql: ${broker_nb_actuals}-${broker_nb_forecast} ;;
    value_format_name: decimal_0
  }

  measure: 102_nb_actuals {
    type: number
    sql: sum(NB_sales_102_actual) ;;
    value_format_name: decimal_0
  }

  measure: 103_nb_actuals {
    type: number
    sql: sum(NB_sales_103_actual) ;;
    value_format_name: decimal_0
  }

  measure: 102_nb_forecast {
    type: number
    sql: sum(nb_102_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: 102_nb_diff {
    type: number
    sql: ${102_nb_actuals}-${102_nb_forecast};;
    value_format_name: decimal_0
  }

  measure: 103_nb_forecast {
    type: number
    sql: sum(nb_103_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: 103_nb_diff {
    type: number
    sql: ${103_nb_actuals}-${103_nb_forecast};;
    value_format_name: decimal_0
  }

  measure: 102_nb_share_forecast {
    type: number
    sql: ${102_nb_forecast}*1.00/${broker_nb_forecast}*1.00 ;;
    value_format_name: percent_0
  }

  measure: 103_nb_share_forecast {
    type: number
    sql: ${103_nb_forecast}*1.00/${broker_nb_forecast}*1.00 ;;
    value_format_name: percent_0
  }

  measure: aauicl_nb_share_forecast {
    type: number
    sql: (${103_nb_forecast}*1.00+${102_nb_forecast}*1.00)/${broker_nb_forecast}*1.00 ;;
    value_format_name: percent_0
  }

  measure: 102_nb_share_actual {
    type: number
    sql: ${102_nb_actuals}*1.00/${broker_nb_actuals}*1.00 ;;
    value_format_name: percent_0
  }

  measure: 103_nb_share_actual {
    type: number
    sql: ${103_nb_actuals}*1.00/${broker_nb_actuals}*1.00 ;;
    value_format_name: percent_0
  }

  measure: aauicl_nb_share_actual {
    type: number
    sql: (${103_nb_actuals}*1.00+${102_nb_actuals}*1.00)/${broker_nb_actuals}*1.00 ;;
    value_format_name: percent_0
  }

  measure: broker_rnw_forecast {
    type: number
    sql: sum(broker_rnw_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: broker_rn_actuals {
    type: number
    sql: sum(rn_broker_sales_actual) ;;
    value_format_name: decimal_0
  }

  measure: broker_rn_diff {
    type: number
    sql: ${broker_rn_actuals}-${broker_rnw_forecast} ;;
    value_format_name: decimal_0
  }

  measure: 102_rn_actuals {
    type: number
    sql: sum(rn_sales_102_actual) ;;
    value_format_name: decimal_0
  }

  measure: 103_rn_actuals {
    type: number
    sql: sum(rn_sales_103_actual) ;;
    value_format_name: decimal_0
  }

  measure: 102_rnw_forecast {
    type: number
    sql: sum(rnw_102_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: 102_rn_diff {
    type: number
    sql: ${102_rn_actuals}-${102_rnw_forecast};;
    value_format_name: decimal_0
  }

  measure: 103_rnw_forecast {
    type: number
    sql: sum(rnw_103_sales_forecast) ;;
    value_format_name: decimal_0
  }

  measure: 103_rn_diff {
    type: number
    sql: ${103_rn_actuals}-${103_rnw_forecast};;
    value_format_name: decimal_0
  }

  }
