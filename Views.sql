# Views is a virtual table stored on the server (exists for all sessions), is used to simplify a long query
drop view if exists viewCustomer;

create view viewCustomer as (select * from customers where addressLine2 is not null);

select * from viewCustomer;