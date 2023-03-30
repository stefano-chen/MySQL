# A Cursor allows me to use rows of a table created by a SELECT statement

use classicmodels;

delimiter $$
CREATE PROCEDURE sp_buildEmailList (INOUT email_list varchar(4000))
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE v_email varchar(100) DEFAULT '';

    # Cursor Declaration
    DECLARE email_cursor CURSOR FOR SELECT email FROM employees;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    # Use the Cursor
    OPEN email_cursor;

    WHILE (finished = 0) DO
        # assign to v_email the value of the current row pointed by the cursor
        FETCH email_cursor INTO v_email;
        IF finished = 0 THEN
            SET email_list = CONCAT(v_email,';',email_list);
        END IF;
    END WHILE;

    # close the cursor
    CLOSE email_cursor;
END $$
delimiter ;

set @email_list = '';

call sp_buildEmailList(@email_list);

select @email_list;