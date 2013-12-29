---
--- recurring_tasks
---
CREATE SEQUENCE recurring_tasks_id_seq;
CREATE TABLE recurring_tasks (
    id               integer  DEFAULT nextval('recurring_tasks_id_seq') PRIMARY KEY,
    description      text                                               NOT NULL UNIQUE,
    frequency        integer  DEFAULT 1                                 NOT NULL,
    enabled          boolean  DEFAULT true                              NOT NULL,
    status           text     DEFAULT 'todo'::text                      NOT NULL,
    started_at_week  integer                                            NOT NULL,
    started_at_year  integer                                            NOT NULL
);
ALTER SEQUENCE recurring_tasks_id_seq OWNED BY recurring_tasks.id;

---
--- unique_tasks
---
CREATE SEQUENCE unique_tasks_id_seq;
CREATE TABLE unique_tasks (
    id          integer DEFAULT nextval('unique_tasks_id_seq') PRIMARY KEY,
    description text                                           NOT NULL UNIQUE,
    status      text                                           NOT NULL
);
ALTER SEQUENCE unique_tasks_id_seq OWNED BY unique_tasks.id;

---
--- sprints
---
CREATE SEQUENCE sprints_id_seq;
CREATE TABLE sprints (
    year integer NOT NULL,
    week integer NOT NULL
);
CREATE INDEX sprints_week_index ON sprints USING btree (week);
CREATE INDEX sprints_year_index ON sprints USING btree (year);
