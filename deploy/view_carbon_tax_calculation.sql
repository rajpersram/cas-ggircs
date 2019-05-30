-- Deploy ggircs:view_carbon_tax_calculation to pg
-- requires: schema_ggircs

begin;

create or replace view ggircs.carbon_tax_calculation as
    with x as (
        select fuel.fuel_type                           as fuel_type,
               fuel.annual_fuel_amount                  as amount,
               report.reporting_period_duration         as rpd,
               pro_rated_carbon_tax_rate                as pro_rated_ctr,
               pro_rated_implied_emission_factor        as pro_rated_ief
        from ggircs_swrs.fuel
                join ggircs_swrs.fuel_mapping as fm
                    on fuel.fuel_type = fm.fuel_type
                join ggircs_swrs.report as report
                    on fuel.ghgr_import_id = report.ghgr_import_id
                join ggircs.pro_rated_carbon_rate as ctr
                    on fuel.fuel_type = ctr.fuel_type
                    and report.reporting_period_duration = ctr.reporting_year
                join ggircs.pro_rated_implied_emission_factor as ief
                    on ief.fuel_mapping_id = fm.id
                    and report.reporting_period_duration = ief.reporting_year

    )
    select x.rpd as year,
           x.fuel_type as fuel_type,
           x.pro_rated_ctr as pro_rated_ctr,
           x.pro_rated_ief as pro_rated_ief,
           x.amount as amount,
           (x.amount * x.pro_rated_ctr * x.pro_rated_ief) as calculated_carbon_tax
    from x
;
commit;
