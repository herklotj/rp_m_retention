view: motor_sboc {
  derived_table: {
  sql:

select
    cov.customer_quote_reference
    ,cov.quote_dttm
    ,cov.protect_no_claims_bonus
    ,cov.quotedpremium_an_notinclipt
    ,cov.quotedpremium_ap_notinclipt
    ,case when cov.protect_no_claims_bonus ='true' then cov.quotedpremium_ap_notinclipt else cov.quotedpremium_an_notinclipt end as invited_prem_pre_sb
    ,pmid.inv_premium_hol
    ,pmid.*
    ,cov.*
from
    (select *, substr(customer_quote_reference,4,9) as tia_ref  from qs_cover where business_purpose ='Renewal' and (hour(quote_dttm) >= 22 or hour(quote_dttm) < 7)) cov
inner join
  lk_m_retention pmid
  on
    substr(cov.customer_quote_reference,4,9) = pmid.tia_reference_ty and cov.cover_start_dt = pmid.policy_start_date
  ;;
  }

   dimension_group: inception_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.policy_start_date ;;
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
    sql: ${TABLE}.quote_dttm ;;
  }

  dimension: scheme {
    type: string
    sql: ${TABLE}.ly_aauicl_scheme ;;
  }

  dimension: ly_uw_tenure {
    type: number
    sql: ${TABLE}.ly_uw_tenure ;;
  }

  measure: invites {
    type: count
  }

  measure: sboc_invites {
    type: number
    sql: sum(case when (invited_prem_pre_sb - inv_premium_hol) > 1 then 1.0 else 0.0 end)  ;;

  }

  measure: sboc_proportion {
    type: number
    sql: (${sboc_invites}*1.00)/(${invites}*1.00) ;;
  }

  measure: sboc_discount {
    type: number
    sql: sum(inv_premium_hol*1.00)/sum(invited_prem_pre_sb*1.00)-1;;
  }

  }
