-- Clear existing alarm events for this device (keep the original deviceMoving event)
DELETE FROM tc_events WHERE deviceid = 33 AND type LIKE 'alarm%';

-- Insert proper events for SWEEPER001 device
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2000, 'deviceOnline', 1749927417000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2001, 'ignitionOn', 1749927553000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2002, 'deviceMoving', 1749927555000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2003, 'ignitionOff', 1749927756000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2004, 'deviceStopped', 1749927761000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2005, 'ignitionOn', 1749927884000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2006, 'deviceMoving', 1749927888000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2007, 'ignitionOff', 1749928214000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2008, 'deviceStopped', 1749928219000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2009, 'deviceUnknown', 1749928900000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2010, 'deviceOnline', 1749929248000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2011, 'deviceUnknown', 1749929854000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2012, 'deviceOnline', 1749930076000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2013, 'deviceUnknown', 1749930893000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2014, 'deviceOnline', 1749931289000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2015, 'deviceUnknown', 1749932501000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2016, 'deviceOnline', 1749932927000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2017, 'deviceUnknown', 1749933527000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2018, 'deviceOnline', 1749933750000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2019, 'deviceUnknown', 1749935086000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2020, 'deviceOnline', 1749935137000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2021, 'deviceUnknown', 1749938725000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2022, 'deviceOnline', 1749939279000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2023, 'deviceUnknown', 1749940240000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2024, 'deviceOnline', 1749940702000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2025, 'deviceUnknown', 1749941302000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2026, 'deviceOnline', 1749941566000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2027, 'ignitionOn', 1749944352000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2028, 'deviceMoving', 1749944355000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2029, 'ignitionOff', 1749944698000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2030, 'deviceStopped', 1749944704000, 33, NULL, NULL, '{}');
INSERT INTO tc_events (id, type, eventtime, deviceid, positionid, geofenceid, attributes) 
VALUES (2031, 'deviceUnknown', 1749945863000, 33, NULL, NULL, '{}');
