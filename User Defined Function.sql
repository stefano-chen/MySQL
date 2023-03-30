# A UDF(User Defined Function) must always return only one value
# A UDF parameters are in only read mode (you cannot write on parameters)
# A UDF can only use the SELECT statement
# A UDF can be called inside a select (e.g. concat(), count(), sum(), ...)
# A table created (returned) from a UDF can be use as a normal table
# A UDF can be DETERMINISTIC or NOT DETERMINISTIC
# DETERMINISTIC means that if I use the sames parameters value and i didn't change my database data
# then the output of my UDF is still the same (e.g. concat())
# NOT DETERMINISTIC means that if I use the sames parameters value and i didn't change my database data
# then the output of my UDF is changed (e.g. now(), rand())

# UDF to calculate the double of a number in input
DROP FUNCTION udf_double;

delimiter $$
CREATE FUNCTION udf_double (number double)
RETURNS DOUBLE DETERMINISTIC
BEGIN
    RETURN number * 2;
END $$
delimiter ;

# Show the product Name and the price
select productName, MSRP from products;

# Lets use udf_double to double the price
select productName, udf_double(MSRP) from products;


# Create a UDF to return the customer level
delimiter $$
CREATE FUNCTION udf_customerLevel(p_creditLimit double)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
    DECLARE lvl varchar(10);
    IF p_creditLimit > 50000 THEN
        SET lvl = 'PLATINUM';
    ELSEIF p_creditLimit >= 10000 THEN
        SET lvl = 'GOLD';
    ELSE
        SET lvl = 'SILVER';
    END IF;
    RETURN (lvl);
END $$
delimiter ;

# Shows the customerName and the respective credit
select customerName, creditLimit from customers;

# Shows the customerName, the respective credit and the level
select customerName, creditLimit, udf_customerLevel(creditLimit) as level from customers;


# A UDF to return the number of orders by a cutomer number in input
delimiter $$
CREATE FUNCTION udf_contOrders(clientID int)
RETURNS INT(11) NOT DETERMINISTIC
BEGIN
    DECLARE cont INT;
    SELECT count(*) INTO cont FROM orders
    WHERE customerNumber = clientID;
    RETURN cont;
END $$
delimiter ;

select customerNumber, customerName from customers;

select customerNumber, customerName, udf_contOrders(customerNumber) from customers;