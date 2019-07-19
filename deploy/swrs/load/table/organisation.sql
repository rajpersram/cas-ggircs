-- Deploy ggircs:table_organisation to pg
-- requires: schema_ggircs

begin;

create table ggircs_swrs_load.organisation
(
    id                        integer primary key,
    report_id                 integer references ggircs_swrs_load.report(id),
    ghgr_import_id            integer,
    swrs_organisation_id      integer,
    business_legal_name       varchar(1000),
    english_trade_name        varchar(1000),
    french_trade_name         varchar(1000),
    cra_business_number       varchar(1000),
    duns                      varchar(1000),
    website                   varchar(1000)
);

create index ggircs_organisaion_report_foreign_key on ggircs_swrs_load.organisation(report_id);

comment on table ggircs_swrs_load.organisation is 'the table housing all report data pertaining to the reporting organisation';
comment on column ggircs_swrs_load.organisation.id is 'The primary key';
comment on column ggircs_swrs_load.organisation.report_id is 'A foreign key reference to ggircs_swrs_load.report';
comment on column ggircs_swrs_load.organisation.ghgr_import_id is 'The internal reference to the file imported from ghgr';
comment on column ggircs_swrs_load.organisation.swrs_organisation_id is 'The reporting organisation swrs id';
comment on column ggircs_swrs_load.organisation.business_legal_name is 'The legal business name of the reporting organisation';
comment on column ggircs_swrs_load.organisation.english_trade_name is 'The trade name in english';
comment on column ggircs_swrs_load.organisation.french_trade_name is 'The trade name in french';
comment on column ggircs_swrs_load.organisation.cra_business_number is 'The organisation business number according to cra';
comment on column ggircs_swrs_load.organisation.duns is 'The organisation duns number';
comment on column ggircs_swrs_load.organisation.website is 'The organisation website address';

commit;
