view: motor_renewals {
  derived_table: {
    sql:
SELECT * FROM lk_m_retention a
LEFT JOIN

(SELECT customer_quote_reference, max_quote_dttm AS quote_dttm, quote_id, marginpricetest_indicator_desc, cover_start_dt FROM

(SELECT customer_quote_reference, MAX(quote_dttm) AS max_quote_dttm, MAX(tid) AS max_tid FROM qs_cover WHERE business_purpose = 'Renewal' GROUP BY customer_quote_reference) a
JOIN
(SELECT quote_id, marginpricetest_indicator_desc, cover_start_dt, tid AS tid FROM qs_cover WHERE business_purpose = 'Renewal') b
ON a.max_tid = b.tid AND customer_quote_reference = customer_quote_reference) b

ON concat ('TIA',a.tia_reference_ly) = b.customer_quote_reference AND a.policy_start_date = b.cover_start_dt
WHERE a.aauicl_hold = 1



        ;;
  }

  dimension_group: inception_week {
    type: time
    timeframes: [date, week, month, year]
    sql:to_timestamp(${TABLE}.max_quote_dttm) ;;
  }

  dimension: strategy {
    type: string
    sql:  ${TABLE}.marginpricetest_indicator_desc ;;
  }

  dimension: ly_aa_tenure {
    type: tier
    tiers: [0,1,2,3,4,5,6,7,8,9,10]
    style: integer
    sql: ${TABLE}.ly_aa_tenure ;;
  }

  measure: total_aauicl_hold {
    type: number
    sql: sum(case when aauicl_hold = 1 then 1 else 0 end);;
  }

  measure: total_renewed_aauicl {
    type: number
    sql:  sum(case when broker_ind = 1 and aauicl_ind = 1 then 1 else 0 end);;
  }

  measure: total_declined_quote {
    type: number
    sql:  sum(case when inv_premium_hol = 0 then 1 else 0 end);;
  }

  measure: total_renewed_broker_non_aauicl {
    type: number
    sql:  sum(case when aauicl_ind = 0 and broker_ind = 1 then 1 else 0 end);;
  }

  measure: total_non_aauicl_renew {
    type: number
    sql:  sum(case when aauicl_ind = 0 then 1 else 0 end);;
  }

  measure: rentention_rate {
    type: number
    sql:  ${total_renewed_aauicl} / ${total_aauicl_hold};;
  }

  measure: decline_rate {
    type: number
    sql:  ${total_declined_quote} / ${total_aauicl_hold};;
  }

  measure: lost_to_panel_member{
    type: number
    sql:  ${total_renewed_broker_non_aauicl} / ${total_non_aauicl_renew};;
  }


}
