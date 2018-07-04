# Tasks

## Why?

There are activities that either end-users or database owners do not want to run interactively, for example

- should be out of work
- there is no way for a client to keep connect so long 
- should run only in the dawn after the last day of the month, when the last data files processed from all the sites and the result of query must be in the morning and have to send in e-mail to members of sales dept.
- There is no need for a client because it is just a background process
- etc.

but there is no general solution to this problem (because it is not a simple JOB).
Instead of specific solutions, it was timely to create this generic one.


## Features 

We can
1. create categories and order tasks to them
2.	monitorize the status of tasks
3.	add parameters
4.	define conditions to start
5.	define time threshold
6.	get back the result
7.	kill the running task
8.	clone a task

## How?

There are some tables what we can read via views and write by procedures and functions. There is a package what contains the all necessary functions, procedures to manage tasks.

The scripts of the tasks will run by SQLPLUS in separated (parallel) command windows on the database server.  
The output of the scripts will direct into a spool file and will be uploaded into a table after the run. 

The simpliest way, run an SQL command asap:

    begin
        PKG_TASK.P_NEW_TASK( 'select * from TASK_STATUSES;');
        PKG_TASK.P_START_TASK;
    end;

The result:

    select * from TASK_OUTPUT_LINES_VW where TASK_ID = 3 order by LINE_NUMBER

    ID  TASK_ID  LINE_NUMBER    VALUE

    12    3        1            EDITING   Under editing
    13    3        2            TOSTART   Waiting to start
    14    3        3            RUNNING   Started and running
    15    3        4            FINISHING Uploading the result file
    16    3        5            FINISHED  Running has finished
    17    3        6            TOKILL    Waiting to kill
    18    3        7            KILLED    Killed
    19    3        8            DELETED   Deleted by the user
    20    3        9            FAILED    Failed (Finished with error)
    21    3       10            TIMEDOUT  Timed out

