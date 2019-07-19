set client_encoding = 'utf-8';
set client_min_messages = warning;
create extension if not exists pgtap;
reset client_min_messages;

begin;
select * from no_plan();

insert into ggircs_swrs_extract.ghgr_import (xml_file) values ($$
<ReportData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <RegistrationData>
    <Organisation>
      <Details>
        <BusinessLegalName>Bart Simpson</BusinessLegalName>
        <EnglishTradeName>Bart Simpson</EnglishTradeName>
        <FrenchTradeName/>
        <CRABusinessNumber>12345</CRABusinessNumber>
        <DUNSNumber>0</DUNSNumber>
        <WebSite>www.nhl.com</WebSite>
      </Details>
      <Address>
        <PhysicalAddress>
          <StreetNumber>300</StreetNumber>
          <StreetNumberSuffix/>
          <StreetName>A Drive</StreetName>
          <StreetType>Drive</StreetType>
          <StreetDirection>North</StreetDirection>
          <Municipality>Funky Town</Municipality>
          <ProvTerrState>British Columbia</ProvTerrState>
          <PostalCodeZipCode>H0H0H0</PostalCodeZipCode>
          <Country>Canada</Country>
        </PhysicalAddress>
        <MailingAddress>
          <DeliveryMode>Post Office Box</DeliveryMode>
          <POBoxNumber>1</POBoxNumber>
          <StreetNumber>300</StreetNumber>
          <StreetNumberSuffix/>
          <StreetName>A Drive</StreetName>
          <StreetType>Drive</StreetType>
          <Municipality>Funky Town</Municipality>
          <ProvTerrState>British Columbia</ProvTerrState>
          <PostalCodeZipCode>H0H0H0</PostalCodeZipCode>
          <Country>Canada</Country>
          <AdditionalInformation/>
        </MailingAddress>
      </Address>
    </Organisation>
  </RegistrationData>
  <ReportDetails>
    <ReportID>1234</ReportID>
    <ReportType>R1</ReportType>
    <FacilityId>0000</FacilityId>
    <FacilityType>EIO</FacilityType>
    <OrganisationId>0000</OrganisationId>
    <ReportingPeriodDuration>2025</ReportingPeriodDuration>
    <ReportStatus>
      <Status>Submitted</Status>
      <SubmissionDate>2013-03-27T19:25:55.32</SubmissionDate>
      <LastModifiedBy>Buddy</LastModifiedBy>
    </ReportStatus>
  </ReportDetails>
  <OperationalWorkerReport/>
  <VerifyTombstone>
    <Organisation>
      <Details>
        <BusinessLegalName>Bart Simpson</BusinessLegalName>
        <EnglishTradeName>Bart Simpson</EnglishTradeName>
        <CRABusinessNumber>123456778</CRABusinessNumber>
        <DUNSNumber>00-000-0000</DUNSNumber>
      </Details>
      <Address>
        <MailingAddress>
          <POBoxNumber>0000</POBoxNumber>
          <StreetNumber>00</StreetNumber>
          <StreetName>A Drive</StreetName>
          <StreetType>Drive</StreetType>
          <Municipality>Funky Town</Municipality>
          <ProvTerrState>British Columbia</ProvTerrState>
          <PostalCodeZipCode>H0H0H0</PostalCodeZipCode>
          <Country>Canada</Country>
        </MailingAddress>
      </Address>
    </Organisation>
  </VerifyTombstone>
</ReportData>
$$);

refresh materialized view ggircs_swrs_transform.report with data;
refresh materialized view ggircs_swrs_transform.organisation with data;
refresh materialized view ggircs_swrs_transform.final_report with data;
select ggircs_swrs_transform.load_report();
select ggircs_swrs_transform.load_organisation();

-- Table ggircs_swrs_load.organisation exists
select has_table('ggircs'::name, 'organisation'::name);

-- Organisation has pk
select has_pk('ggircs', 'organisation', 'ggircs_organisation has primary key');

-- Organisation has fk
select has_fk('ggircs', 'organisation', 'ggircs_organisation has foreign key constraint(s)');

-- Organisation has data
select isnt_empty('select * from ggircs_swrs_load.organisation', 'there is data in ggircs_swrs_load.organisation');

-- FKey tests
-- Organisation -> Report
select set_eq(

    $$
    select report.ghgr_import_id from ggircs_swrs_load.organisation
    join ggircs_swrs_load.report
    on organisation.report_id = report.id
    $$,

    'select ghgr_import_id from ggircs_swrs_load.report',

    'Foreign key report_id in ggircs_swrs_load.organisation references ggircs_swrs_load.report'
);

-- Data in ggircs_swrs_transform.organisation === data in ggircs_swrs_load.organisation
select set_eq($$
                  select
                      ghgr_import_id,
                      swrs_organisation_id,
                      business_legal_name,
                      english_trade_name,
                      french_trade_name,
                      cra_business_number,
                      duns,
                      website
                  from ggircs_swrs_transform.organisation
                  $$,

                 $$
                 select
                      ghgr_import_id,
                      swrs_organisation_id,
                      business_legal_name,
                      english_trade_name,
                      french_trade_name,
                      cra_business_number,
                      duns,
                      website
                  from ggircs_swrs_load.organisation
                  $$,

    'data in ggircs_swrs_transform.organisation === ggircs_swrs_load.organisation');

select * from finish();
rollback;
