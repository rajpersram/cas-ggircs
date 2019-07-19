set client_encoding = 'utf-8';
set client_min_messages = warning;
create extension if not exists pgtap;
reset client_min_messages;

begin;
select * from no_plan();

insert into ggircs_swrs_extract.ghgr_import (xml_file) values ($$
<ReportData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ReportDetails>
    <ReportID>1234</ReportID>
    <ReportType>R1</ReportType>
    <FacilityId>0000</FacilityId>
    <FacilityType>EIO</FacilityType>
    <OrganisationId>00001</OrganisationId>
    <ReportingPeriodDuration>2025</ReportingPeriodDuration>
    <ReportStatus>
      <Status>Submitted</Status>
      <SubmissionDate>2013-03-27T19:25:55.32</SubmissionDate>
      <LastModifiedBy>Buddy</LastModifiedBy>
    </ReportStatus>
  </ReportDetails>
  <OperationalWorkerReport/>
</ReportData>
$$);

refresh materialized view ggircs_swrs_transform.report with data;
refresh materialized view ggircs_swrs_transform.final_report with data;
select ggircs_swrs_transform.load_report();

select ghgr_import_id from ggircs_swrs_load.report;
select '======';
select ghgr_import_id from ggircs_swrs_transform.report;

-- Table ggircs_swrs_load.report exists
select has_table('ggircs'::name, 'report'::name);

-- Report has pk
select has_pk('ggircs', 'report', 'ggircs_report has primary key');

-- Report has data
select isnt_empty('select * from ggircs_swrs_load.report', 'there is data in ggircs_swrs_load.report');

-- Data in ggircs_swrs_transform.report === data in ggircs_report
select set_eq($$
                  select
                      ghgr_import_id,
                      imported_at,
                      swrs_report_id,
                      prepop_report_id,
                      report_type,
                      swrs_facility_id,
                      swrs_organisation_id,
                      reporting_period_duration,
                      status,
                      version,
                      submission_date,
                      last_modified_by,
                      last_modified_date,
                      update_comment
                  from ggircs_swrs_transform.report
                  $$,

                 $$
                 select
                      ghgr_import_id,
                      imported_at,
                      swrs_report_id,
                      prepop_report_id,
                      report_type,
                      swrs_facility_id,
                      swrs_organisation_id,
                      reporting_period_duration,
                      status,
                      version,
                      submission_date,
                      last_modified_by,
                      last_modified_date,
                      update_comment
                  from ggircs_swrs_load.report
                  $$,

    'data in ggircs_swrs_transform.report === ggircs_swrs_load.report');

select * from finish();
rollback;
