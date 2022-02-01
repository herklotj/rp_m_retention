view: pmid_policy_history_motor {
  derived_table: {
    sql: SELECT
          *
          from
         lk_m_policy_history
        where annual_cover_start_dttm = schedule_cover_start_dttm and status = 'P' and cfi_ind=0

     ;;
  }


  dimension_group:policy_start_date  {
    type: time
    timeframes: [
      date
      ,week
      ,month
      ,year
    ]
    sql: annual_cover_start_dttm ;;
  }

  dimension_group:transaction_date  {
    type: time
    timeframes: [
      date
      ,week
      ,month
      ,year
    ]
    sql: transaction_dttm ;;
  }

  dimension: broker_nb_rb {
    type: string
    sql: broker_nb_rb ;;
  }

  dimension: channel {
    type: string
    sql: channel ;;
  }

  measure: sales_102 {
    type: number
    sql: sum(case when aauicl_scheme='102' then aauicl_ind else 0.00 end) ;;
  }

  measure: sales_103 {
    type: number
    sql: sum(case when aauicl_scheme='103' then aauicl_ind else 0.00 end) ;;
  }

  measure: broker_sales {
    type: number
    sql: sum(broker_ind) ;;
  }

  measure: Panel_Share_102  {
    type: number
    sql: ${sales_102}/(${broker_sales}-${sales_103}) ;;
    value_format_name: percent_1
  }

  measure: Panel_Share_103  {
    type: number
    sql: ${sales_103}/(${broker_sales}-${sales_102}) ;;
    value_format_name: percent_1
  }

  measure: Panel_Share_Total  {
    type: number
    sql: (${sales_103}+${sales_102})/${broker_sales} ;;
    value_format_name: percent_1
  }

  measure: commission_102 {
    type: number
    sql: sum(broker_commission_102)/sum(net_written_premium_102) ;;
    value_format_name: percent_1
  }

  measure: commission_103 {
    type: number
    sql: sum(broker_commission_103)/nullif(sum(net_written_premium_103),0) ;;
    value_format_name: percent_1
  }

}
