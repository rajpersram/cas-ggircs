-- Deploy ggircs:table_lfo_facility to pg
-- requires: table_organisation

begin;

create table ggircs.lfo_facility (

    id                        integer primary key,
    report_id                 integer references ggircs.report(id),
    organisation_id           integer references ggircs.organisation(id),
    ghgr_import_id            integer,
    swrs_facility_id          integer,
    facility_name             varchar(1000),
    facility_type             varchar(1000),
    relationship_type         varchar(1000),
    portability_indicator     varchar(1000),
    status                    varchar(1000),
    latitude                  numeric,
    longitude                 numeric
);

create index ggircs_lfo_facility_report_foreign_key on ggircs.lfo_facility(report_id);
create index ggircs_lfo_facility_organisation_foreign_key on ggircs.lfo_facility(organisation_id);

comment on table ggircs.lfo_facility is 'the table housing all report data pertaining to the reporting LFO facility';
comment on column ggircs.lfo_facility.id is 'The primary key';
comment on column ggircs.lfo_facility.report_id is 'A foreign key reference to ggircs.report';
comment on column ggircs.lfo_facility.organisation_id is 'A foreign key reference to ggircs.organisation';
comment on column ggircs.lfo_facility.ghgr_import_id is 'The primary key for the materialized view';
comment on column ggircs.lfo_facility.swrs_facility_id is 'The reporting facility swrs id';
comment on column ggircs.lfo_facility.facility_name is 'The name of the reporting facility';
comment on column ggircs.lfo_facility.facility_type is 'The type of the reporting facility';
comment on column ggircs.lfo_facility.relationship_type is 'The type of relationship';
comment on column ggircs.lfo_facility.portability_indicator is 'The portability indicator';
comment on column ggircs.lfo_facility.status is 'The status of the facility';
comment on column ggircs.lfo_facility.latitude is 'The latitude of the reporting facility';
comment on column ggircs.lfo_facility.longitude is 'The longitude of the reporting facility';

commit;
