-- Verify ggircs:function_load_permit on pg

begin;

select pg_get_functiondef('ggircs_swrs_transform.load_permit()'::regprocedure);

rollback;
