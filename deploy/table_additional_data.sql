-- Deploy ggircs:table_additional_data to pg
-- requires: schema_ggircs

begin;

create table ggircs.additional_data (

    id                        integer primary key,
    report_id                 integer references ggircs.report(id),
    activity_id               integer references ggircs.activity(id),
    ghgr_import_id            integer,
    activity_name             varchar(1000),
    grandparent               varchar(1000),
    parent                    varchar(1000),
    class                     varchar(1000),
    attribute                 varchar(1000),
    attr_value                varchar(10000),
    node_value                varchar(10000)
);

create index ggircs_additonal_data_report_foreign_key on ggircs.additional_data(report_id);
create index ggircs_additonal_data_activity_foreign_key on ggircs.additional_data(activity_id);

comment on table ggircs.additional_data is 'The table containing the information on additional_data (descriptors)';
comment on column ggircs.additional_data.id is 'The primary key';
comment on column ggircs.additional_data.report_id is 'A foreign key reference to ggircs.report';
comment on column ggircs.additional_data.activity_id is 'A foreign key reference to ggircs.activity';
comment on column ggircs.additional_data.ghgr_import_id is 'A foreign key reference to ggircs.ghgr_import';
comment on column ggircs.additional_data.activity_name is 'The name of the node immediately after ReportData';
comment on column ggircs.additional_data.grandparent is 'The name of the grandparent node';
comment on column ggircs.additional_data.parent is 'The name of the parent node';
comment on column ggircs.additional_data.class is 'The name of the node itself';
comment on column ggircs.additional_data.attribute is 'The name of any attributes on this node';
comment on column ggircs.additional_data.attr_value is 'The value of the attributes on this node concatenated';
comment on column ggircs.additional_data.node_value is 'The text value of the node';

commit;
