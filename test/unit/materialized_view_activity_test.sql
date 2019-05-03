set client_encoding = 'utf-8';
set client_min_messages = warning;
create extension if not exists pgtap;
reset client_min_messages;

begin;
select plan(24);

select has_materialized_view(
    'ggircs_swrs', 'activity',
    'ggircs_swrs.activity should be a materialized view'
);

select has_index(
    'ggircs_swrs', 'activity', 'ggircs_activity_primary_key',
    'ggircs_swrs.activity should have a primary key'
);

select columns_are('ggircs_swrs'::name, 'activity'::name, array[
    'id'::name,
    'ghgr_import_id'::name,
    'process_name'::name,
    'subprocess_name'::name,
    'information_requirement'::name,
    'xml_hunk'::name
]);

--  select has_column(       'ggircs_swrs', 'activity', 'id', 'activity.id column should exist');
select col_type_is(      'ggircs_swrs', 'activity', 'id', 'bigint', 'activity.id column should be type bigint');

--  select has_column(       'ggircs_swrs', 'activity', 'ghgr_import_id', 'activity.ghgr_import_id column should exist');
select col_type_is(      'ggircs_swrs', 'activity', 'ghgr_import_id', 'integer', 'activity.ghgr_import_id column should be type integer');
select col_hasnt_default('ggircs_swrs', 'activity', 'ghgr_import_id', 'activity.ghgr_import_id column should not have a default value');

--  select has_column(       'ggircs_swrs', 'activity', 'process_name', 'activity.process_name column should exist');
select col_type_is(      'ggircs_swrs', 'activity', 'process_name', 'character varying(1000)', 'activity.process_name column should be type text');
select col_is_null(      'ggircs_swrs', 'activity', 'process_name', 'activity.process_name column should allow null');
select col_hasnt_default('ggircs_swrs', 'activity', 'process_name', 'activity.process_name column should not  have a default');

--  select has_column(       'ggircs_swrs', 'activity', 'subprocess_name', 'activity.subprocess_name column should exist');
select col_type_is(      'ggircs_swrs', 'activity', 'subprocess_name', 'character varying(1000)', 'activity.subprocess_name column should be type text');
select col_is_null(      'ggircs_swrs', 'activity', 'subprocess_name', 'activity.subprocess_name column should allow null');
select col_hasnt_default('ggircs_swrs', 'activity', 'subprocess_name', 'activity.subprocess_name column should not have a default value');

--  select has_column(       'ggircs_swrs', 'activity', 'information_requirement', 'activity.information_requirement column should exist');
select col_type_is(      'ggircs_swrs', 'activity', 'information_requirement', 'character varying(1000)', 'activity.information_requirement column should be type text');
select col_is_null(      'ggircs_swrs', 'activity', 'information_requirement', 'activity.information_requirement column should allow null');
select col_hasnt_default('ggircs_swrs', 'activity', 'information_requirement', 'activity.information_requirement column should not have a default value');

--  select has_column(       'ggircs_swrs', 'activity', 'sub_activity_xml', 'activity.sub_activity_xml column should exist');
select col_type_is(      'ggircs_swrs', 'activity', 'xml_hunk', 'xml', 'activity.xml_hunk column should be type xml');
select col_is_null(      'ggircs_swrs', 'activity', 'xml_hunk', 'activity.xml_hunk column should allow null');
select col_hasnt_default('ggircs_swrs', 'activity', 'xml_hunk', 'activity.xml_hunk column should not have a default value');


-- Insert data for fixture based testing
insert into ggircs_swrs.ghgr_import (xml_file) values ($$
<ReportData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <ActivityData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <ActivityPages>
     <Process ProcessName="GeneralStationaryCombustion">
       <SubProcess SubprocessName="(a) general stationary combustion, useful energy" InformationRequirement="Required" />
     </Process>
   </ActivityPages>
 </ActivityData>
</ReportData>
$$);


-- refresh necessary views with data
refresh materialized view ggircs_swrs.activity with data;

-- test the columns for matview facility have been properly parsed from xml
select results_eq('select id from ggircs_swrs.activity', ARRAY[1::bigint], 'ggircs_swrs.activity.id counts from 1');
select results_eq('select ghgr_import_id from ggircs_swrs.activity', 'select id from ggircs_swrs.ghgr_import', 'ggircs_swrs.activity.ghgr_import_id relates to ggircs_swrs.ghgr_import.id');
select results_eq('select process_name from ggircs_swrs.activity', ARRAY['GeneralStationaryCombustion'::varchar(1000)], 'ggircs_swrs.activity.process_name is extracted');
select results_eq('select subprocess_name from ggircs_swrs.activity', ARRAY['(a) general stationary combustion, useful energy'::varchar(1000)], 'ggircs_swrs.activity.subprocess_name is extracted');
select results_eq('select information_requirement from ggircs_swrs.activity', ARRAY['Required'::varchar(1000)], 'ggircs_swrs.activity.information_requirement is extracted');
select results_eq('select xml_hunk::text from ggircs_swrs.activity', ARRAY['<SubProcess SubprocessName="(a) general stationary combustion, useful energy" InformationRequirement="Required"/>'::text], 'ggircs_swrs.activity.xml_hunk is extracted');


select * from finish();
rollback;