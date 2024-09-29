CREATE OR REPLACE TABLE keepcoding.ivr_detail AS

SELECT calls.ivr_id AS calls_ivr_id      
     , calls.phone_number AS calls_phone_number
     , calls.ivr_result AS calls_ivr_result
     , calls.vdn_label AS calls_vdn_label
     , calls.start_date AS calls_start_date
     , FORMAT_DATE('%Y%m%d', calls.start_date) AS calls_start_date_id
     , calls.end_date AS calls_end_date
     , FORMAT_DATE('%Y%m%d', calls.end_date) AS calls_end_date_id
     , calls.total_duration AS calls_total_duration
     , calls.customer_segment AS calls_customer_segments
     , calls.ivr_language AS calls_ivr_language
     , calls.steps_module AS calls_step_module
     , calls.module_aggregation AS calls_module_aggregation
     , modules.module_sequece
     , modules.module_name
     , modules.module_duration
     , modules.module_result
     , steps.step_sequence
     , steps.step_name
     , steps.step_result
     , steps.step_description_error
     , CASE WHEN steps.document_type = 'DESCONOCIDO' THEN 'UNKNOWN' 
            ELSE steps.document_type
       END AS document_type --Hago este cambio para dejarlo más limpio y no tener dos campos similares
     , steps.document_identification
     , steps.customer_phone
     , steps.billing_account_id
    FROM `keepcoding.ivr_calls` AS calls
    LEFT 
    JOIN  `keepcoding.ivr_modules` AS modules
      ON modules.ivr_id = calls.ivr_id
    LEFT
    JOIN `keepcoding.ivr_steps` AS steps
      ON steps.ivr_id = modules.ivr_id AND steps.module_sequece = modules.module_sequece