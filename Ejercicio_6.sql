SELECT calls_ivr_id
     , customer_phone
  FROM `keepcoding.ivr_detail`
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(customer_phone,'UNKNOWN')DESC)= 1 
  

          