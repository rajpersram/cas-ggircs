-- Deploy ggircs:table_contact to pg
-- requires: schema_ggircs

begin;

create table ggircs.contact (

    id                        integer primary key,
    report_id                 integer references ggircs.report(id),
    address_id                integer references ggircs.address(id),
    single_facility_id        integer references ggircs.single_facility(id),
    lfo_facility_id           integer references ggircs.lfo_facility(id),
    ghgr_import_id            integer,
    organisation_id           integer,
    path_context              varchar(1000),
    contact_type              varchar(1000),
    given_name                varchar(1000),
    family_name               varchar(1000),
    initials                  varchar(1000),
    telephone_number          varchar(1000),
    extension_number          varchar(1000),
    fax_number                varchar(1000),
    email_address             varchar(1000),
    position                  varchar(1000),
    language_correspondence   varchar(1000)
);

create index ggircs_contact_report_foreign_key on ggircs.contact(report_id);
create index ggircs_contact_address_foreign_key on ggircs.contact(address_id);
create index ggircs_contact_single_facility_foreign_key on ggircs.contact(single_facility_id);
create index ggircs_contact_lfo_facility_foreign_key on ggircs.contact(lfo_facility_id);

comment on table ggircs.contact is 'The table housing contact information';
comment on column ggircs.contact.id is 'The primary key';
comment on column ggircs.contact.report_id is 'A foreign key reference to ggircs.report';
comment on column ggircs.contact.address_id is 'A foreign key reference to ggircs.address';
comment on column ggircs.contact.single_facility_id is 'A foreign key reference to ggircs.single_facility';
comment on column ggircs.contact.lfo_facility_id is 'A foreign key reference to ggircs.lfo_facility';
comment on column ggircs.contact.ghgr_import_id is 'The foreign key reference to ggircs.ghgr_import';
comment on column ggircs.contact.organisation_id is 'A foreign key reference to ggircs.organisation';
comment on column ggircs.contact.path_context is 'The umbrella context from which the contact was pulled from the xml (VerifyTombstone or RegistrationData';
comment on column ggircs.contact.contact_type is 'The type of contact';
comment on column ggircs.contact.given_name is 'The given name of the contact';
comment on column ggircs.contact.family_name is 'The family name of the contact';
comment on column ggircs.contact.initials is 'The initials of the contact';
comment on column ggircs.contact.telephone_number is 'The phone number attached to this contact';
comment on column ggircs.contact.extension_number is 'The extension number attached to this contact';
comment on column ggircs.contact.fax_number is 'The fax number attached to this contact';
comment on column ggircs.contact.email_address is 'The email address attached to this contact';
comment on column ggircs.contact.position is 'The position of this contact';
comment on column ggircs.contact.language_correspondence is 'The language of correspondence for thsi contact';

commit;
