-- Verify ggircs:materialized_view_report on pg

BEGIN;

select * from ggircs_swrs.report;

ROLLBACK;
