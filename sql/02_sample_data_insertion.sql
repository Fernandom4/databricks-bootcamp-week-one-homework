/*

2. Add sample data
Your database must contain:

At least three support tickets

At least two messages for each ticket

At least two different ticket statuses, such as open, in_progress, or resolved
*/

INSERT INTO tickets
VALUES
  (1,'Looker Dashboard Development','open','Fernando Marquez','2026-08-12 09:30:00'),
  (2,'GBQ Access','in_progress','Fernando Marquez','2026-08-11 12:45:00'),
  (3,'dbt Project Maitenance','resolved','Fernando Marquez','2026-08-10 12:00:00')
;

INSERT INTO ticket_messages
VALUES
  (1,1,'Table consolidation on hold','Fernando Marquez','2026-08-12 11:32:45'),
  (2,1,'Waiting for upstream dependencies','Fernando Marquez','2026-08-12 17:32:45'),
  (3,2,'Contacted IT for access','Fernando Marquez','2026-08-11 12:48:00'),
  (4,2,'Waiting for manager approval','Fernando Marquez','2026-08-11 14:04:32'),
  (5,3,'dbt discovery work in progress','Fernando Marquez','2026-08-10 12:01:00'),
  (6,3,'dbt project migrated','Fernando Marquez','2026-08-10 16:13:00')
;
