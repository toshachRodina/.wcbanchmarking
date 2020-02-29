/*
===================================================================================================
KNIME_VARS_CTL SCRIPTS
===================================================================================================
*/

SELECT
	VAR_VAL
FROM
	KNIME_VARS_CTL
WHERE
	ENV = 'PROD'
	AND VAR_TYPE = 'ENV';



/*
===================================================================================================
PYTHON LOGGING SCRIPTS
===================================================================================================
*/

SELECT
	MSMT_DTE_ID,
	PKG_NME,
	STATUS,
	START_DATETIME,
	END_DATETIME,
	STATUS_DESC
FROM
	PY_PROCESS_LOG
WHERE
	1 = 1
ORDER BY
	END_DATETIME DESC;

	
/*
===================================================================================================
DATABASE MANAGEMENT
===================================================================================================
*/
-- SHRINK/OPTIMISE DATABASE

VACUUM;	


/*
===================================================================================================
JOBS SCRIPTS
===================================================================================================
*/
-- SUMMARY QUERY ----------------------------------------------------------------------------------	

SELECT msmt_dte_id
     , cntry_cde
     , count(*) AS row_count
     , sum(cast(facet_cnt AS integer)) AS job_count
  FROM py_jobads_jobs_data
 WHERE 1 = 1
       AND msmt_dte_id >= strftime ( '%Y%m%d', date ( 'now', 'localtime', '-2 day' ) )
 GROUP BY msmt_dte_id
-- site_cde,
        , cntry_cde
 ORDER BY CASE cntry_cde
               WHEN 'AU' THEN 1
               WHEN 'NZ' THEN 2
               WHEN 'UK' THEN 3
               WHEN 'CA' THEN 4
               WHEN 'US' THEN 5
          END
        , 1 DESC;
			
commit;


	
-- DETAIL QUERY -----------------------------------------------------------------------------------
SELECT
	MAX( MSMT_DTE_ID ) AS msmt_dte_id,
	CNTRY_CDE,
	SITE_CDE,
	SUM( CURR_ROW_CNT ) AS CURR_ROW_CNT,
	SUM( PREV_ROW_CNT ) AS PREV_ROW_CNT,
	SUM( CURR_FACET_CNT ) AS CURR_FACET_CNT,
	SUM( PREV_FACET_CNT ) AS PREV_FACET_CNT
FROM
	(
		SELECT
			msmt_dte_id,
			cntry_cde,
			site_cde,
			CASE
				WHEN MSMT_DTE_ID = strftime(
					'%Y%m%d',
					DATE(
						'now',
						'localtime'
					)
				) THEN COUNT(*)
				ELSE 0
			END AS CURR_ROW_CNT,
			CASE
				WHEN MSMT_DTE_ID = strftime(
					'%Y%m%d',
					DATE(
						'now',
						'localtime',
						'-1 day'
					)
				) THEN COUNT(*)
				ELSE 0
			END AS PREV_ROW_CNT,
			CASE
				WHEN MSMT_DTE_ID = strftime(
					'%Y%m%d',
					DATE(
						'now',
						'localtime'
					)
				) THEN SUM( FACET_CNT )
				ELSE 0
			END AS CURR_FACET_CNT,
			CAST(
				CASE
					WHEN MSMT_DTE_ID = strftime(
						'%Y%m%d',
						DATE(
							'now',
							'localtime',
							'-1 day'
						)
					) THEN SUM( FACET_CNT )
					ELSE 0
				END AS INTEGER
			) AS PREV_FACET_CNT
		FROM
			PY_JOBADS_JOBS_DATA
		WHERE
			1 = 1
			AND cntry_cde = 'UK'
			AND MSMT_DTE_ID >= strftime(
				'%Y%m%d',
				DATE(
					'now',
					'localtime',
					'-1 day'
				)
			)
		GROUP BY
			msmt_dte_id,
			cntry_cde,
			site_cde
	)
GROUP BY
	CNTRY_CDE,
	SITE_CDE
ORDER BY
	1,
	2,
	3;
	


SELECT * FROM PY_JOBADS_JOBS_DATA WHERE SITE_CDE = 'JORAX2' AND CNTRY_CDE = 'UK' AND MSMT_DTE_ID = 20191002 ;

/*
===================================================================================================
BUSINESSES FOR SALE SCRIPTS
===================================================================================================
*/
-- SUMMARY QUERY ----------------------------------------------------------------------------------
SELECT
	msmt_dte_id,
	cntry_cde,
	SITE_CDE,
	COUNT(*) AS row_count,
	SUM( facet_cnt ) AS job_count
FROM
	PY_JOBADS_B4S_DATA
WHERE
	1 = 1
	AND msmt_dte_id >= strftime(
		'%Y%m%d',
		DATE(
			'now',
			'localtime',
			'-5 day'
		)
	)
GROUP BY
	msmt_dte_id,
	-- site_cde,
 cntry_cde,
	SITE_CDE
ORDER BY
	2,
	1 DESC;

-- DETAIL QUERY -----------------------------------------------------------------------------------
	
	SELECT
	MAX( MSMT_DTE_ID ) AS msmt_dte_id,
	CNTRY_CDE,
	SITE_CDE,
	SUM( CURR_ROW_CNT ) AS CURR_ROW_CNT,
	SUM( PREV_ROW_CNT ) AS PREV_ROW_CNT,
	SUM( CURR_FACET_CNT ) AS CURR_FACET_CNT,
	SUM( PREV_FACET_CNT ) AS PREV_FACET_CNT
FROM
	(
		SELECT
			msmt_dte_id,
			cntry_cde,
			site_cde,
			CASE
				WHEN MSMT_DTE_ID = strftime(
					'%Y%m%d',
					DATE(
						'now',
						'localtime'
					)
				) THEN COUNT(*)
				ELSE 0
			END AS CURR_ROW_CNT,
			CASE
				WHEN MSMT_DTE_ID = strftime(
					'%Y%m%d',
					DATE(
						'now',
						'localtime',
						'-1 day'
					)
				) THEN COUNT(*)
				ELSE 0
			END AS PREV_ROW_CNT,
			CASE
				WHEN MSMT_DTE_ID = strftime(
					'%Y%m%d',
					DATE(
						'now',
						'localtime'
					)
				) THEN SUM( FACET_CNT )
				ELSE 0
			END AS CURR_FACET_CNT,
			CAST(
				CASE
					WHEN MSMT_DTE_ID = strftime(
						'%Y%m%d',
						DATE(
							'now',
							'localtime',
							'-1 day'
						)
					) THEN SUM( FACET_CNT )
					ELSE 0
				END AS INTEGER
			) AS PREV_FACET_CNT
		FROM
			PY_JOBADS_B4S_DATA
		WHERE
			1 = 1
			AND MSMT_DTE_ID >= strftime(
				'%Y%m%d',
				DATE(
					'now',
					'localtime',
					'-1 day'
				)
			)
		GROUP BY
			msmt_dte_id,
			cntry_cde,
			site_cde
	)
GROUP BY
	CNTRY_CDE,
	SITE_CDE
ORDER BY
	1,
	3;


/*
===================================================================================================
COMMODITY SCRIPTS
===================================================================================================
*/

SELECT msmt_dte_id
     , cmdty_cde
     , trade_dt
     , count(*) AS row_cnt
     , round(sum(index_val), 4) AS index_val
     , round(sum(high_val), 4) AS high_val
     , round(sum(low_val), 4) AS low_val
     , round(sum(ttl_mrkt_val), 4) AS ttl_mrkt_val
  FROM py_commodity_data
 WHERE 1 = 1
       AND trade_dt >= strftime ( '%Y-%m-%d', date ( 'now', 'localtime', '-8 day' ) )
       AND CAPTR_DTE_ID = (select max(CAPTR_DTE_ID) from PY_COMMODITY_DATA)
 GROUP BY msmt_dte_id
        , cmdty_cde
        , trade_dt
 ORDER BY 2
        , 1 DESC;
	



WITH max_dt
     AS (
     SELECT max(MSMT_DTE_ID) as max_captr_dte
       FROM py_commodity_data)
     SELECT max(msmt_dte_id) as msmt_dte
          , sum(CASE
                 WHEN max_captr_dte = msmt_dte_id
                 THEN 1
                 ELSE 0
            END) AS curr_dte_cnt
          , sum(CASE
                 WHEN max_captr_dte != msmt_dte_id
                 THEN 1
                 ELSE 0
            END) AS prev_dte_cnt
       FROM py_commodity_data
            CROSS JOIN max_dt
      WHERE 1 = 1
            AND trade_dt >= strftime ( '%Y-%m-%d', date ( 'now', 'localtime', '-4 day' ) )
      ORDER BY 2
             , 1 DESC;

                               
     /*
     , round(sum(index_val), 4) AS index_val
     , round(sum(high_val), 4) AS high_val
     , round(sum(low_val), 4) AS low_val
     , round(sum(ttl_mrkt_val), 4) AS ttl_mrkt_val
     */                               
-- TWITTER SUMMARY QUERY ----------------------------------------------------------------------------------	

SELECT msmt_dte_id
     , cntry_cde
     , count(*) AS row_count
  FROM PY_EMP_TWITTER_DATA
 WHERE 1 = 1
       AND msmt_dte_id >= strftime ( '%Y%m%d', date ( 'now', 'localtime', '-2 day' ) )
 GROUP BY msmt_dte_id
-- site_cde,
        , cntry_cde
 ORDER BY CASE cntry_cde
               WHEN 'AU' THEN 1
               WHEN 'NZ' THEN 2
               WHEN 'UK' THEN 3
               WHEN 'CA' THEN 4
               WHEN 'US' THEN 5
          END
        , 1 DESC;    	
	
	
	
/*
===================================================================================================
LABOUR FORCE SCRIPTS
===================================================================================================
*/
SELECT
	*
FROM
	PY_LABOUR_FORCE_AU
ORDER BY
	2 desc;


  


/*
===================================================================================================
ECONOMIC CALENDAR SCRIPTS
===================================================================================================
*/  

DELETE
--SELECT *
  FROM PY_ECONOMIC_CALENDAR
 WHERE 1 = 1
   AND MSMT_DTE_ID IN (101110
,101109
,101108
,101107
,101106
,101105
,101104
);



SELECT
	*
FROM
	PY_ECONOMIC_CALENDAR
WHERE
	1 = 1
	AND CAPTR_DTE_ID = (
	SELECT
		MAX(CAPTR_DTE_ID)
	FROM
		PY_ECONOMIC_CALENDAR)
ORDER BY
	MSMT_DTE_ID DESC,
	CNTRY_CDE,
	ANNCE_CDE;
  
/*
GOVT MEDIA RELEASE DATA
===================================================================================================
*/  
  

              
SELECT * FROM PY_GOVT_DATA_MTHLY_CHNG_AU_MEDIA_RELEASE;


/*
MOVING DATA FROM 1 DATABASE TO ANOTHER
-- HELPFUL WHEN CONFLICT DB HAS DATA THAT HASNT BEEN APPLIED TO ACTUAL DB
*/
select * from att_db.PY_EMP_TWITTER_DATA

ATTACH DATABASE 'D:\Sync\__lanoitan\@data\LTN_STG_DATA-CONFLICT-1.db'  AS att_db;

INSERT INTO py_jobads_jobs_data ( msmt_dte_id
                                , data_type
                                , cntry_cde
                                , site_cde
                                , facet_type
                                , facet_desc
                                , facet_cnt
                                , started_at
                                , finished_at
                                )
SELECT msmt_dte_id
     , data_type
     , cntry_cde
     , site_cde
     , facet_type
     , facet_desc
     , facet_cnt
     , started_at
     , finished_at
  FROM att_db.py_jobads_jobs_data AS a
 WHERE 1 = 1
   --AND CNTRY_CDE IN ('AU')
   AND MSMT_DTE_ID = 20190803
		    and CNTRY_CDE = 'UK'
		    and site_cde = 'JORAX2';

  
  
  
  
INSERT
	INTO
		PY_EMP_TWITTER_DATA ( MSMT_DTE_ID ,
		CREATED_AT ,
		TWEET_ID ,
		USER_ID ,
		USER_NAME ,
		USER_SCREEN_NAME ,
		USER_LOCATION ,
		CNTRY_ID ,
		CNTRY_CDE ,
		PLACE_NAME ,
		SENTMT_MATCH ,
		TWEET_TXT ,
		IN_REPLY_TO ,
		RE_TWEETED ,
		PRCES_DTE_ID ,
		STARTED_AT ,
		FINISHED_AT ) 
	SELECT
			MSMT_DTE_ID ,
			CREATED_AT ,
			TWEET_ID ,
			USER_ID ,
			USER_NAME ,
			USER_SCREEN_NAME ,
			USER_LOCATION ,
			CNTRY_ID ,
			CNTRY_CDE ,
			PLACE_NAME ,
			SENTMT_MATCH ,
			TWEET_TXT ,
			IN_REPLY_TO ,
			RE_TWEETED ,
			PRCES_DTE_ID ,
			STARTED_AT ,
			FINISHED_AT
		FROM
			att_db.PY_EMP_TWITTER_DATA AS a
		WHERE
			1 = 1
			AND MSMT_DTE_ID >=  ;
  
  

--DELETE  
--FROM PY_EMP_TWITTER_DATA
--  WHERE 1 = 1
--   AND MSMT_DTE_ID = 20190325;   
  
  
  
commit;

DETACH att_db;
