view: motor_renewals {
  derived_table: {
    sql:
  SELECT * FROM (

  SELECT l.*,
           COALESCE(ps.insurerquoteref,q.quote_id) AS quote_id,
           c.marginpricetest_indicator_desc,
           c.quote_dttm,
           case when c.protect_no_claims_bonus ='true' then c.quotedpremium_ap_notinclipt else c.quotedpremium_an_notinclipt end as invited_prem_pre_sb

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
                       AND   customer_quote_reference IN (SELECT DISTINCT concat('TIA',tia_reference_ly) FROM lk_m_retention)
                       GROUP BY customer_quote_reference, cover_start_dt) a


                   JOIN (SELECT quote_id,
                                cover_start_dt,
                                tid AS tid
                         FROM qs_cover
                         WHERE business_purpose = 'Renewal'
                         AND   customer_quote_reference IN (SELECT DISTINCT concat('TIA',tia_reference_ly) FROM lk_m_retention)) b
                         ON a.max_tid = b.tid AND customer_quote_reference = customer_quote_reference AND a.cover_start_dt = b.cover_start_dt) q

             ON concat ('TIA',l.tia_reference_ly) = q.customer_quote_reference AND l.policy_start_date = q.cover_start_dt

      LEFT JOIN qs_cover c ON COALESCE (ps.insurerquoteref,q.quote_id) = c.quote_id
      WHERE l.aauicl_hold = 1

) a

LEFT JOIN





(




SELECT * FROM


(

SELECT insurerquoteref,
       CASE WHEN transaction_type IN ('CrossQuote','Renewal') THEN (predicted_ad_freq*1.05 + predicted_ad_freq_b*1.11) / 2*(predicted_ad_sev*1.16 + predicted_ad_sev_b*1.25) / 2 +(predicted_tp_freq*0.92 + predicted_tp_freq_b*0.9) / 2*(predicted_tp_sev*1.23 + predicted_tp_sev_b*1.5) / 2 +(predicted_pi_freq*0.99 + predicted_pi_freq_b*1.06) / 2*(predicted_pi_sev*0.92 + predicted_pi_sev_b*0.85) / 2 +(predicted_ot_freq*0.9 + predicted_ot_freq_b*0.78) / 2*(predicted_ot_sev*2.02 + predicted_ot_sev_b*2.7) / 2 +(predicted_ws_freq*0.895 + predicted_ws_freq_b*0.83) / 2*(predicted_ws_sev*1.22 + predicted_ws_sev_b*1.42) / 2 + 18 ELSE (predicted_ad_freq*1.05 + predicted_ad_freq_b*1.11) / 2*(predicted_ad_sev*1.16 + predicted_ad_sev_b*1.25) / 2 +(predicted_tp_freq*0.92 + predicted_tp_freq_b*0.9) / 2*(predicted_tp_sev*1.23 + predicted_tp_sev_b*1.5) / 2 +(predicted_pi_freq*0.99 + predicted_pi_freq_b*1.06) / 2*(predicted_pi_sev*0.92 + predicted_pi_sev_b*0.85) / 2 +(predicted_ot_freq*0.9 + predicted_ot_freq_b*0.78) / 2*(predicted_ot_sev*2.02 + predicted_ot_sev_b*2.7) / 2 +(predicted_ws_freq*0.895 + predicted_ws_freq_b*0.83) / 2*(predicted_ws_sev*1.22 + predicted_ws_sev_b*1.42) / 2 + 18 END AS predicted_bc,
       scheme
FROM (SELECT ps.policy_reference_number,
             ps.scheme,
             ps.policy_transaction_type,
             ps.inception_date,
             ps.term_inception_date,
             ps.transaction_period_start_date,
             ps.insurerquoteref,
             ps.ncb_protected_rqrd,
             ps.act_gross_premium_net_commission_txd_amt AS net_prem,
             timestampdiff(YEAR,inception_date,term_inception_date) AS aauicl_tenure,
             fy.fy AS financial_year,
             trunc(to_date (c.quote_dttm),'iso-week') AS quote_week,
             trunc(to_date (ps.term_inception_date),'iso-week') AS inception_week,
       date_trunc('month',to_date (c.quote_dttm)) as quote_month,
       date_trunc('month',to_date (ps.term_inception_date)) as inception_month,
             CASE
               WHEN c.business_purpose IN ('CrossQuote','Renewal') THEN c.business_purpose
               WHEN policy_transaction_type IN ('RENEWAL_ACCEPT') THEN 'Renewal'
               ELSE 'NewBusiness'
             END transaction_type,
             c.rct_modelnumber AS model,
             c.consumer_name AS channel,
             c.marginpricetest_indicator_desc AS strategy,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_ad_freq_an
               ELSE s.predicted_ad_freq_ap
             END AS predicted_ad_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_ad_sev_an
               ELSE s.predicted_ad_sev_ap
             END AS predicted_ad_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_pi_freq_an
               ELSE s.predicted_pi_freq_ap
             END AS predicted_pi_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_pi_sev_an
               ELSE s.predicted_pi_sev_ap
             END AS predicted_pi_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_tpd_freq_an
               ELSE s.predicted_tpd_freq_ap
             END AS predicted_tp_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_tpd_sev_an
               ELSE s.predicted_tpd_sev_ap
             END AS predicted_tp_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_ot_freq_an
               ELSE s.predicted_ot_freq_ap
             END AS predicted_ot_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_ot_sev_an
               ELSE s.predicted_ot_sev_ap
             END AS predicted_ot_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_ws_freq_an
               ELSE s.predicted_ws_freq_ap
             END AS predicted_ws_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN s.predicted_ws_sev_an
               ELSE s.predicted_ws_sev_ap
             END AS predicted_ws_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_ad_freq_an
               ELSE b.predicted_ad_freq_ap
             END AS predicted_ad_freq_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_ad_sev_an
               ELSE b.predicted_ad_sev_ap
             END AS predicted_ad_sev_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_pi_freq_an
               ELSE b.predicted_pi_freq_ap
             END AS predicted_pi_freq_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_pi_sev_an
               ELSE b.predicted_pi_sev_ap
             END AS predicted_pi_sev_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_tpd_freq_an
               ELSE b.predicted_tpd_freq_ap
             END AS predicted_tp_freq_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_tpd_sev_an
               ELSE b.predicted_tpd_sev_ap
             END AS predicted_tp_sev_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_ot_freq_an
               ELSE b.predicted_ot_freq_ap
             END AS predicted_ot_freq_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_ot_sev_an
               ELSE b.predicted_ot_sev_ap
             END AS predicted_ot_sev_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_ws_freq_an
               ELSE b.predicted_ws_freq_ap
             END AS predicted_ws_freq_b,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN b.predicted_ws_sev_an
               ELSE b.predicted_ws_sev_ap
             END AS predicted_ws_sev_b,
             ia.ad_f,
             ia.ad_s,
             ia.tp_f,
             ia.tp_s,
             ia.pi_f,
             ia.pi_s,
             ia.ot_f,
             ia.ot_s,
             ia.ws_f,
             ia.ws_s,
             timestampdiff(MONTH,'2020-05-01',date_trunc ('month',term_inception_date)) AS inf_anchor
      FROM ice_aa_policy_summary ps
        JOIN financial_years fy
          ON fy.scheme = ps.scheme
         AND ps.term_inception_date >= fy.start_date
         AND ps.term_inception_date <= fy.end_date
        JOIN qs_cover c ON ps.insurerquoteref = c.quote_id
        JOIN uncalibrated_scores_mjul19 s ON ps.insurerquoteref = s.quote_id
        JOIN uncalibrated_scores b ON ps.insurerquoteref = b.quote_id
        CROSS JOIN inflation_assumptions ia
      WHERE ps.policy_transaction_type IN ('NEW_BUSINESS','RENEWAL_ACCEPT')) z


) a WHERE scheme = '102'



UNION




SELECT * FROM

(

SELECT insurerquoteref,
       CASE
            WHEN transaction_type IN ('CrossQuote','Renewal') THEN
              predicted_ad_freq*1.03*predicted_ad_sev*0.93 +
              predicted_tp_freq*1.18*predicted_tp_sev*1.37 +
              predicted_pi_freq*0.82*predicted_pi_sev*0.75 +
              predicted_ot_freq*0.83*predicted_ot_sev*0.90 +
              predicted_ws_freq*0.90*predicted_ws_sev*1.35 +
              18
            ELSE
              predicted_ad_freq*1.03*predicted_ad_sev*0.93 +
              predicted_tp_freq*1.18*predicted_tp_sev*1.37 +
              predicted_pi_freq*0.82*predicted_pi_sev*0.75 +
              predicted_ot_freq*0.83*predicted_ot_sev*0.90 +
              predicted_ws_freq*0.90*predicted_ws_sev*1.35 +
              18
            END AS predicted_bc,
            scheme
FROM (SELECT ps.policy_reference_number,
             ps.scheme,
             ps.policy_transaction_type,
             ps.inception_date,
             ps.term_inception_date,
             ps.transaction_period_start_date,
             ps.insurerquoteref,
             ps.ncb_protected_rqrd,
             ps.act_gross_premium_net_commission_txd_amt AS net_prem,
             timestampdiff(YEAR,inception_date,term_inception_date) AS aauicl_tenure,
             fy.fy AS financial_year,
             trunc(to_date (c.quote_dttm),'iso-week') AS quote_week,
             trunc(to_date (ps.term_inception_date),'iso-week') AS inception_week,
       date_trunc('month',to_date (c.quote_dttm)) as quote_month,
       date_trunc('month',to_date (ps.term_inception_date)) as inception_month,
             CASE
               WHEN c.business_purpose IN ('CrossQuote','Renewal') THEN c.business_purpose
               WHEN policy_transaction_type IN ('RENEWAL_ACCEPT') THEN 'Renewal'
               ELSE 'NewBusiness'
             END transaction_type,
             c.rct_modelnumber AS model,
             c.consumer_name AS channel,
             c.marginpricetest_indicator_desc AS strategy,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_ad_freq_an
               ELSE predicted_ad_freq_ap
             END AS predicted_ad_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_ad_sev_an
               ELSE predicted_ad_sev_ap
             END AS predicted_ad_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_pi_freq_an
               ELSE predicted_pi_freq_ap
             END AS predicted_pi_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_pi_sev_an
               ELSE predicted_pi_sev_ap
             END AS predicted_pi_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_tpd_freq_an
               ELSE predicted_tpd_freq_ap
             END AS predicted_tp_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_tpd_sev_an
               ELSE predicted_tpd_sev_ap
             END AS predicted_tp_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_ot_freq_an
               ELSE predicted_ot_freq_ap
             END AS predicted_ot_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_ot_sev_an
               ELSE predicted_ot_sev_ap
             END AS predicted_ot_sev,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_ws_freq_an
               ELSE predicted_ws_freq_ap
             END AS predicted_ws_freq,
             CASE
               WHEN ncb_protected_rqrd = 0 THEN predicted_ws_sev_an
               ELSE predicted_ws_sev_ap
             END AS predicted_ws_sev,
             ia.ad_f,
             ia.ad_s,
             ia.tp_f,
             ia.tp_s,
             ia.pi_f,
             ia.pi_s,
             ia.ot_f,
             ia.ot_s,
             ia.ws_f,
             ia.ws_s,
             timestampdiff(MONTH,'2020-05-01',date_trunc ('month',term_inception_date)) AS inf_anchor
      FROM ice_aa_policy_summary ps
        JOIN financial_years fy
          ON fy.scheme = ps.scheme
         AND ps.term_inception_date >= fy.start_date
         AND ps.term_inception_date <= fy.end_date
        JOIN qs_cover c ON ps.insurerquoteref = c.quote_id
        JOIN uncalibrated_scores_nmjul19 s ON ps.insurerquoteref = s.quote_id
        CROSS JOIN inflation_assumptions ia
      WHERE ps.policy_transaction_type IN ('NEW_BUSINESS','RENEWAL_ACCEPT')) z

) b WHERE scheme = '103'


) b ON a.quote_id = b.insurerquoteref AND (a.quote_id IS NOT NULL OR a.quote_id!= '')


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

  measure: total_renewed_broker{
    type: number
    sql:  sum(case when aauicl_hold = 1 and broker_ind = 1 then 1 else 0.0000 end) ;;
  }

  measure: total_renewed_broker_aauicl{
    type: number
    sql:  sum(case when aauicl_hold = 1 and broker_ind = 1 and aauicl_ind = 1 then 1 else 0.0000 end) ;;
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


  measure: aauicl_win_rate{
    type: number
    sql:  ${total_renewed_broker_aauicl} / greatest(${total_renewed_broker},1);;
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

  dimension: sboc_flag {
    type: number
    sql: case when (invited_prem_pre_sb IS NOT NULL OR invited_prem_pre_sb!= '') AND inv_premium_hol!= 0 AND (invited_prem_pre_sb - inv_premium_hol) > 1 then 1 else 0.0000 end  ;;

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

  measure: sboc_rate {
    type: number
    sql: sum (case when (invited_prem_pre_sb IS NOT NULL OR invited_prem_pre_sb!= '') AND inv_premium_hol!= 0 AND (invited_prem_pre_sb - inv_premium_hol) > 1 then 1 else 0.0000 end) /
         sum (case when (invited_prem_pre_sb IS NOT NULL OR invited_prem_pre_sb!= '') AND inv_premium_hol!= 0  then 1 else 0.00000000000000000000000001 end);;
    value_format_name: percent_1
  }


  measure: predicted_burning_cost{
    type: number
    sql: sum(case when predicted_bc IS NOT NULL OR predicted_bc!= '' then predicted_bc else 0.00 end) / sum(case when predicted_bc IS NOT NULL OR predicted_bc!= '' then 1.00 else 0.00 end);;
    value_format_name: gbp_0
  }



}
