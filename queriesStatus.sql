create or replace view _dba_query_stats as
select
  SUBSTRING(VARIABLE_NAME, 5) as query_type,
  VARIABLE_VALUE as total_count,
  round(VARIABLE_VALUE / ( select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'Uptime_since_flush_status'), 2) as per_second,
  round(VARIABLE_VALUE / ((select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'Uptime_since_flush_status') / (60)))       as per_minute,
  round(VARIABLE_VALUE / ((select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'Uptime_since_flush_status') / (60*60)))    as per_hour,
  round(VARIABLE_VALUE / ((select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'Uptime_since_flush_status') / (60*60*24))) as per_day,
  FROM_UNIXTIME(round(UNIX_TIMESTAMP(sysdate()) - (select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'Uptime_since_flush_status'))) report_period_start,
  sysdate() as report_period_end,
  TIME_FORMAT(SEC_TO_TIME((select VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME = 'Uptime_since_flush_status')),'%Hh %im') as report_period_duration
from
  information_schema.GLOBAL_STATUS
where
  VARIABLE_NAME in ('Com_select', 'Com_delete', 'Com_update', 'Com_insert');
