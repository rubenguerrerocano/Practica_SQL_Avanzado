WITH dni
AS (
   SELECT calls_ivr_id 
        , IF(step_result = 'OK', 1, 0) as dni_result
     FROM `keepcoding.ivr_detail`
    WHERE step_name = 'CUSTOMERINFOBYDNI.TX'
      AND step_description_error <> 'UNKNOWN ERROR'
  )

SELECT ivr_detail.calls_ivr_id
     , MAX(IFNULL(dni.dni_result, 0)) AS info_by_dni_lg
  FROM keepcoding.ivr_detail
  LEFT
  JOIN dni
    ON ivr_detail.calls_ivr_id = dni.calls_ivr_id
GROUP BY ivr_detail.calls_ivr_id