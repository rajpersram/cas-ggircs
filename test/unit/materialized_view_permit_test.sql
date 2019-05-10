set client_encoding = 'utf-8';
set client_min_messages = warning;
create extension if not exists pgtap;
reset client_min_messages;

begin;
select plan(20);

select has_materialized_view(
    'ggircs_swrs', 'permit',
    'ggircs_swrs.permit should be a materialized view'
);

select has_index(
    'ggircs_swrs', 'permit', 'ggircs_permit_primary_key',
    'ggircs_swrs.permit should have a primary key'
);

select columns_are('ggircs_swrs'::name, 'permit'::name, array[
    'ghgr_import_id'::name,
    'path_context'::name,
    'permit_idx'::name,
    'issuing_agency'::name,
    'issuing_dept_agency_program'::name,
    'permit_number'::name
]);

select col_type_is(      'ggircs_swrs', 'permit', 'ghgr_import_id', 'integer', 'permit.ghgr_import_id column should be type integer');
select col_hasnt_default('ggircs_swrs', 'permit', 'ghgr_import_id', 'permit.ghgr_import_id column should not have a default value');

--  select has_column(       'ggircs_swrs', 'permit', 'path_context', 'permit.path_context column should exist');
select col_type_is(      'ggircs_swrs', 'permit', 'path_context', 'character varying(1000)', 'permit.path_context column should be type varchar');
select col_is_null(      'ggircs_swrs', 'permit', 'path_context', 'permit.path_context column should not allow null');
select col_hasnt_default('ggircs_swrs', 'permit', 'path_context', 'permit.path_context column should not have a default');

--  select has_column(       'ggircs_swrs', 'permit', 'permit_idx', 'permit.permit_idx column should exist');
select col_type_is(      'ggircs_swrs', 'permit', 'permit_idx', 'integer', 'permit.permit_idx column should be type integer');
select col_is_null(      'ggircs_swrs', 'permit', 'permit_idx', 'permit.permit_idx column should not allow null');
select col_hasnt_default('ggircs_swrs', 'permit', 'permit_idx', 'permit.permit_idx column should not have a default');

--  select has_column(       'ggircs_swrs', 'permit', 'issuing_agency', 'permit.issuing_agency column should exist');
select col_type_is(      'ggircs_swrs', 'permit', 'issuing_agency', 'character varying(1000)', 'permit.issuing_agency column should be type varchar');
select col_is_null(      'ggircs_swrs', 'permit', 'issuing_agency', 'permit.issuing_agency column should not allow null');
select col_hasnt_default('ggircs_swrs', 'permit', 'issuing_agency', 'permit.issuing_agency column should not have a default');

--  select has_column(       'ggircs_swrs', 'permit', 'issuing_dept_agency_program', 'permit.issuing_dept_agency_program column should exist');
select col_type_is(      'ggircs_swrs', 'permit', 'issuing_dept_agency_program', 'character varying(1000)', 'permit.issuing_dept_agency_program column should be type varchar');
select col_is_null(      'ggircs_swrs', 'permit', 'issuing_dept_agency_program', 'permit.issuing_dept_agency_program column should not allow null');
select col_hasnt_default('ggircs_swrs', 'permit', 'issuing_dept_agency_program', 'permit.issuing_dept_agency_program column should not have a default');

--  select has_column(       'ggircs_swrs', 'permit', 'permit_number', 'permit.permit_number column should exist');
select col_type_is(      'ggircs_swrs', 'permit', 'permit_number', 'character varying(1000)', 'permit.permit_number column should be type varchar');
select col_is_null(      'ggircs_swrs', 'permit', 'permit_number', 'permit.permit_number column should not allow null');
select col_hasnt_default('ggircs_swrs', 'permit', 'permit_number', 'permit.permit_number column should not have a default');

refresh materialized view ggircs_swrs.permit with data;

-- TODO: Add a fixture to test the veracity of what is being pulled in to this view from xml

select * from finish();
rollback;