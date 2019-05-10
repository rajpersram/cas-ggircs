set client_min_messages to warning;
create extension if not exists pgtap;
reset client_min_messages;

begin;
select plan(6);

-- Test table ghgr_import exists in schema ggircs_swrs
select has_table('ggircs_swrs', 'table_ignore_organisation', 'Table table_ignore_organisation exists');

-- Test column names in table ghgr_import are correct
select columns_are('ggircs_swrs'::name, 'table_ignore_organisation'::name, ARRAY[
  'swrs_organisation_id'::name
]);

-- Test column id is the Primary Key
select col_is_pk('ggircs_swrs', 'table_ignore_organisation', 'swrs_organisation_id', 'Column swrs_organisation_id is Primary Key');

-- Test columns have correct types
select col_type_is('ggircs_swrs', 'table_ignore_organisation', 'swrs_organisation_id', 'numeric(1000,0)', 'Column swrs_organisation_id has type numeric');

-- Test NOT NULL columns have constraint
select col_not_null('ggircs_swrs', 'table_ignore_organisation', 'swrs_organisation_id', 'Column swrs_organisation_id has NOT NULL constraint');

-- Test default columns have default
select col_hasnt_default('ggircs_swrs', 'table_ignore_organisation', 'swrs_organisation_id', 'Column swrs_organisation_id has default');

select finish();
rollback;