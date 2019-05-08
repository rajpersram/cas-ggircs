-- Deploy ggircs:materialized_view_emission to pg
-- requires: materialized_view_fuel

begin;

-- Emissions from Fuel
create materialized view ggircs_swrs.emission as (
  with x as (
    select ghgr_import.id       as ghgr_import_id,
           ghgr_import.xml_file as source_xml
    from ggircs_swrs.ghgr_import
    order by ghgr_import_id desc
  )
  select x.ghgr_import_id,
         emission_details.*
  from x,
       xmltable(
           '//Emission'
           passing source_xml
           columns
             activity_name varchar(1000) path 'name(./ancestor::ActivityData/*)' not null,
             sub_activity_name varchar(1000) path 'name(./ancestor::ActivityData/*/*)' not null,
             unit_name varchar(1000) path 'name((./ancestor::Substances/parent::*/parent::*|./ancestor::Substance/parent::*/parent::*/parent::*)[1])' not null,
             sub_unit_name varchar(1000) path 'name((./ancestor::Substances/parent::*|./ancestor::Substance/parent::*/parent::*)[1])' not null,
             process_idx integer path 'string(count(./ancestor::Process/preceding-sibling::Process))' not null,
             sub_process_idx integer path 'string(count(./ancestor::SubProcess/preceding-sibling::SubProcess))' not null,
             units_idx integer path 'string(count(./ancestor::Units/preceding-sibling::Units))' not null,
             unit_idx integer path 'string(count(./ancestor::Unit/preceding-sibling::Unit))' not null,
             substances_idx integer path 'string(count(./ancestor::Substance/parent::*/preceding-sibling::*))' not null,
             substance_idx integer path 'string(count(./ancestor::Substance/preceding-sibling::Substance))' not null,
             fuel_idx integer path 'string(count(./ancestor::Fuel/preceding-sibling::Fuel))' not null,
             fuel_name varchar(1000) path 'name((./ancestor::Emissions/parent::*[not(name() = "Substance")][not(name() = "Substances")] | ./parent::*[not(name() = "Emissions")])[1])' not null, -- ghgr_import_id=2514
             emissions_idx integer path 'string(count(./ancestor::Emissions/preceding-sibling::Emissions))' not null,
             emission_idx integer path 'string(count(./preceding-sibling::Emission))' not null,
             emission_type varchar(1000) path '../@EmissionsType[normalize-space(.)]',
             gas_type varchar(1000) path 'GasType[normalize-space(.)]',
             methodology varchar(1000) path 'Methodology[normalize-space(.)]',
             not_applicable boolean path 'NotApplicable[normalize-space(.)]',
             quantity numeric(1000, 0) path 'Quantity[normalize-space(.)]' default 0,
             calculated_quantity numeric(1000, 0) path 'CalculatedQuantity[normalize-space(.)]' default 0,
             emission_category varchar(1000) path '(Groups/EmissionGroupTypes/text()[contains(normalize-space(.), "BC_ScheduleB_")])[1]'
         ) as emission_details
  order by ghgr_import_id
) with no data;

create unique index ggircs_emission_primary_key on ggircs_swrs.emission (ghgr_import_id, activity_name,
                                                                         sub_activity_name, unit_name, sub_unit_name,
                                                                         process_idx, sub_process_idx, units_idx,
                                                                         unit_idx, substances_idx, substance_idx,
                                                                         fuel_idx, fuel_name, emissions_idx, emission_idx);

comment on materialized view ggircs_swrs.emission is 'The materialized view containing the information on emissions';
comment on column ggircs_swrs.emission.ghgr_import_id is 'A foreign key reference to ggircs_swrs.ghgr_import';
comment on column ggircs_swrs.emission.activity_name is 'The name of the activity (partial fk reference)';
comment on column ggircs_swrs.emission.sub_activity_name is 'The name of the sub_activity (partial fk reference)';
comment on column ggircs_swrs.emission.unit_name is 'The name of the unit (partial fk reference)';
comment on column ggircs_swrs.emission.sub_unit_name is 'The name of the sub_unit (partial fk reference)';
comment on column ggircs_swrs.emission.process_idx is 'The number of preceding Process siblings before this emission';
comment on column ggircs_swrs.emission.sub_process_idx is 'The number of preceding SubProcess siblings before this emission';
comment on column ggircs_swrs.emission.units_idx is 'The number of preceding Units siblings before this Units (partial fk reference)';
comment on column ggircs_swrs.emission.unit_idx is 'The number of preceding Unit siblings before this emission';
comment on column ggircs_swrs.emission.substances_idx is 'The number of preceding siblings before the Substances';
comment on column ggircs_swrs.emission.substance_idx is 'The number of preceding siblings before the Substance';
comment on column ggircs_swrs.emission.fuel_idx is 'The number of preceding Fuel siblings before this emission';
comment on column ggircs_swrs.emission.fuel_name is 'The disambiguation string for Fuel (only on old reports)';
comment on column ggircs_swrs.emission.emissions_idx is 'The number of preceding Emissions siblings before this emission';
comment on column ggircs_swrs.emission.emission_idx is 'The number of preceding Emission siblings before this emission';
comment on column ggircs_swrs.emission.emission_type is 'The type of the emission';
comment on column ggircs_swrs.emission.gas_type is 'The type of the gas';
comment on column ggircs_swrs.emission.methodology is 'The emission methodology';
comment on column ggircs_swrs.emission.not_applicable is 'Is the emission applicable/NA';
comment on column ggircs_swrs.emission.quantity is 'The quantity of the emission';
comment on column ggircs_swrs.emission.calculated_quantity is 'The CO2 Equivalent quantity of the emission';
comment on column ggircs_swrs.emission.emission_category is 'The emissions category';

commit;