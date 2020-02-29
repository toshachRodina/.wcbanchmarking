select
	dat.PKG_NME,
	dat.START_DATETIME,
	dat.END_DATETIME,
	dat.STATUS,
	dat.VARS
from
	PY_PROCESS_LOG dat,
	(
		select
			PKG_NME,
			max( START_DATETIME ) as START_DATETIME,
			max( END_DATETIME ) as END_DATETIME
		from
			PY_PROCESS_LOG
		where
			1 = 1
			and msmt_dte_id = strftime(
				'%Y%m%d',
				date(
					'now',
					'localtime'
				)
			)
			and PKG_NME not like '%BATCH%'
		group by
			PKG_NME
	) list
where
	1 = 1
	and dat.PKG_NME = list.PKG_NME
	and dat.END_DATETIME = list.END_DATETIME and dat.STATUS = 'ERROR'
order by
	dat.END_DATETIME desc;

	
	select *
from
	PY_PROCESS_LOG
where
	1 = 1
	and msmt_dte_id >= strftime(
		'%Y%m%d',
		date(
			'now',
			'localtime',
			'-2 day'
		)
	)
order by 1 desc;	
	
SELECT date('now','-2 day');"	
	
select
	*
from
	PY_PROCESS_LOG
where
	1 = 1
	and msmt_dte_id = strftime(
		'%Y%m%d',
		date(
			'now',
			'localtime'
		)
	)
	and PKG_NME not like '%BATCH%'
order by
	END_DATETIME desc;
	
	
	
select
	MSMT_DTE_ID,
	PKG_NME,
	STATUS,
	START_DATETIME,
	END_DATETIME	
from
	PY_PROCESS_LOG
where 1 = 1
	and msmt_dte_id = strftime(
		'%Y%m%d',
		date(
			'now',
			'localtime'
		)
	)
	and PKG_NME not like '%BATCH%'	
order by
	END_DATETIME desc;