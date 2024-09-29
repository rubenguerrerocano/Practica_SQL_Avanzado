CREATE OR REPLACE FUNCTION keepcoding.fnc_cleaning_integer(p_int64 INT64) RETURNS INT64 
AS
(
  IFNULL(p_int64, -999999)
)