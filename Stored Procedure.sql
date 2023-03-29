# Stored Procedure to view all employees with a Sales Rep job
DROP PROCEDURE IF EXISTS getSalesRep;

DELIMITER $$
CREATE PROCEDURE getSalesRep()
BEGIN
   SELECT * FROM employees WHERE jobTitle = 'Sales Rep';
END $$
DELIMITER ;

SHOW CREATE PROCEDURE getSalesRep;

CALL getSalesRep();


# Stored Procedure with parameters to view all employees with a determinate job
DROP PROCEDURE IF EXISTS getEmployees;

DELIMITER $$
CREATE PROCEDURE getEmployees(job VARCHAR(50))
BEGIN
    select concat(lastName, ' ', firstName) as employeer from employees where jobTitle = job;
end $$
delimiter ;

call getEmployees('principal');

call getEmployees('sales rep');


# Stored Procedure to increment a variable
DROP PROCEDURE IF EXISTS increase;

set @contatore = 0;
select @contatore;

delimiter $$
CREATE PROCEDURE increase(INOUT cont INT)
begin
    set cont = cont + 1;
end $$
delimiter ;

call increase(@contatore);

select @contatore;

# Store Procedure to double the value of a variable
drop procedure if exists twoTimes;

delimiter $$
create procedure twoTimes(INOUT val INT)
begin
    set val = val * 2;
end $$
delimiter ;

select @contatore;

call twoTimes(@contatore);

select @contatore;

# Stored Procedure to return the number of object ordered by a order number in input
drop procedure if exists getNumberOfObject;

set @number = 0;

select @number;

delimiter $$
create procedure getNumberOfObject(in oNumber int, out numberObj int)
begin
    set numberObj = (select sum(quantityOrdered) from orderdetails where orderNumber = oNumber);
end $$
delimiter ;

call getNumberOfObject(10100, @number);

select @number;

# Stored Procedure to return the number of orders in a determinate state in input
drop procedure if exists getNumberOfStatus;

set @numberOfStatus = 0;

select @numberOfStatus;

delimiter $$
create procedure getNumberOfStatus(in typestatus varchar(15), out result int)
begin
    select count(status) into result from orders where status = typestatus;
end $$
delimiter ;

call getNumberOfStatus('Shipped', @numberOfStatus);

select @numberOfStatus;

# Stored Procedure to return the number of orders shipped, cancelled, resolved and disputed of a client code in input
drop procedure if exists getNUmberOfAllStatus;

set @shipped = 0;
set @cancelled = 0;
set @resolved = 0;
set @disputed = 0;

select @shipped,@cancelled,@resolved,@disputed;

delimiter $$
create procedure getNumberOfAllStatus(
            in cNumber int, out shipped int, out cancelled int, out resolved int, out disputed int)
begin
    select count(status) into shipped from orders where customerNumber = cNumber and status = 'shipped';
    select count(status) into cancelled from orders where customerNumber = cNumber and status = 'cancelled';
    select count(status) into resolved from orders where customerNumber = cNumber and status = 'resolved';
    select count(status) into disputed from orders where customerNumber = cNumber and status = 'disputed';
end $$
delimiter ;

call getNumberOfAllStatus(141,@shipped,@cancelled,@resolved,@disputed);

select @shipped,@cancelled,@resolved,@disputed;

# Stored Procedure to return a string (PLATINUM, GOLD, SILVER) based on the credit limit of a client code in input
drop procedure if exists getCustomerLevel;

set @level = '';

select @level;

delimiter $$
create procedure getCustomerLevel(in clientCode int, out clientLevel char(8))
begin
    declare credito decimal(10,2);
    set credito = (select creditLimit from customers where customerNumber = clientCode);
    if credito > 50000.00 then
        set clientLevel = 'PLATINUM';
    elseif credito between 10000.00 and 50000.00 then
        set clientLevel = 'GOLD';
    else
        set clientLevel = 'SILVER';
    end if;
end $$
delimiter ;

call getCustomerLevel(103,@level);

select @level;

# Stored Procedure to generate an error if the client does not exist otherwise return the number of orders by the client
drop procedure if exists getNumberOfOrders;

set @numberOfOrders = 0;

DELIMITER $$
create procedure getNumberOfOrders(in clientCode int, inout n int)
begin
    select count(*) into n from customers where customerNumber = clientCode;
    if n = 0 then
        signal sqlstate '45000' set message_text = 'Error'; # custom error code must be start from 45000
    end if;
    select count(orderNumber) into n from orders where customerNumber = clientCode;
end $$
DELIMITER ;

call getNumberOfOrders(141,@numberOfOrders);

select @numberOfOrders;

# Create a Handler (Try catch) to control the error code 45000
drop procedure if exists handleGetNumberOfOrders;

delimiter $$
create procedure handleGetNumberOfOrders()
begin
    declare n int default 0;
    # the handle declaration must be the last declaration statement
    declare exit handler for sqlstate '45000' #also sqlexception to catch all error code greater than 30000
        begin
            select 'I catch the error 45000' as ErrorMessage;
        end;
    call getNumberOfOrders(100,n);
    select n as NumberOfOrders;
end $$
delimiter ;

call handleGetNumberOfOrders();