SELECT calls_ivr_id
     , billing_account_id
  FROM `keepcoding.ivr_detail`
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(billing_account_id,'UNKNOWN')DESC)= 1 