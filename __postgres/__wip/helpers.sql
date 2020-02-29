SELECT
    "FX_PAIR",
    SUBSTRING("DTTM_STAMP", 1, 8) ,
    count(1) AS cnt,
    MIN("DTTM_STAMP"),
    MAX("DTTM_STAMP")
FROM
    rf.stg_fx_mbar_m
GROUP BY
    "FX_PAIR",
    SUBSTRING("DTTM_STAMP", 1, 8)
ORDER BY
    1,
    2

SELECT
    "FX_PAIR",
    SUBSTRING("DTTM_STAMP", 1, 8) ,
    count(1) AS cnt
FROM
    rf.stg_fx_mbar_m
GROUP BY
    "FX_PAIR",
    SUBSTRING("DTTM_STAMP", 1, 8)
ORDER BY
    1,
    2
    
SELECT * FROM  rf.stg_fx_mbar_m;

SELECT "DTTM_STAMP", "OPEN", "HIGH", "LOW", "CLOSE", "VOLUME", "FX_PAIR"
FROM stg_fx_mbar_m;


SELECT "DTTM_STAMP", "OPEN", "HIGH", "LOW", "CLOSE", "VOLUME", "FX_PAIR"
    FROM rf.stg_fx_mbar_m;