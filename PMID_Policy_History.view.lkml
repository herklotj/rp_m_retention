view: pmid_policy_history {
  derived_table: {
    sql: SELECT
          *
          from
         lk_m_policy_history
        where annual_cover_start_dttm = schedule_cover_start_dttm and status = 'P' and cfi_ind=0
               and to_date(sysdate) > to_date(annual_cover_start_dttm) AND  (to_date(sysdate)- to_date(policy_start_date) ) <= 183
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

  dimension: 7_day_filter {
    type: number
    sql: CASE WHEN to_date(transaction_dttm) <= to_date(sysdate) - 6 THEN 1 else 0 END ;;
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

  measure: sales_173 {
    type: number
    sql: sum(case when aauicl_scheme='173' then aauicl_ind else 0.00 end) ;;
  }

  measure: broker_sales {
    type: number
    sql: sum(broker_ind) ;;
  }

  measure: Panel_Share_102  {
    type: number
    sql: ${sales_102}/${broker_sales} ;;
    value_format_name: percent_1
  }

  measure: Panel_Share_103  {
    type: number
    sql: ${sales_103}/${broker_sales} ;;
    value_format_name: percent_1
  }

  measure: Panel_Share_Total  {
    type: number
    sql: (${sales_103}+${sales_102})/${broker_sales} ;;
    value_format_name: percent_1
  }

  measure: commission_members {
    type: number
    sql: sum(broker_commission_102)/sum(net_written_premium_102) ;;
    value_format_name: percent_1
  }

  measure: commission_non_members {
    type: number
    sql: sum(broker_commission_103)/nullif(sum(net_written_premium_103),0) ;;
    value_format_name: percent_1
  }

  measure: commission_smart {
    type: number
    sql: sum(broker_commission_173)/nullif(sum(net_written_premium_173),0) ;;
    value_format_name: percent_1
  }

}
