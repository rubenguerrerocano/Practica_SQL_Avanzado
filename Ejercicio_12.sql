CREATE OR REPLACE TABLE keepcoding.ivr_summary AS

WITH vdn_agg 
  AS (SELECT ivr_id
           , CASE WHEN STARTS_WITH(vdn_label, 'ATC') THEN 'FRONT'
                  WHEN STARTS_WITH(vdn_label, 'TECH') THEN 'TECH'
                  WHEN STARTS_WITH(vdn_label, 'ABSORPTION') THEN 'ABSORPTION'
                  ELSE 'RESTO'
             END AS vdn_aggregation
        FROM `keepcoding.ivr_calls`)
  ,  document
  AS (SELECT calls_ivr_id
           , document_type
           , document_identification
        FROM `keepcoding.ivr_detail`
      QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(document_type,'UNKNOWN')DESC)= 1)
  , phone
  AS (SELECT calls_ivr_id
           , customer_phone
        FROM `keepcoding.ivr_detail`
      QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(customer_phone,'UNKNOWN')DESC)= 1 )
  , billing
  AS (SELECT calls_ivr_id
           , billing_account_id
        FROM `keepcoding.ivr_detail`
      QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(billing_account_id,'UNKNOWN')DESC)= 1 )
  , masiva
  AS (SELECT calls_ivr_id 
           ,IF(module_name = 'AVERIA_MASIVA',1,0) AS masiva_lg
        FROM `keepcoding.ivr_detail`
      QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY masiva_lg DESC) = 1)
  , phone_aux
  AS (SELECT calls_ivr_id 
           , IF(step_result = 'OK', 1, 0) as phone_result
        FROM `keepcoding.ivr_detail`
       WHERE step_name = 'CUSTOMERINFOBYPHONE.TX'
         AND step_description_error <> 'UNKNOWN ERROR')
  , phone_lg
  AS (SELECT ivr_detail.calls_ivr_id
           , MAX(IFNULL(phone_aux.phone_result, 0)) AS info_by_phone_lg
        FROM keepcoding.ivr_detail
        LEFT
        JOIN phone_aux
          ON ivr_detail.calls_ivr_id = phone_aux.calls_ivr_id
      GROUP BY ivr_detail.calls_ivr_id)
  , dni_aux
  AS (SELECT calls_ivr_id 
           , IF(step_result = 'OK', 1, 0) as dni_result
        FROM `keepcoding.ivr_detail`
       WHERE step_name = 'CUSTOMERINFOBYDNI.TX'
         AND step_description_error <> 'UNKNOWN ERROR')
    , dni_lg
  AS (SELECT ivr_detail.calls_ivr_id
           , MAX(IFNULL(dni_aux.dni_result, 0)) AS info_by_dni_lg
        FROM keepcoding.ivr_detail
        LEFT
        JOIN dni_aux
          ON ivr_detail.calls_ivr_id = dni_aux.calls_ivr_id
      GROUP BY ivr_detail.calls_ivr_id)
  , recall
  AS (SELECT ivr_id
           , phone_number
           , start_date
           , LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY start_date,phone_number) AS next_call_date
           , DATETIME_DIFF(LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), start_date, HOUR) AS recall_hour_diff
           , IF(DATETIME_DIFF(LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), start_date, HOUR) <= 24, 1, 0) AS cause_recall_phone_24H
           , LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date,ivr_id) AS previous_call_date
           , DATETIME_DIFF(start_date,LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), HOUR) AS repeated_phone_hour_diff
           , IF(DATETIME_DIFF(start_date,LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), HOUR) <= 24, 1, 0) AS repeated_phone_24H
        FROM `keepcoding.ivr_calls`)

SELECT ivr_detail.calls_ivr_id
     , ivr_detail.calls_phone_number
     , ivr_detail.calls_ivr_result
     , vdn_agg.vdn_aggregation
     , ivr_detail.calls_start_date
     , ivr_detail.calls_end_date
     , ivr_detail.calls_total_duration
     , ivr_detail.calls_customer_segments
     , ivr_detail.calls_ivr_language
     , ivr_detail.calls_step_module
     , ivr_detail.calls_module_aggregation
     , document.document_type
     , document.document_identification
     , phone.customer_phone
     , billing.billing_account_id
     , masiva.masiva_lg
     , phone_lg.info_by_phone_lg
     , dni_lg.info_by_dni_lg
     , recall.repeated_phone_24H
     , recall.cause_recall_phone_24H
  FROM keepcoding.ivr_detail
  LEFT
  JOIN vdn_agg
    ON ivr_detail.calls_ivr_id = vdn_agg.ivr_id
  LEFT
  JOIN document
    ON ivr_detail.calls_ivr_id = document.calls_ivr_id
  LEFT
  JOIN phone
    ON ivr_detail.calls_ivr_id = phone.calls_ivr_id
  LEFT
  JOIN billing
    ON ivr_detail.calls_ivr_id = billing.calls_ivr_id
  LEFT
  JOIN masiva
    ON ivr_detail.calls_ivr_id = masiva.calls_ivr_id
  LEFT
  JOIN phone_lg
    ON ivr_detail.calls_ivr_id = phone_lg.calls_ivr_id
  LEFT
  JOIN dni_lg
    ON ivr_detail.calls_ivr_id = dni_lg.calls_ivr_id
  LEFT
  JOIN recall
    ON ivr_detail.calls_ivr_id = recall.ivr_id
GROUP BY ivr_detail.calls_ivr_id
     , ivr_detail.calls_phone_number
     , ivr_detail.calls_ivr_result
     , vdn_agg.vdn_aggregation
     , ivr_detail.calls_start_date
     , ivr_detail.calls_end_date
     , ivr_detail.calls_total_duration
     , ivr_detail.calls_customer_segments
     , ivr_detail.calls_ivr_language
     , ivr_detail.calls_step_module
     , ivr_detail.calls_module_aggregation
     , document.document_type
     , document.document_identification
     , phone.customer_phone
     , billing.billing_account_id
     , masiva.masiva_lg
     , phone_lg.info_by_phone_lg
     , dni_lg.info_by_dni_lg
     , recall.repeated_phone_24H
     , recall.cause_recall_phone_24H
