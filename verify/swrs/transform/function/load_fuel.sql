-- Verify ggircs:function_load_fuel on pg

begin;

select pg_get_functiondef('swrs_transform.load_fuel()'::regprocedure);

rollback;
