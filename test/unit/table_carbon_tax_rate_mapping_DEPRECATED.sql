set client_encoding = 'utf-8';
set client_min_messages = warning;
create extension if not exists pgtap;
reset client_min_messages;

begin;
select plan(11);

-- Test table exists in ggircs_swrs schema
select has_table(
    'ggircs_swrs', 'carbon_tax_rate_mapping',
    'ggircs_swrs_load.carbon_tax_rate_mapping should exist as a table'
);

-- Test table has a primary key
select col_is_pk('ggircs_swrs', 'carbon_tax_rate_mapping', 'id', 'Column id is Primary Key');

select columns_are('ggircs_swrs'::name, 'carbon_tax_rate_mapping'::name, array[
    'id'::name,
    'rate_start_date'::name,
    'rate_end_date'::name,
    'carbon_tax_rate'::name
]);

-- Test column attributes
select col_type_is( 'ggircs_swrs', 'carbon_tax_rate_mapping', 'id', 'integer', 'carbon_tax_rate_mapping.id column should be type integer');
select col_hasnt_default('ggircs_swrs', 'carbon_tax_rate_mapping', 'id', 'carbon_tax_rate_mapping.id column should not have a default value');

select col_type_is( 'ggircs_swrs', 'carbon_tax_rate_mapping', 'rate_start_date', 'date', 'carbon_tax_rate_mapping.rate_start_date column should be type date');
select col_hasnt_default('ggircs_swrs', 'carbon_tax_rate_mapping', 'rate_start_date', 'carbon_tax_rate_mapping.rate_start_date column should not have a default value');

select col_type_is( 'ggircs_swrs', 'carbon_tax_rate_mapping', 'rate_end_date', 'date', 'carbon_tax_rate_mapping.rate_end_date column should be type date');
select col_hasnt_default('ggircs_swrs', 'carbon_tax_rate_mapping', 'rate_end_date', 'carbon_tax_rate_mapping.rate_end_date column should not have a default value');

select col_type_is( 'ggircs_swrs', 'carbon_tax_rate_mapping', 'carbon_tax_rate', 'numeric', 'carbon_tax_rate_mapping.carbon_tax_rate column should be type numeric');
select col_hasnt_default('ggircs_swrs', 'carbon_tax_rate_mapping', 'carbon_tax_rate', 'carbon_tax_rate_mapping.carbon_tax_rate column should not have a default value');

select * from finish();
rollback;
