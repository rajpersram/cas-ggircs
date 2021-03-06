-- Deploy ggircs:table_identifier to pg
-- requires: schema_ggircs

begin;

create table swrs.identifier(

    id                              integer primary key,
    ghgr_import_id                  integer,
    report_id                       integer references swrs.report (id),
    facility_id                     integer references swrs.facility(id),
    facility_bcghgid_id             integer references swrs.facility(id),
    swrs_facility_id                integer,
    path_context                    varchar(1000),
    identifier_type                 varchar(1000),
    identifier_value                varchar(1000)
);

create index ggircs_identifier_report_foreign_key on swrs.identifier(report_id);
create index ggircs_identifier_facility_foreign_key on swrs.identifier(facility_id);
create index ggircs_identifier_facility_bcghgid_foreign_key on swrs.identifier(facility_bcghgid_id);

comment on table swrs.identifier is 'The table housing information regarding identifiers';
comment on column swrs.identifier.id is 'The primary key';
comment on column swrs.identifier.ghgr_import_id is 'The foreign key referencing ggrics_swrs.ghgr_import.id';
comment on column swrs.identifier.facility_bcghgid_id is 'A foreign key reference to swrs.facility with correct bcghgid';
comment on column swrs.identifier.facility_id is 'A foreign key reference to swrs.facility';
comment on column swrs.identifier.report_id is 'A foreign key reference to swrs.report';
comment on column swrs.identifier.swrs_facility_id is 'The swrs facility id';
comment on column swrs.identifier.path_context is 'The path context to the Identifier node (from VerifyTombstone or RegistrationDetails)';
comment on column swrs.identifier.identifier_type is 'The type of identifier';
comment on column swrs.identifier.identifier_value is 'The value of the identifier';

commit;
