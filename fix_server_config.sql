-- Fix for NullPointerException: Insert server configuration record
-- This script creates the missing server configuration in the tc_servers table

INSERT INTO tc_servers (id, registration, readonly, deviceReadonly, limitCommands, disableReports, fixedEmail, forceSettings, coordinateFormat, attributes) 
VALUES (
    1,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    'dd',
    '{}'
) ON DUPLICATE KEY UPDATE id = id;

-- Verify the record was created
SELECT * FROM tc_servers;
