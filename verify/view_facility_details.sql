-- Verify ggircs:view_facility_details on pg

BEGIN;

select * from ggircs.facility_details where false;

ROLLBACK;
