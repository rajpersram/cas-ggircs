-- Deploy ggircs:function_load_permit to pg
-- requires: materialized_view_facility
-- requires: materialized_view_final_report
-- requires: materialized_view_permit

begin;

create or replace function swrs_transform.load_permit()
  returns void as
$function$
    begin

        delete from swrs_load.permit;
        insert into swrs_load.permit(id, ghgr_import_id, report_id, facility_id,  path_context, issuing_agency, issuing_dept_agency_program, permit_number)

        select _permit.id, _permit.ghgr_import_id, _report.id, _facility.id,  _permit.path_context, _permit.issuing_agency, _permit.issuing_dept_agency_program, _permit.permit_number

        from swrs_transform.permit as _permit

        inner join swrs_transform.final_report as _final_report on _permit.ghgr_import_id = _final_report.ghgr_import_id
        -- FK Permit -> Report
        left join swrs_transform.report as _report
            on _permit.ghgr_import_id = _report.ghgr_import_id
        -- FK Permit -> Facility
        left join swrs_transform.facility as _facility
            on _permit.ghgr_import_id = _facility.ghgr_import_id;

    end
$function$ language plpgsql volatile;

commit;
