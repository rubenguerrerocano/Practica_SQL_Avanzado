SELECT ivr_id
     , phone_number
     , start_date
     , LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY start_date,phone_number) AS next_call_date
     , DATETIME_DIFF(LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), start_date, HOUR) AS recall_hour_diff
     , IF(DATETIME_DIFF(LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), start_date, HOUR) <= 24, 1, 0) AS cause_recall_phone_24H
     , LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date,ivr_id) AS previous_call_date
     , DATETIME_DIFF(start_date,LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), HOUR) AS repeated_phone_hour_diff
     , IF(DATETIME_DIFF(start_date,LAG(start_date) OVER(PARTITION BY phone_number ORDER BY start_date, ivr_id), HOUR) <= 24, 1, 0) AS repeated_phone_24H
  FROM `keepcoding.ivr_calls`
  ORDER BY phone_number
 
  
  