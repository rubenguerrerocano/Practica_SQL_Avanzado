
-- En principio al hacer el qualify con el document type, el campo document identification debería venir también informado al tratarse del documento 

SELECT calls_ivr_id
     , document_type
     , document_identification
  FROM `keepcoding.ivr_detail`
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(document_type,'UNKNOWN')DESC)= 1; 

-- Pero si no nos lo creemos y queremos asegurar esto es otra manera

SELECT type.calls_ivr_id
     , type.document_type
     , iden.document_identification
  FROM `keepcoding.ivr_detail` AS type
  LEFT
  JOIN (SELECT calls_ivr_id
       , document_identification
       FROM `keepcoding.ivr_detail`
       QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY NULLIF(document_identification,'UNKNOWN')DESC) = 1) 
       AS iden
    ON type.calls_ivr_id = iden.calls_ivr_id
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(type.calls_ivr_id AS STRING) ORDER BY NULLIF(type.document_type,'UNKNOWN')DESC)= 1;