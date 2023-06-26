view: motor_rnl_enbp_ratio {
  derived_table: {
    sql:

    SELECT
    c.customer_quote_reference,
    c.quote_id,
    c.rct_modelnumber,
    c.business_purpose,
    to_date(c.cover_start_dt) as cover_start_dt,
    to_date(c.quote_dttm) as quote_date,
    c.channel,
    c.consumer_name,
    c.originator_name,
    c.initial_quote_to_inception,
    c.protect_no_claims_bonus,
    c.quotedpremium_an_notinclipt,
    c.quotedpremium_ap_notinclipt,
    c.previous_policy_premium,
    case when c.protect_no_claims_bonus ='true' then c.quotedpremium_ap_notinclipt else c.quotedpremium_an_notinclipt end as invited_prem_pre_sb,
    m.rct_mi_17,
    m.rct_mi_18,

    quotedpremium_an_notinclipt - rct_mi_17 as diff1,
    quotedpremium_ap_notinclipt - rct_mi_18 as diff2,
    (case when c.protect_no_claims_bonus ='true' then c.quotedpremium_ap_notinclipt else c.quotedpremium_an_notinclipt end) / previous_policy_premium - 1 as YoY,
    round ( (case when c.protect_no_claims_bonus ='true' then c.quotedpremium_ap_notinclipt else c.quotedpremium_an_notinclipt end) / (CASE WHEN protect_no_claims_bonus = 'false' then rct_mi_17 else rct_mi_18 end) , 2) as ratio_to_enbp

    FROM qs_cover c
    JOIN qs_mi_outputs m
    ON c.quote_id = m.quote_id
    AND to_date(c.quote_dttm) >= '2022-01-01' AND to_date(c.quote_dttm)!= '2999-12-31'
    AND business_purpose='Renewal'

    ;;
  }

  dimension_group: cover_start_dt {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.cover_start_dt ;;
  }

  dimension_group: quote_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.quote_date ;;
  }


  dimension: rct_modelnumber {
    type: string
    sql: ${TABLE}.rct_modelnumber ;;
  }

  dimension: consumer_name {
    type: string
    sql: ${TABLE}.consumer_name ;;
  }

  dimension: originator_name {
    type: string
    sql: ${TABLE}.originator_name ;;
  }

  dimension: initial_quote_to_inception {
    type: number
    sql: ${TABLE}.initial_quote_to_inception ;;
  }

  dimension: protect_no_claims_bonus {
    type: string
    sql: ${TABLE}.protect_no_claims_bonus ;;
  }


  dimension: diff1 {
    type: number
    sql: ${TABLE}.diff1 ;;
  }

  dimension: diff2 {
    type: number
    sql: ${TABLE}.diff2 ;;
  }

  dimension: yoy {
    type: number
    sql: ${TABLE}.yoy ;;
  }

  dimension: ratio_to_enbp {
    type: number
    sql: round(${TABLE}.ratio_to_enbp, 2) ;;
  }

  measure: ratio_to_enbp_count  {
    type: number
    sql: count(*) ;;
  }



}
