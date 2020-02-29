/*
=======================================================================================================================================================================================================
SUBJECT      : australian business names register (data.gov.au) 
OBJECT TYPE  : stored procedure
OBJECT NAME  : rf.create_stg_xml_abr_w
CREATED BY   : Harold Delaney
CREATED ON   : 20200227
SOURCE       : https://data.gov.au/dataset/ds-dga-5bd7fcab-e315-42cb-8daf-50b7efc2027e/details
PREPERATION  : knime downloads 2 zip files
               decompresses files
               calls rf.create_stg_xml_abr_w to ingest into db
               
REMARKS      : 1) ingestion managed by stored procedure as KNIME performance is poor when handling large xml files
               2) see https://stackoverflow.com/questions/19007884/import-xml-files-to-postgresql 
               3) see https://www.postgresql.org/message-id/5D5B211D-317B-4A62-B625-C2D28323DAFD%40gmx.net
=======================================================================================================================================================================================================

TABLE CREATION
-----------------------------

call create_stg_xml_abr_w ('H:\__rodinaFre.local\__data\__preprocessed\BUSINESS.NAMES.REGISTER\20200226_Public01.xml')

*/


CREATE OR REPLACE
PROCEDURE create_stg_xml_abr_w ( p_file_name_full IN varchar ) LANGUAGE plpgsql AS $$
DECLARE
    myxml XML;
    datafile TEXT := p_file_name_full;  -- 'path/to/my_file.xml';

BEGIN
    
    myxml := lo_import(datafile); -- pg_read_file(datafile, 0, 800000000);  -- arbitrary 800 MB max.
    
    CREATE TEMP TABLE xml_tmp AS
    SELECT (XPATH('//ABR/@recordLastUpdatedDate/text()', x))[1]::INT AS RCRD_LAST_UPD_DT
          /*(XPATH('//ID/text()', x))[1]::TEXT AS id ,
          (XPATH('//Name/text()', x))[1]::TEXT AS NAME ,
          (XPATH('//RFC/text()', x))[1]::TEXT AS RFC ,
          (XPATH('//Text/text()', x))[1]::TEXT AS TEXT ,
          (XPATH('//Desc/text()', x))[1]::TEXT AS DESC*/
    FROM   UNNEST(XPATH('//Transfer/ABR', myxml)) x ;
   

END;
$$;


--SHOW  data_directory;


/*

DO $$
   DECLARE myxml xml;
BEGIN

myxml := XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('H:\__rodinaFre.local\__data\__preprocessed\BUSINESS.NAMES.REGISTER\20200226_Public01.xml'), 'UTF8'));

DROP TABLE IF EXISTS xml_table;
CREATE TEMP TABLE xml_table AS 
SELECT (XPATH('//ABR/@recordLastUpdatedDate/text()', x))[1]::INT AS RCRD_LAST_UPD_DT
          /*(XPATH('//ID/text()', x))[1]::TEXT AS id ,
          (XPATH('//Name/text()', x))[1]::TEXT AS NAME ,
          (XPATH('//RFC/text()', x))[1]::TEXT AS RFC ,
          (XPATH('//Text/text()', x))[1]::TEXT AS TEXT ,
          (XPATH('//Desc/text()', x))[1]::TEXT AS DESC*/
    FROM   UNNEST(XPATH('//Transfer/ABR', myxml)) x ;
;

END$$;

*/