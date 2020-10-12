view: mtas {
  derived_table: {
    sql:

    select
          old.quote_dttm as quote_date
         ,old.quote_dttm as quote_dttm_old
         ,old.customer_quote_reference as customer_quote_reference_old
         ,old.rmita1_oldrisk1 as rmita1_oldrisk1_old
         ,old.merlin_transaction_type as merlin_transaction_type_old
         ,old.call_type as call_type_old
         ,old.quotedpremium_an_notinclipt as quotedpremium_an_notinclipt_old


         ,new.quote_dttm as quote_dttm_new
         ,new.customer_quote_reference as customer_quote_reference_new
         ,new.rmita1_oldrisk1 as rmita1_oldrisk1_new
         ,new.merlin_transaction_type as merlin_transaction_type_new
         ,new.call_type as call_type_new
         ,new.quotedpremium_an_notinclipt as quotedpremium_an_notinclipt_new

         ,(old.quote_dttm - new.quote_dttm) as time_diff
         ,v_new.annual_mileage as annual_mileage_new
         ,v_old.annual_mileage as annual_mileage_old
         ,v_new.annual_mileage - v_old.annual_mileage as mileage_change
         ,case when (v_new.annual_mileage - v_old.annual_mileage ) = 0.000 then 0.000 else 1.000 end as Mileage_MTA
         ,case when (v_new.annual_mileage - v_old.annual_mileage ) < 0.000 then 1.000 else 0.000 end as Mileage_MTA_reduced
         ,case when old.risk_postcode = new.risk_postcode then 0.000 else 1.000 end as COA
         ,case when v_old.abi_code =v_new.abi_code then 0.000 else 1.000 end as COV
         ,case when drv_old.ncd=drv_new.ncd then 0.000 else 1.000 end as NCD_Change
         ,case when drv_old.no_claims=drv_new.no_claims then 0.000 else 1.000 end as Claims_Change
         ,case when drv_old.no_convictions=drv_new.no_convictions then 0.000 else 1.000 end as Convictions_Change
         ,case when drv_old.bus_use=drv_new.bus_use then 0.000 else 1.000 end as BusUse_Change
         ,case when drv_old.num_drv <> drv_new.num_drv then 1.000
               when drv_old.min_dob <> drv_new.min_dob then 1.000
               when drv_old.max_dob <> drv_new.max_dob then 1.000
               else 0.000 end as COD
      from
        qs_cover old
      inner join
        qs_cover new
        on old.customer_quote_reference = new.customer_quote_reference
           and new.rmita1_oldrisk1 ='false'
           and (old.quote_dttm - new.quote_dttm) < '0 00:00:05.000000'
           and (old.quote_dttm - new.quote_dttm)> 0

      inner join
        qs_vehicles v_old
        on v_old.quote_id = old.quote_id

      inner join
         qs_vehicles v_new
         on v_new.quote_id = new.quote_id

      inner join
          (select
              quote_id
              ,sum(no_claims) as no_claims
              ,sum(no_convictions) as no_convictions
              ,sum(case when driver_id = 0 and business_use_required ='Y' then 1 else 0 end) as bus_use
              ,sum(case when driver_id = 0 then ncb_years else 0 end) as ncd
              ,count(*) as num_drv
              ,min(birth_dt) as min_dob
              ,max(birth_dt) as max_dob
           from
              qs_drivers
           where to_date(sysdate) - to_date(quote_dttm) <= 365
           group by quote_id
            )drv_old
            on drv_old.quote_id = old.quote_id

      inner join
          (select
              quote_id
              ,sum(no_claims) as no_claims
              ,sum(no_convictions) as no_convictions
              ,sum(case when driver_id = 0 and business_use_required ='Y' then 1 else 0 end) as bus_use
              ,sum(case when driver_id = 0 then ncb_years else 0 end) as ncd
              ,count(*) as num_drv
              ,min(birth_dt) as min_dob
              ,max(birth_dt) as max_dob
           from
              qs_drivers
           where to_date(sysdate) - to_date(quote_dttm) <= 365
           group by quote_id
            )drv_new
            on drv_new.quote_id = new.quote_id


      where old.motor_transaction_type = 'MidTermAdjustmen'
            and old.rmita1_oldrisk1 ='true'
            and  to_date(sysdate) - to_date(old.quote_dttm) <= 365
  ;;
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

  measure: mta_requests {
    type: number
    sql: count(*);;
  }


  measure: mileage_reduce_requests {
    type: number
    sql: sum(Mileage_MTA_reduced);;
  }

  measure: mileage_reduce_proportion {
    type: number
    sql: ${mileage_reduce_requests}/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: mileage_requests {
    type: number
    sql: sum(Mileage_MTA);;
  }

  measure: mileage_proportion {
    type: number
    sql: ${mileage_requests}/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: COA_requests {
    type: number
    sql: sum(COA);;
  }

  measure: COA_proportion {
    type: number
    sql: sum(COA)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: COV_requests {
    type: number
    sql: sum(COV);;
  }

  measure: COV_proportion {
    type: number
    sql: sum(COV)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: NCD_requests {
    type: number
    sql: sum(NCD_Change);;
  }

  measure: NCD_Chg_proportion {
    type: number
    sql: sum(NCD_Change)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: Clm_Chg_requests {
    type: number
    sql: sum(Claims_Change);;
  }

  measure: Clm_Chg_proportion {
    type: number
    sql: sum(Claims_Change)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: Con_Chg_requests {
    type: number
    sql: sum(Convictions_Change);;
  }

  measure: Con_Chg_proportion {
    type: number
    sql: sum(Convictions_Change)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: BusUse_requests {
    type: number
    sql: sum(BusUse_Change);;
  }

  measure: BusUse_Chg_proportion {
    type: number
    sql: sum(BusUse_Change)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: Drv_Chg_requests {
    type: number
    sql: sum(COD);;
  }

  measure: Drv_Chg_proportion {
    type: number
    sql: sum(COD)/${mta_requests}*1.00;;
    value_format_name: percent_0
  }

  measure: reduced_miles_prc_chg {
    type: number
    sql: sum(case when Mileage_MTA_reduced = 1 and COD = 0 and COV = 0 and COA = 0 and BusUse_Change = 0 and convictions_change = 0 and claims_change = 0 then quotedpremium_an_notinclipt_new*1.000 else 0.000 end)/sum(case when Mileage_MTA_reduced = 1 and COD = 0 and COV = 0 and COA = 0 and BusUse_Change = 0 and convictions_change = 0 and claims_change = 0 then quotedpremium_an_notinclipt_old*1.000 else 0.001 end)-1 ;;
    value_format_name: percent_0
    }

  measure: mta_price_chg {
    type: number
    sql: sum(quotedpremium_an_notinclipt_new*1.000)/sum(quotedpremium_an_notinclipt_old)-1 ;;
    value_format_name: percent_0
  }

}
