# A Trigger is an automatic potion of code that is execute when an event happened on a certain table
# I cannot use an UDF,SP or PREPARED statement inside my Trigger
# In MySQL a Trigger is applied in "ROW LEVEL"
# A Trigger can be execute BEFORE or AFTER a determinate event
# TO access the modified data you need to use OLD(contains the old values) and NEW(contains the new values) keywords

# A Trigger that logs the changes to the employees table
CREATE TABLE employees_audit (
    id int(11) NOT NULL AUTO_INCREMENT,
    employeeNumber int(11) NOT NULL,
    lastname varchar(50) NOT NULL,
    changedon datetime DEFAULT NULL,
    changedBy varchar(50) DEFAULT NULL,
    action varchar(50) DEFAULT NULL,
    PRIMARY KEY (id)
);

DELIMITER $$
CREATE TRIGGER trg_beforeUpdateEmployees
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
    employeeNumber = OLD.employeeNumber,
    lastname = OLD.lastname,
    changedon = NOW(),
    changedby = user();
END$$
DELIMITER ;

select * from employees_audit;

select * from employees;

UPDATE employees
SET lastName = 'Phan'
WHERE employeeNumber = 1056;

select * from employees;

select * from employees_audit;


# A Trigger that generate a SQLERROR if you are try to increase the creditLimit of a customer
delimiter $$
CREATE TRIGGER trg_beforeUpdateCustomer
BEFORE UPDATE ON customers
FOR EACH ROW
BEGIN
    IF NEW.creditLimit > OLD.creditLimit THEN
        SIGNAL sqlstate '45001' SET message_text = 'Fuck You!!!';
    END IF;
END $$
delimiter ;

update customers set creditLimit = 999999.99 where customerNumber = 103;
