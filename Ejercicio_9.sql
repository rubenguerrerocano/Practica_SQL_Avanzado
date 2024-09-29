WITH phone
AS (
   SELECT calls_ivr_id 
        , IF(step_result = 'OK', 1, 0) as phone_result
     FROM `keepcoding.ivr_detail`
    WHERE step_name = 'CUSTOMERINFOBYPHONE.TX'
      AND step_description_error <> 'UNKNOWN ERROR'
  )

SELECT ivr_detail.calls_ivr_id
     , MAX(IFNULL(phone.phone_result, 0)) AS info_by_phone_lg
  FROM keepcoding.ivr_detail
  LEFT
  JOIN phone
    ON ivr_detail.calls_ivr_id = phone.calls_ivr_id
GROUP BY ivr_detail.calls_ivr_id