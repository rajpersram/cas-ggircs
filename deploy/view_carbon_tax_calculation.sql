-- Deploy ggircs:view_carbon_tax_calculation to pg
-- requires:
    -- schema_ggircs
    -- table_fuel
    -- table_report

begin;

create or replace view ggircs.carbon_tax_calculation as
    with fuel as (
        select _fuel.fuel_type,
               _fuel.annual_fuel_amount                   as amount,
               _report.reporting_period_duration::integer as year,
               ctr.pro_rated_carbon_tax_rate              as pro_rated_ctr,
               ief.pro_rated_implied_emission_factor      as pro_rated_ief
        from ggircs.fuel as _fuel
                 join ggircs_swrs.fuel_mapping as _fuel_mapping
                      on _fuel.fuel_type = _fuel_mapping.fuel_type
                 join ggircs.report as _report
                      on _fuel.report_id = _report.id
                 join ggircs.pro_rated_carbon_tax_rate as ctr
                      on _fuel.fuel_type = ctr.fuel_type
                        and _report.reporting_period_duration::integer = ctr.reporting_year
                 join ggircs.pro_rated_implied_emission_factor as ief
                      on ief.fuel_mapping_id = _fuel_mapping.id
                        and _report.reporting_period_duration::integer = ief.reporting_year
    )
select fuel.year,
       fuel.fuel_type,
       fuel.amount,
       (fuel.amount * pro_rated_ctr * pro_rated_ief) as calculated_carbon_tax
from fuel;
commit;
