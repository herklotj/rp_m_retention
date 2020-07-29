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
    sql:  ${total_renewed_aauicl} / greatest(${total_aauicl_hold},1);;
    value_format_name: percent_2
  }

  measure: decline_rate {
    type: number
    sql:  ${total_declined_quote} / greatest(${total_aauicl_hold},1);;
    value_format_name: percent_2
  }

  measure: lost_to_panel_member{
    type: number
    sql:  ${total_renewed_broker_non_aauicl} / greatest(${total_non_aauicl_renew},1);;
    value_format_name: percent_2
  }

  dimension: aauicl_hold {
    type: number
    sql: ${TABLE}.aauicl_hold ;;
  }

  dimension: aauicl_ind {
    type: number
    sql: ${TABLE}.aauicl_ind ;;
  }

  dimension: inv_premium_hol {
    type: number
    sql: ${TABLE}.inv_premium_hol ;;
  }










  measure: aauicl_ly_gross_premium {
    label: "AAUICL LY Gross Premium"
    type:  sum
    sql: ${TABLE}.ly_premium+${TABLE}.ly_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ly_gross_premium_hol {
    label: "AAUICL LY Gross Premium HOL"
    type: sum
    sql: ${TABLE}.ly_premium+${TABLE}.ly_commission ;;
    filters: {
      field: inv_premium_hol
      value: "NOT 0"
    }
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
    hidden: yes
  }

  measure: aauicl_ly_gross_premium_ren {
    label: "AAUICL LY Gross Premium REN"
    type: sum
    sql: ${TABLE}.ly_premium+${TABLE}.ly_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_gross_premium {
    label: "AAUICL TY Gross Premium"
    type:  sum
    sql: ${TABLE}.net_written_premium+${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_gross_premium_hol {
    label: "AAUICL TY Gross Premium HOL"
    type: sum
    sql: ${TABLE}.inv_premium_hol+${TABLE}.inv_commission_hol ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
    hidden: yes
  }

  measure: aauicl_ty_gross_premium_ren {
    label: "AAUICL TY Gross Premium REN"
    type: sum
    sql: ${TABLE}.net_written_premium+${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }


  measure: aauicl_ly_net_premium {
    label: "AAUICL LY Net Premium"
    type:  sum
    sql: ${TABLE}.ly_premium ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ly_net_premium_hol {
    label: "AAUICL LY Net Premium HOL"
    type: sum
    sql: ${TABLE}.ly_premium ;;
    filters: {
      field: inv_premium_hol
      value: "NOT 0"
    }
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
    hidden: yes
  }

  measure: aauicl_ly_net_premium_ren {
    label: "AAUICL LY Net Premium REN"
    type: sum
    sql: ${TABLE}.ly_premium ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_net_premium {
    label: "AAUICL TY Net Premium"
    type:  sum
    sql: ${TABLE}.net_written_premium ;;
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_net_premium_hol {
    label: "AAUICL TY Net Premium HOL"
    type: sum
    sql: ${TABLE}.inv_premium_hol ;;
#    filters: {
#      field: inv_premium_hol
#      value: "NOT 0"
#    }
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
    hidden: yes
  }

  measure: aauicl_ty_net_premium_ren {
    label: "AAUICL TY Net Premium REN"
    type: sum
    sql: ${TABLE}.net_written_premium ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }


  measure: aauicl_ly_commission {
    label: "AAUICL LY Commission"
    type:  sum
    sql: ${TABLE}.ly_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ly_commission_hol {
    label: "AAUICL LY Commission HOL"
    type: sum
    sql: ${TABLE}.ly_commission ;;
    filters: {
      field: inv_premium_hol
      value: "NOT 0"
    }
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
    hidden: yes
  }

  measure: aauicl_ly_commission_ren {
    label: "AAUICL LY Commission REN"
    type: sum
    sql: ${TABLE}.ly_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_commission {
    label: "AAUICL TY Commission"
    type:  sum
    sql: ${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_commission_hol {
    label: "AAUICL TY Commission HOL"
    type: sum
    sql: ${TABLE}.inv_commission_hol ;;
#    filters: {
#      field: inv_premium_hol
#      value: "NOT 0"
#    }
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
    hidden: yes
  }

  measure: aauicl_ty_commission_ren {
    label: "AAUICL TY Commission REN"
    type: sum
    sql: ${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }









  measure: aauicl_yoy_gross_premium_change_hol {
    label: "AAUICL YoY Gross Premium Change HOL"
    type: number
    sql: (${aauicl_ty_gross_premium_hol}-${aauicl_ly_gross_premium_hol})/nullif(${aauicl_ly_gross_premium_hol},0) ;;
    value_format_name: percent_1
  }


  measure: aauicl_yoy_gross_premium_change_ren {
    label: "AAUICL YoY Gross Premium Change REN"
    type: number
    sql: (${aauicl_ty_gross_premium_ren}-${aauicl_ly_gross_premium_ren})/nullif(${aauicl_ly_gross_premium_ren},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_net_premium_change_hol {
    label: "AAUICL YoY Net Premium Change HOL"
    type: number
    sql: (${aauicl_ty_net_premium_hol}-${aauicl_ly_net_premium_hol})/nullif(${aauicl_ly_net_premium_hol},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_net_premium_change_ren {
    label: "AAUICL YoY Net Premium Change REN"
    type: number
    sql: (${aauicl_ty_net_premium_ren}-${aauicl_ly_net_premium_ren})/nullif(${aauicl_ly_net_premium_ren},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_net_premium_change_hol_per_ly_gross {
    label: "AAUICL YoY Net Premium Change HOL (% of LY Gross)"
    type: number
    sql: (${aauicl_ty_net_premium_hol}-${aauicl_ly_net_premium_hol})/nullif(${aauicl_ly_gross_premium_hol},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_net_premium_change_hol_per_ly_net {
    label: "AAUICL YoY Net Premium Change HOL (% of LY Net)"
    type: number
    sql: (${aauicl_ty_net_premium_hol}-${aauicl_ly_net_premium_hol})/nullif(${aauicl_ly_net_premium_hol},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_net_premium_change_ren_per_ly_gross {
    label: "AAUICL YoY Net Premium Change REN (% of LY Gross)"
    type: number
    sql: (${aauicl_ty_net_premium_ren}-${aauicl_ly_net_premium_ren})/nullif(${aauicl_ly_gross_premium_ren},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_net_premium_change_ren_per_ly_net {
    label: "AAUICL YoY Net Premium Change REN (% of LY Net)"
    type: number
    sql: (${aauicl_ty_net_premium_ren}-${aauicl_ly_net_premium_ren})/nullif(${aauicl_ly_net_premium_ren},0) ;;
    value_format_name: percent_1
  }


  measure: aauicl_yoy_commission_change_hol_per_ly_gross {
    label: "AAUICL YoY Commission Change HOL (% of LY Gross)"
    type: number
    sql: (${aauicl_ty_commission_hol}-${aauicl_ly_commission_hol})/nullif(${aauicl_ly_gross_premium_hol},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_yoy_commission_change_ren_per_ly_gross {
    label: "AAUICL YoY Commission Change REN (% of LY Gross)"
    type: number
    sql: (${aauicl_ty_commission_ren}-${aauicl_ly_commission_ren})/nullif(${aauicl_ly_gross_premium_ren},0) ;;
    value_format_name: percent_1
  }



}
