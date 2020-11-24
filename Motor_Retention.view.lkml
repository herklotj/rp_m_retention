view: lk_m_retention {
  sql_table_name: actian.lk_m_retention ;;

  dimension: aauicl_cfi_ind {
    type: number
    sql: ${TABLE}.aauicl_cfi_ind ;;
  }

  dimension: aauicl_cfi_ind_lapse {
    type: number
    sql: ${TABLE}.aauicl_cfi_ind_lapse ;;
  }

  dimension: aauicl_hold {
    type: number
    sql: ${TABLE}.aauicl_hold ;;
  }

  dimension: aauicl_ind {
    type: number
    sql: ${TABLE}.aauicl_ind ;;
  }

  dimension: broker_cfi_ind {
    type: number
    sql: ${TABLE}.broker_cfi_ind ;;
  }

  dimension: broker_cfi_ind_lapse {
    type: number
    sql: ${TABLE}.broker_cfi_ind_lapse ;;
  }

  dimension: broker_commission {
    type: number
    sql: ${TABLE}.broker_commission ;;
  }

  dimension: broker_hold {
    type: number
    sql: ${TABLE}.broker_hold ;;
  }

  dimension: broker_ind {
    type: number
    sql: ${TABLE}.broker_ind ;;
  }

  dimension: cancel_cooling {
    type: number
    sql: ${TABLE}.cancel_cooling ;;
  }

  dimension_group: cfi_dttm {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.cfi_dttm ;;
  }

  dimension: cfi_reason {
    type: string
    sql: ${TABLE}.cfi_reason ;;
  }

  dimension: cfi_status {
    type: string
    sql: ${TABLE}.cfi_status ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: cover_type {
    type: number
    sql: ${TABLE}.cover_type ;;
  }

  dimension: day_of_birth {
    type: string
    sql: ${TABLE}.day_of_birth ;;
  }

  dimension: hol_ly_commission {
    type: number
    sql: ${TABLE}.hol_ly_commission ;;
  }

  dimension: hol_ly_premium {
    type: number
    sql: ${TABLE}.hol_ly_premium ;;
  }

  dimension: inv_commission {
    type: number
    sql: ${TABLE}.inv_commission ;;
  }

  dimension: inv_commission_hol {
    type: number
    sql: ${TABLE}.inv_commission_hol ;;
  }

  dimension: inv_ipt_rate {
    type: number
    sql: ${TABLE}.inv_ipt_rate ;;
  }

  dimension: inv_ipt_rate_hol {
    type: number
    sql: ${TABLE}.inv_ipt_rate_hol ;;
  }

  dimension: inv_ly_commission {
    type: number
    sql: ${TABLE}.inv_ly_commission ;;
  }

  dimension: inv_ly_premium {
    type: number
    sql: ${TABLE}.inv_ly_premium ;;
  }

  dimension: inv_premium {
    type: number
    sql: ${TABLE}.inv_premium ;;
  }

  dimension: inv_premium_hol {
    type: number
    sql: ${TABLE}.inv_premium_hol ;;
  }

  dimension: ipt_amount {
    type: number
    sql: ${TABLE}.ipt_amount ;;
  }

  dimension_group: load_dttm {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.load_dttm ;;
  }

  dimension: ly_aa_membership {
    type: string
    sql: ${TABLE}.ly_aa_membership ;;
  }

  dimension: ly_aa_tenure_v3 {
    label: "LY AA Tenure (3)"
    type: tier
    tiers: [0,1,2]
    style: integer
    sql: ${TABLE}.ly_aa_tenure ;;
  }

  dimension: ly_aa_tenure {
    label: "LY AA Tenure (5)"
    type: tier
    tiers: [0,1,2,3,4,5]
    style: integer
    sql: ${TABLE}.ly_aa_tenure ;;
  }

  dimension: ly_aa_tenure_v2 {
    label: "LY AA Tenure (10)"
    type: tier
    tiers: [0,1,2,3,4,5,6,7,8,9,10]
    style: integer
    sql: ${TABLE}.ly_aa_tenure ;;
  }

  dimension: ly_aauicl_scheme {
    type: string
    sql: ${TABLE}.ly_aauicl_scheme ;;
  }

  dimension: ly_broker_nb_rb {
    type: string
    sql: ${TABLE}.ly_broker_nb_rb ;;
  }

  dimension: ly_commission {
    type: number
    sql: ${TABLE}.ly_commission ;;
  }

  dimension: ly_installment_flag {
    type: string
    sql: ${TABLE}.ly_installment_flag ;;
  }

  dimension: ly_insurer_nb_rb {
    type: string
    sql: ${TABLE}.ly_insurer_nb_rb ;;
  }

  dimension: ly_ipt_amount {
    type: number
    sql: ${TABLE}.ly_ipt_amount ;;
  }

  dimension: ly_premium {
    type: number
    sql: ${TABLE}.ly_premium ;;
  }

  dimension: ly_uw_tenure {
    type: number
    sql: ${TABLE}.ly_uw_tenure ;;
  }

  dimension: merlin_reference_ly {
    type: string
    sql: ${TABLE}.merlin_reference_ly ;;
  }

  dimension: net_written_premium {
    type: number
    sql: ${TABLE}.net_written_premium ;;
  }

  dimension_group: policy_start {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      fiscal_quarter,
      fiscal_year
    ]
    sql: to_timestamp(${TABLE}.policy_start_date) ;;
  }

  dimension: ren_ly_premium {
    type: number
    sql: ${TABLE}.ren_ly_premium ;;
  }

  dimension: tia_customer_no {
    type: number
    sql: ${TABLE}.tia_customer_no ;;
  }

  dimension: tia_reference_ly {
    type: number
    sql: ${TABLE}.tia_reference_ly ;;
  }

  dimension: tia_reference_ty {
    type: number
    sql: ${TABLE}.tia_reference_ty ;;
  }

  dimension: uw_policy_no {
    type: string
    sql: ${TABLE}.uw_policy_no ;;
  }

  dimension: uw_policy_no_ly {
    type: string
    sql: ${TABLE}.uw_policy_no_ly ;;
  }

  dimension: aauicl_yoy_net_premium_change_ren_dist {
    label: "AAUICL YoY Net Premium Change Distribution REN"
    type: tier
    tiers: [-0.15,-0.1,-0.05,0,0.05,0.1,0.15]
    sql: ((case when ${TABLE}.aauicl_hold = 1 and ${TABLE}.aauicl_ind = 1 then ${TABLE}.net_written_premium else 0 end)-(case when ${TABLE}.aauicl_hold = 1 and ${TABLE}.aauicl_ind = 1 then ${TABLE}.ly_premium else 0 end))/nullif((case when ${TABLE}.aauicl_hold = 1 and ${TABLE}.aauicl_ind = 1 then ${TABLE}.ly_premium else 0 end),0) ;;
    value_format_name: percent_1
  }


# Measures

  measure: count {
    type: count
    drill_fields: []
  }

  measure: broker_holding {
    label: "Broker Holding"
    type:  sum
    sql: ${TABLE}.broker_hold ;;
  }

  measure: broker_holding_102 {
    label: "Broker Holding 102"
    type:  sum
    sql: ${TABLE}.broker_hold ;;
    filters: {
      field: ly_aauicl_scheme
      value: "102"
    }
    hidden: yes
  }

  measure: broker_holding_103 {
    label: "Broker Holding 103"
    type:  sum
    sql: ${TABLE}.broker_hold ;;
    filters: {
      field: ly_aauicl_scheme
      value: "103"
    }
    hidden: yes
  }

  measure: aauicl_holding {
    label: "AAUICL Holding"
    type:  sum
    sql: ${TABLE}.aauicl_hold ;;
  }

  measure: non_aauicl_holding {
    label: "non-AAUICL Holding"
    type: sum
    sql:  ${TABLE}.broker_hold ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
  }

  measure: broker_written {
    label: "Broker Written Covers"
    type:  sum
    sql: ${TABLE}.broker_ind ;;
  }

  measure: broker_written_102 {
    label: "Broker Written Covers LY 102"
    type:  sum
    sql: ${TABLE}.broker_ind ;;
    filters: {
      field: ly_aauicl_scheme
      value: "102"
    }
    hidden: yes
  }

  measure: broker_written_103 {
    label: "Broker Written Covers LY 103"
    type:  sum
    sql: ${TABLE}.broker_ind ;;
    filters: {
      field: ly_aauicl_scheme
      value: "103"
    }
    hidden: yes
  }

  measure: broker_written_null {
    label: "Broker Written Covers LY Null"
    type:  sum
    sql: ${TABLE}.broker_ind ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
    hidden: yes
  }

  measure: aauicl_written {
    label: "AAUICL Written Covers"
    type:  sum
    sql: ${TABLE}.aauicl_ind ;;
  }

  measure: non_aauicl_written {
    label: "non-AAUICL Written Covers"
    type: sum
    sql:  ${TABLE}.broker_ind ;;
    filters: {
      field: aauicl_ind
      value: "0"
    }
  }

  measure: aauicl_retained {
    label: "AAUICL Retained"
    type: sum
    sql: ${TABLE}.aauicl_ind ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
  }

  measure: non_aauicl_retained {
    label: "non-AAUICL Retained"
    type: sum
    sql: ${TABLE}.broker_ind ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
    filters: {
      field: aauicl_ind
      value: "0"
    }
  }

  measure: aauicl_xq {
    label: "AAUICL Cross Quotes"
    type: sum
    sql: ${TABLE}.aauicl_ind ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
  }

  measure: non_aauicl_xq {
    label: "non-AAUICL Cross Quotes"
    type: sum
    sql: ${TABLE}.broker_ind ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    filters: {
      field: aauicl_ind
      value: "0"
    }
  }

  measure: broker_retained_aauicl {
    label: "Broker Retained from AAUICL"
    type: sum
    sql: ${TABLE}.broker_ind ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
  }


  measure: broker_retention_rate {
    label: "Broker Retention Rate"
    type:  number
    sql: 1.0*${broker_written}/nullif(${broker_holding},0) ;;
    value_format_name: percent_2
  }

  measure: broker_retention_rate_102 {
    label: "Broker Retention Rate 102"
    type:  number
    sql: 1.0*${broker_written_102}/nullif(${broker_holding_102},0) ;;
    value_format_name: percent_2
  }

  measure: broker_retention_rate_103 {
    label: "Broker Retention Rate 103"
    type:  number
    sql: 1.0*${broker_written_103}/nullif(${broker_holding_103},0) ;;
    value_format_name: percent_2
  }

  measure: broker_retention_rate_non_aauicl {
    label: "Broker Retention Rate non-AAUICL"
    type:  number
    sql: 1.0*${broker_written_null}/nullif(${non_aauicl_holding},0) ;;
    value_format_name: percent_2
  }

  measure: broker_retention_rate_aauicl {
    label: "Broker Retention Rate AAUICL"
    type:  number
    sql: 1.0*${broker_retained_aauicl}/nullif(${aauicl_holding},0) ;;
    value_format_name: percent_2
  }

  measure: aauicl_share_of_broker_invites {
    label: "AAUICL Share of Broker Invites"
    type:  number
    sql: 1.0*${aauicl_written}/nullif(${broker_holding},0) ;;
    value_format_name: percent_2
  }

  measure: non_aauicl_share_of_broker_invites {
    label: "non-AAUICL Share of Broker Invites"
    type:  number
    sql: 1.0*${non_aauicl_written}/nullif(${broker_holding},0) ;;
    value_format_name: percent_2
  }

  measure: aauicl_retention_rate {
    label: "AAUICL Retention Rate"
    type:  number
    sql: 1.0*${aauicl_retained}/nullif(${aauicl_holding},0) ;;
    value_format_name: percent_2
  }

  measure: non_aauicl_retention_rate {
    label: "non-AAUICL Retention Rate"
    type:  number
    sql: 1.0*${non_aauicl_retained}/nullif(${non_aauicl_holding},0) ;;
    value_format_name: percent_2
  }

  measure: aauicl_xq_rate {
    label: "AAUICL Cross Quote Rate"
    type:  number
    sql: 1.0*${aauicl_xq}/nullif(${non_aauicl_holding},0) ;;
    value_format_name: percent_2
  }

  measure: non_aauicl_xq_rate {
    label: "non-AAUICL Cross Quote Rate"
    type:  number
    sql: 1.0*${non_aauicl_xq}/nullif(${aauicl_holding},0) ;;
    value_format_name: percent_2
  }

  ### Premium Measures ###

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

  measure: aauicl_ty_gross_premium_xq {
    label: "AAUICL TY Gross Premium Cross Quote"
    type: sum
    sql: ${TABLE}.net_written_premium + ${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_net_premium_xq {
    label: "AAUICL TY Net Premium Cross Quote"
    type: sum
    sql: ${TABLE}.net_written_premium ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_ty_commission_xq {
    label: "AAUICL TY Commission Cross Quote"
    type: sum
    sql: ${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_hold
      value: "0"
    }
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }




  measure: aauicl_ty_gross_premium_share_of_ly_gross_premium {
    label: "AAUICL TY Gross Premium Share of LY Gross Premium"
    type: number
    sql: ${aauicl_ty_gross_premium}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_gross_premium_retention {
    label: "AAUICL Gross Premium Retention"
    type: number
    sql: ${aauicl_ty_gross_premium_ren}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }


  measure: aauicl_ly_net_premium_share_of_ly_gross_premium {
    label: "AAUICL LY Net Premium Share of LY Gross Premium"
    type: number
    sql: ${aauicl_ly_net_premium}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }

#  measure: aauicl_ly_net_premium_share_of_ly_gross_premium_ren {
#    label: "AAUICL LY Net Premium Share of LY Gross Premium REN"
#    type: number
#    sql: ${aauicl_ly_net_premium_ren}/nullif(${aauicl_ly_gross_premium},0) ;;
#    value_format_name: percent_1
#  }


  measure: aauicl_ly_commission_share_of_ly_gross_premium {
    label: "AAUICL LY Comission Share of LY Gross Premium"
    type: number
    sql: ${aauicl_ly_commission}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }

#  measure: aauicl_ly_commission_share_of_ly_gross_premium_ren {
#    label: "AAUICL LY Comission Share of LY Gross Premium REN"
#    type: number
#    sql: ${aauicl_ly_commission_ren}/nullif(${aauicl_ly_gross_premium},0) ;;
#    value_format_name: percent_1
#  }


  measure: aauicl_ty_net_premium_share_of_ly_gross_premium {
    label: "AAUICL TY Net Premium Share of LY Gross Premium"
    type: number
    sql: ${aauicl_ty_net_premium}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_ty_net_premium_share_of_ly_gross_premium_ren {
    label: "AAUICL TY Net Premium Share of LY Gross Premium REN"
    type: number
    sql: ${aauicl_ty_net_premium_ren}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }


  measure: aauicl_ty_commission_share_of_ly_gross_premium {
    label: "AAUICL TY Comission Share of LY Gross Premium"
    type: number
    sql: ${aauicl_ty_commission}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_ty_commission_share_of_ly_gross_premium_ren {
    label: "AAUICL TY Comission Share of LY Gross Premium REN"
    type: number
    sql: ${aauicl_ty_commission_ren}/nullif(${aauicl_ly_gross_premium},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_ty_net_premium_share_of_ly_net_premium {
    label: "AAUICL TY Net Premium Share of LY Net Premium"
    type: number
    sql: ${aauicl_ty_net_premium}/nullif(${aauicl_ly_net_premium},0) ;;
    value_format_name: percent_1
  }

  measure: aauicl_net_premium_retention {
    label: "AAUICL Net Premium Retention"
    type: number
    sql: ${aauicl_ty_net_premium_ren}/nullif(${aauicl_ly_net_premium},0) ;;
    value_format_name: percent_1
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



  measure: aauicl_average_gross_premium_ly {
    label: "AAUICL Average Gross Premium LY"
    type:  average
    sql: ${TABLE}.ly_premium+${TABLE}.ly_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_gross_premium_ly_hol {
    label: "AAUICL Average Gross Premium LY HOL"
    type: average
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
  }

  measure: aauicl_average_gross_premium_ly_ren {
    label: "AAUICL Average Gross Premium LY REN"
    type: average
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



  measure: aauicl_average_net_premium_ly {
    label: "AAUICL Average Net Premium LY"
    type:  average
    sql: ${TABLE}.ly_premium ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_net_premium_ly_hol {
    label: "AAUICL Average Net Premium LY HOL"
    type: average
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
  }

  measure: aauicl_average_net_premium_ly_ren {
    label: "AAUICL Average Net Premium LY REN"
    type: average
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

  measure: aauicl_average_commission_ly {
    label: "AAUICL Average Commission LY"
    type:  average
    sql: ${TABLE}.ly_commission ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_commission_ly_hol {
    label: "AAUICL Average Commission LY HOL"
    type: average
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
  }

  measure: aauicl_average_commission_ly_ren {
    label: "AAUICL Average Commission LY REN"
    type: average
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


  measure: aauicl_average_gross_premium_ty {
    label: "AAUICL Average Gross Premium TY"
    type:  average
    sql: ${TABLE}.net_written_premium+${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_gross_premium_ty_hol {
    label: "AAUICL Average Gross Premium TY HOL"
    type: average
    sql: ${TABLE}.inv_premium_hol+${TABLE}.inv_commission_hol ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_gross_premium_ty_ren {
    label: "AAUICL Average Gross Premium TY REN"
    type: average
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


  measure: aauicl_average_net_premium_ty {
    label: "AAUICL Average Net Premium TY"
    type:  average
    sql: ${TABLE}.net_written_premium ;;
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_net_premium_ty_hol {
    label: "AAUICL Average Net Premium TY HOL"
    type: average
    sql: ${TABLE}.inv_premium_hol ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_net_premium_ty_ren {
    label: "AAUICL Average Net Premium TY REN"
    type: average
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


  measure: aauicl_average_commission_ty {
    label: "AAUICL Average Commission TY"
    type:  average
    sql: ${TABLE}.broker_commission ;;
    filters: {
      field: aauicl_ind
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_commission_ty_hol {
    label: "AAUICL Average Commission TY HOL"
    type: average
    sql: ${TABLE}.inv_commission_hol ;;
    filters: {
      field: aauicl_hold
      value: "1"
    }
    value_format_name: gbp_0
  }

  measure: aauicl_average_commission_ty_ren {
    label: "AAUICL Average Commission TY REN"
    type: average
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

  measure: aauicl_yoy_gross_premium_change_hol_gbp {
    label: "AAUICL YoY Gross Premium Change HOL (£)"
    type: number
    sql: ${aauicl_average_gross_premium_ty_hol}-${aauicl_average_gross_premium_ly_hol} ;;
    value_format_name: gbp_0
  }

  measure: aauicl_yoy_gross_premium_change_ren_gbp {
    label: "AAUICL YoY Gross Premium Change REN (£)"
    type: number
    sql: ${aauicl_average_gross_premium_ty_ren}-${aauicl_average_gross_premium_ly_ren} ;;
    value_format_name: gbp_0
  }

  measure: aauicl_yoy_net_premium_change_hol_gbp {
    label: "AAUICL YoY Net Premium Change HOL (£)"
    type: number
    sql: ${aauicl_average_net_premium_ty_hol}-${aauicl_average_net_premium_ly_hol} ;;
    value_format_name: gbp_0
  }

  measure: aauicl_yoy_net_premium_change_ren_gbp {
    label: "AAUICL YoY Net Premium Change REN (£)"
    type: number
    sql: ${aauicl_average_net_premium_ty_ren}-${aauicl_average_net_premium_ly_ren} ;;
    value_format_name: gbp_0
  }

  measure: aauicl_yoy_commission_change_hol_gbp {
    label: "AAUICL YoY Commission Change HOL (£)"
    type: number
    sql: ${aauicl_average_commission_ty_hol}-${aauicl_average_commission_ly_hol} ;;
    value_format_name: gbp_0
  }

  measure: aauicl_yoy_commission_change_ren_gbp {
    label: "AAUICL YoY Commission Change REN (£)"
    type: number
    sql: ${aauicl_average_commission_ty_ren}-${aauicl_average_commission_ly_ren} ;;
    value_format_name: gbp_0
  }


}
