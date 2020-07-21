view: motor_renewals {
  derived_table: {
    sql:
SELECT l.*,
       COALESCE(ps.insurerquoteref,q.quote_id) AS quote_id,
       c.marginpricetest_indicator_desc,
       c.quote_dttm
FROM lk_m_retention l
  LEFT JOIN ice_aa_policy_summary ps
         ON l.uw_policy_no = ps.policy_reference_number
        AND ps.policy_transaction_type = 'RENEWAL_ACCEPT'
        AND l.policy_start_date = to_date (ps.term_inception_date)
  LEFT JOIN (SELECT a.customer_quote_reference,
                    max_quote_dttm AS quote_dttm,
                    b.quote_id,
                    a.cover_start_dt
             FROM (SELECT customer_quote_reference,
                          cover_start_dt,
                          MAX(quote_dttm) AS max_quote_dttm,
                          MAX(tid) AS max_tid
                   FROM qs_cover
                   WHERE business_purpose = 'Renewal'
                   AND   customer_quote_reference IN (SELECT DISTINCT concat('TIA',tia_reference_ly)
                                                      FROM lk_m_retention)
                   GROUP BY customer_quote_reference,
                            cover_start_dt) a
               JOIN (SELECT quote_id,
                            cover_start_dt,
                            tid AS tid
                     FROM qs_cover
                     WHERE business_purpose = 'Renewal'
                     AND   customer_quote_reference IN (SELECT DISTINCT concat('TIA',tia_reference_ly)
                                                        FROM lk_m_retention)) b
                 ON a.max_tid = b.tid
                AND customer_quote_reference = customer_quote_reference
                AND a.cover_start_dt = b.cover_start_dt) q
         ON concat ('TIA',l.tia_reference_ly) = q.customer_quote_reference
        AND l.policy_start_date = q.cover_start_dt
  LEFT JOIN qs_cover c ON COALESCE (ps.insurerquoteref,q.quote_id) = c.quote_id
WHERE l.aauicl_hold = 1
        ;;
  }

  dimension_group: policy_start {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: to_timestamp(${TABLE}.policy_start_date) ;;
  }

  dimension_group:quote_dttm  {
    type: time
    timeframes: [
      date
      ,week
      ,month
      ,year
    ]
    sql: quote_dttm ;;
  }

  dimension: strategy {
    type: string
    sql:  ${TABLE}.marginpricetest_indicator_desc ;;
  }

  dimension: ly_aa_tenure {
    label: "LY AA Tenure"
    type: tier
    tiers: [0,1,2,3]
    style: integer
    sql: ${TABLE}.ly_aa_tenure ;;
  }

  measure: total_aauicl_hold {
    type: number
    sql: sum(case when aauicl_hold = 1 then 1 else 0.0000 end);;
  }

  measure: total_renewed_aauicl {
    type: number
    sql:  sum(case when broker_ind = 1 and aauicl_ind = 1 then 1 else 0.0000 end);;
  }

  measure: total_declined_quote {
    type: number
    sql:  sum(case when inv_premium_hol = 0 then 1 else 0.0000 end);;
  }

  measure: total_renewed_broker_non_aauicl {
    type: number
    sql:  sum(case when aauicl_ind = 0 and broker_ind = 1 then 1 else 0.0000 end);;
  }

  measure: total_non_aauicl_renew {
    type: number
    sql:  sum(case when aauicl_ind = 0 then 1 else 0.0000 end);;
  }


  measure: rentention_rate {
    type: number
    sql:  ${total_renewed_aauicl} / ${total_aauicl_hold};;
    value_format_name: percent_2
  }

  measure: decline_rate {
    type: number
    sql:  ${total_declined_quote} / ${total_aauicl_hold};;
    value_format_name: percent_2
  }

  measure: lost_to_panel_member{
    type: number
    sql:  ${total_renewed_broker_non_aauicl} / ${total_non_aauicl_renew};;
    value_format_name: percent_2
  }


}
