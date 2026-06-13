--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T4-brm-mods.sql

--Student ID: 35697601
--Student Name: Tuan Ngoc Chu

/*
    -- Submission Declaration - must not be removed - removal will result in no marks being awarded --
    In submitting this SQL script, I confirm that this is my own work without coding assistance from Generative AI
*/

--4(a)
alter table quote add (
    quote_assign           char(1) default 'N' not null,
    quote_notassign_reason varchar2(100),
    constraint quote_assign_ck check ( quote_assign in ( 'Y',
                                                         'N' ) )
);

comment on column quote.quote_assign is
    'Indicates whether the quote has been assigned to a job (Y/N)';

comment on column quote.quote_notassign_reason is
    'Reason for not assigning the quote to a job';


update quote
   set
    quote_assign = 'Y'
 where quote_no in (
    select quote_no
      from job
);

commit;

DESC quote;

select quote_no,
       quote_pref_start_date,
       quote_assign,
       quote_notassign_reason
  from quote
 order by quote_no;

--4(b)

drop table service_task cascade constraints purge;
drop table task_lookup cascade constraints purge;
drop table service cascade constraints purge;

create table service (
    service_no       number(3) not null,
    truck_vin        char(17) not null,
    service_start_dt date not null,
    service_end_dt   date
);

comment on column service.service_no is
    'Service Number';
comment on column service.truck_vin is
    'VIN of the truck being serviced';
comment on column service.service_start_dt is
    'Start date of the service';
comment on column service.service_end_dt is
    'End date of the service';

alter table service add constraint service_pk primary key ( service_no );

alter table service
    add constraint truck_vin_service_fk foreign key ( truck_vin )
        references truck ( truck_vin );

alter table service
    add constraint service_end_dt_ck check ( service_end_dt is null
        or service_end_dt > service_start_dt ); -- Ensure that the service end date is after the service start date, if end date is provided

-- task_lookup for lookup of service tasks
create table task_lookup (
    task_no   number(3) not null,
    task_desc varchar2(50) not null
);

comment on column task_lookup.task_no is
    'Task Number';
comment on column task_lookup.task_desc is
    'Description of the task';

alter table task_lookup add constraint task_lookup_pk primary key ( task_no );

-- service_task to link services to the tasks performed in those services and the mechanics performing those tasks
create table service_task (
    service_no        number(3) not null,
    task_no           number(3) not null,
    emp_no            number(3) not null,
    service_task_note varchar2(200) not null
);

comment on column service_task.service_no is
    'Service Number';
comment on column service_task.task_no is
    'Task Number';
comment on column service_task.emp_no is
    'Employee number of the mechanic performing the task';
comment on column service_task.service_task_note is
    'Notes explaining the service task';

alter table service_task add constraint service_task_pk primary key ( service_no,
                                                                      task_no );
alter table service_task
    add constraint service_task_service_fk foreign key ( service_no )
        references service ( service_no );
alter table service_task
    add constraint service_task_task_fk foreign key ( task_no )
        references task_lookup ( task_no );
alter table service_task
    add constraint service_task_emp_fk foreign key ( emp_no )
        references employee ( emp_no );

DESC service;
DESC task_lookup;
DESC service_task;