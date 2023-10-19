-- STEP 1
CREATE TABLE `employees_undo` (
 `date_of_change` timestamp(2) NOT NULL DEFAULT CURRENT_TIMESTAMP(2)
COMMENT 'Records the date and time when the data was manipulated. This will 
help to keep track of the changes made. The assumption is that no 2 users 
will change the exact same record at the same time (with a precision of a 
hundredth of a second, e.g., 4.26 seconds).',
 `employeeNumber` int NOT NULL,
 `lastName` varchar(50) DEFAULT NULL,
 `firstName` varchar(50) DEFAULT NULL,
 `extension` varchar(10) DEFAULT NULL,
 `email` varchar(100) DEFAULT NULL,
 `officeCode` varchar(10) DEFAULT NULL,
 `reportsTo` int DEFAULT NULL,
 `jobTitle` varchar(50) DEFAULT NULL,
 `change_type` varchar(50) NOT NULL COMMENT 'Records the type of data 
manipulation that was done, for example an insertion, an update, or a 
deletion.',
 PRIMARY KEY (`date_of_change`),
 UNIQUE KEY `date_of_change_UNIQUE` (`date_of_change`)
) ENGINE=InnoDB;

-- STEP 2
CREATE
 
 TRIGGER TRG_BEFORE_UPDATE_ON_employees
 BEFORE UPDATE ON employees FOR EACH ROW
 
 INSERT INTO `employees_undo` SET
 `date_of_change` = CURRENT_TIMESTAMP(2),
 `employeeNumber` = OLD.`employeeNumber` ,
 `lastName` = OLD.`lastName` ,
 `firstName` = OLD.`firstName` ,
 `extension` = OLD.`extension` ,
 `email` = OLD.`email` ,
 `officeCode` = OLD.`officeCode` ,
 `reportsTo` = OLD.`reportsTo` ,
 `jobTitle` = OLD.`jobTitle` ,
 `change_type` = 'An update DML operation was executed';


-- STEP 3
UPDATE `employees` 
SET
`lastName` = 'Muiruri'
WHERE
`employeeNumber` = '1056';

UPDATE `employees` 
SET
`email` = 'mmuiruri@classicmodelcars.com'
WHERE
`employeeNumber` = '1056';




-- STEP 5
CREATE TABLE `customers_data_reminders` (
 `customerNumber` int NOT NULL COMMENT 'Identifies the customer whose data is partly missing',
 `customers_data_reminders_timestamp` timestamp(2) NOT NULL DEFAULT
CURRENT_TIMESTAMP(2) COMMENT 'Records the time when the missing data was detected',
 `customers_data_reminders_message` varchar(100) NOT NULL COMMENT 'Records 
a message that helps the customer service personnel to know what data is missing from the customer\'s record',
 `customers_data_reminders_status` tinyint NOT NULL DEFAULT '0' COMMENT
'Used to record the status of a reminder (0 if it has not yet been addressed and 1 if it has been addressed)',
 PRIMARY KEY
(`customerNumber`,`customers_data_reminders_timestamp`,`customers_data_reminders_message`,`customers_data_reminders_status`),
 CONSTRAINT `FK_1_customers_TO_M_customers_data_reminders` FOREIGN KEY
(`customerNumber`) REFERENCES `customers` (`customerNumber`)
 ON DELETE CASCADE
 ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Used to remind the customer service personnel about a client\'s missing data. This enables them to ask the client to provide the data during the next interaction with the client.';