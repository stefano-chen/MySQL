# Prepare statement create a precompiled query that exist only in this session
PREPARE getCustomersNames from 'SELECT customerName, city from customers where city = ?';

set @customerCity = 'auckland';

execute getCustomersNames using @customerCity;