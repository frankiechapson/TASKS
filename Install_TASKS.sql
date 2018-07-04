Prompt *****************************************************************
Prompt **             I N S T A L L I N G   T A S K S                 **
Prompt *****************************************************************


/*************************************/
Prompt   D I R E C T O R Y         
/*************************************/

CREATE OR REPLACE DIRECTORY TASKS_FILES AS 'D:\TASK_DIR';  /* <<<===   Change this */

GRANT EXECUTE, READ, WRITE ON DIRECTORY TASKS_FILES TO PUBLIC;



/*************************************/
Prompt   S E Q U E N C E S
/*************************************/

Create Sequence SEQ_TASKS_ID
    Increment by 1
    Minvalue 1
    Maxvalue 9999999999
    Start With 1
    Cycle
    NoCache;

Create Sequence SEQ_TASK_PARAMETERS_ID
    Increment by 1
    Minvalue 1
    Maxvalue 9999999999
    Start With 1
    Cycle
    NoCache;

Create Sequence SEQ_TASK_OUTPUT_LINES_ID
    Increment by 1
    Minvalue 1
    Maxvalue 9999999999
    Start With 1
    Cycle
    NoCache;



/*************************************/
Prompt   T A B L E S
/*************************************/


/*============================================================================================*/
CREATE TABLE TASK_CATEGORIES (    
/*============================================================================================*/
  CODE                  VARCHAR2( 10)      NOT NULL,
  NAME                  VARCHAR2(200)      NOT NULL
  );

COMMENT ON TABLE  TASK_CATEGORIES               IS 'To separate the tasks';
COMMENT ON COLUMN TASK_CATEGORIES.CODE          IS 'Short name to find easier';
COMMENT ON COLUMN TASK_CATEGORIES.NAME          IS 'Description';

ALTER TABLE TASK_CATEGORIES ADD CONSTRAINT TASK_CATEGORIES_PK PRIMARY KEY (CODE);


/*============================================================================================*/
CREATE TABLE TASK_STATUSES (    
/*============================================================================================*/
  CODE                  VARCHAR2( 10)      NOT NULL,
  NAME                  VARCHAR2(200)      NOT NULL
  );

COMMENT ON TABLE  TASK_STATUSES               IS 'The statuses of tasks';
COMMENT ON COLUMN TASK_STATUSES.CODE          IS 'Short name to find easier';
COMMENT ON COLUMN TASK_STATUSES.NAME          IS 'Description';

ALTER TABLE TASK_STATUSES ADD CONSTRAINT TASK_STATUSES_PK PRIMARY KEY (CODE);

INSERT INTO TASK_STATUSES VALUES ('EDITING'    ,'Under editing'                 ); 
INSERT INTO TASK_STATUSES VALUES ('TOSTART'    ,'Waiting to start'              ); 
INSERT INTO TASK_STATUSES VALUES ('RUNNING'    ,'Started and running '          ); 
INSERT INTO TASK_STATUSES VALUES ('FINISHING'  ,'Uploading the result file'     ); 
INSERT INTO TASK_STATUSES VALUES ('FINISHED'   ,'Running has finished'          ); 
INSERT INTO TASK_STATUSES VALUES ('TOKILL'     ,'Waiting to kill'               ); 
INSERT INTO TASK_STATUSES VALUES ('KILLED'     ,'Killed'                        ); 
INSERT INTO TASK_STATUSES VALUES ('DELETED'    ,'Deleted by the user'           ); 
INSERT INTO TASK_STATUSES VALUES ('FAILED'     ,'Failed (Finished with error)'  ); 
INSERT INTO TASK_STATUSES VALUES ('TIMEDOUT'   ,'Timed out'                     ); 

COMMIT;



/*============================================================================================*/
CREATE TABLE TASKS (    
/*============================================================================================*/
  ID                       NUMBER  (  10)        NOT NULL,
  CATEGORY_CODE            VARCHAR2(  10)        NULL,
  STATUS_CODE              VARCHAR2(  10)        NOT NULL,
  NAME                     VARCHAR2( 500)        NULL,
  REMARK                   VARCHAR2(2000)        NULL,
  CREATED                  DATE                  NULL,
  CREATED_BY               VARCHAR2(  50)        NULL,
  TIMED                    DATE                  NULL,
  TIMEOUT                  DATE                  NULL,
  STARTED                  DATE                  NULL,
  FINISHED                 DATE                  NULL,
  DELETED                  DATE                  NULL,
  DELETED_BY               VARCHAR2(  50)        NULL,
  KILLED                   DATE                  NULL,
  KILLED_BY                VARCHAR2(  50)        NULL,
  EXPIRE                   DATE                  NULL,
  SID                      NUMBER  (  20)        NULL,
  SERIAL                   NUMBER  (  20)        NULL,
  CONDITION_SELECT         VARCHAR2(4000)        NULL,
  SCRIPT_TO_RUN            VARCHAR2(4000)        NULL
  );

COMMENT ON TABLE  TASKS                      IS 'The Tasks';

COMMENT ON COLUMN TASKS.ID                   IS 'The Primary Key';
COMMENT ON COLUMN TASKS.CATEGORY_CODE        IS 'The category to separate the tasks';
COMMENT ON COLUMN TASKS.STATUS_CODE          IS 'The status of the Task';
COMMENT ON COLUMN TASKS.NAME                 IS 'Given by the user';
COMMENT ON COLUMN TASKS.REMARK               IS 'Given by the user';

COMMENT ON COLUMN TASKS.CREATED              IS 'Time of inserting';
COMMENT ON COLUMN TASKS.CREATED_BY           IS 'Inserted by OS user name';
COMMENT ON COLUMN TASKS.TIMED                IS 'Planned time to start. Set up by User';
COMMENT ON COLUMN TASKS.TIMEOUT              IS 'After this time, if the task has not finished yet, it will be timedout or killed';
COMMENT ON COLUMN TASKS.STARTED              IS 'The real starting time of the Task';
COMMENT ON COLUMN TASKS.FINISHED             IS 'The end time of the Task';
COMMENT ON COLUMN TASKS.DELETED              IS 'The time when the status has set to DELETED';
COMMENT ON COLUMN TASKS.DELETED_BY           IS 'Teh task was deleted by this (OS) user';
COMMENT ON COLUMN TASKS.KILLED               IS 'The time when the status has set to TOKILL';
COMMENT ON COLUMN TASKS.KILLED_BY            IS 'The time when the status has set to TOKILL';
COMMENT ON COLUMN TASKS.EXPIRE               IS 'After this date the all data of TASK will be deleted! NULL means never!';
COMMENT ON COLUMN TASKS.CONDITION_SELECT     IS 'See the documentation!';
COMMENT ON COLUMN TASKS.SCRIPT_TO_RUN        IS 'See the documentation!';


ALTER TABLE TASKS ADD CONSTRAINT TASKS_PK PRIMARY KEY (ID) ;

ALTER TABLE TASKS ADD CONSTRAINT TASKS_CATEGORY_CODE_FK  FOREIGN KEY (CATEGORY_CODE) REFERENCES TASK_CATEGORIES (CODE);
ALTER TABLE TASKS ADD CONSTRAINT TASKS_STATUS_CODE_FK    FOREIGN KEY (STATUS_CODE)   REFERENCES TASK_STATUSES   (CODE);

CREATE INDEX IDX_TASKS_CATEGORY_CODE         ON TASKS ( CATEGORY_CODE   );
CREATE INDEX IDX_TASKS_STATUS_CODE           ON TASKS ( STATUS_CODE     );

CREATE INDEX IDX_TASKS_TIMED                 ON TASKS ( TIMED    );
CREATE INDEX IDX_TASKS_STARTED               ON TASKS ( STARTED  );
CREATE INDEX IDX_TASKS_FINISHED              ON TASKS ( FINISHED );
CREATE INDEX IDX_TASKS_EXPIRE                ON TASKS ( EXPIRE   );


/*============================================================================================*/
CREATE TABLE TASK_PARAMETERS (    
/*============================================================================================*/
  ID                       NUMBER  (  10)       NOT NULL,
  TASK_ID                  NUMBER  (  10)       NOT NULL,
  NAME                     VARCHAR2(  50)       NULL,
  VALUE                    VARCHAR2(4000)       NULL
  );

COMMENT ON TABLE  TASK_PARAMETERS            IS 'The Parameters of the Tasks';

COMMENT ON COLUMN TASK_PARAMETERS.ID         IS 'The Primary Key';
COMMENT ON COLUMN TASK_PARAMETERS.TASK_ID    IS 'The Task ID';
COMMENT ON COLUMN TASK_PARAMETERS.NAME       IS 'The parameter name';
COMMENT ON COLUMN TASK_PARAMETERS.VALUE      IS 'The parameter value';

ALTER TABLE TASK_PARAMETERS ADD CONSTRAINT TASK_PARAMETERS_PK PRIMARY KEY (ID);

ALTER TABLE TASK_PARAMETERS ADD CONSTRAINT TASK_PARAMETERS_TASK_ID_FK     FOREIGN KEY (TASK_ID)    REFERENCES TASKS ( ID );

CREATE INDEX IDX_TASK_PARAMETERS_TASK_ID        ON TASK_PARAMETERS ( TASK_ID );
CREATE INDEX IDX_TASK_PARAMETERS_NAME           ON TASK_PARAMETERS ( NAME    );



/*============================================================================================*/
CREATE TABLE TASK_OUTPUT_LINES (    
/*============================================================================================*/
  ID                       NUMBER  (  10)       NOT NULL,
  TASK_ID                  NUMBER  (  10)       NOT NULL,
  LINE_NUMBER              NUMBER  (  10)       NULL,
  VALUE                    VARCHAR2(4000)       NULL
  );

COMMENT ON TABLE  TASK_OUTPUT_LINES          IS 'The reults of the Tasks';

COMMENT ON COLUMN TASK_OUTPUT_LINES.ID          IS 'The Primary Key';
COMMENT ON COLUMN TASK_OUTPUT_LINES.TASK_ID     IS 'The Task ID';
COMMENT ON COLUMN TASK_OUTPUT_LINES.LINE_NUMBER IS 'The line number 1 to n';
COMMENT ON COLUMN TASK_OUTPUT_LINES.VALUE       IS 'The result value';

ALTER TABLE TASK_OUTPUT_LINES ADD CONSTRAINT TASK_OUTPUT_LINES_PK PRIMARY KEY (ID);

ALTER TABLE TASK_OUTPUT_LINES ADD CONSTRAINT TASK_OUTPUT_LINES_TASK_ID_FK     FOREIGN KEY (TASK_ID)    REFERENCES TASKS ( ID );

CREATE INDEX IDX_TASK_OUTPUT_LINES_TASK_ID       ON TASK_OUTPUT_LINES ( TASK_ID     );
CREATE INDEX IDX_TASK_OUTPUT_LINES_LINE_NUM      ON TASK_OUTPUT_LINES ( LINE_NUMBER );


/*************************************/
Prompt   V I E W S 
/*************************************/

/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_CATEGORIES_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASK_CATEGORIES;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_STATUSES_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASK_STATUSES;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASKS_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS;


/*============================================================================================*/
CREATE OR REPLACE VIEW MY_TASKS_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE CREATED_BY =  NVL( UPPER( SUBSTR( SYS_CONTEXT( 'USERENV', 'OS_USER' ), 1,50) ), 'SYSTEM' );


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_PARAMETERS_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASK_PARAMETERS;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_OUTPUT_LINES_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASK_OUTPUT_LINES;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_EDITING_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'EDITING';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_TOSTART_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'TOSTART';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_RUNNING_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'RUNNING';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_FINISHING_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'FINISHING';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_FINISHED_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'FINISHED';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_TOKILL_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'TOKILL';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_KILLED_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'KILLED';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_DELETED_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'DELETED';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_TIMEDOUT_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'TIMEDOUT';


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_FAILED_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE    =  'FAILED';



/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_NEED_TO_START_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASK_TOSTART_VW
   WHERE TIMED                    <=  SYSDATE
     AND nvl(TIMEOUT, SYSDATE+1)  >  SYSDATE;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_NEED_TO_TIMEOUT_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE in ('EDITING', 'TOSTART')
     AND nvl(TIMEOUT, SYSDATE+1)  <  SYSDATE;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_NEED_TO_KILL_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE STATUS_CODE in ('RUNNING', 'FINISHING') 
     AND SID    is not null
     AND SERIAL is not null
     AND nvl(TIMEOUT, SYSDATE+1) < SYSDATE;


/*============================================================================================*/
CREATE OR REPLACE VIEW TASK_NEED_TO_REMOVE_VW AS
/*============================================================================================*/
  SELECT *
    FROM TASKS
   WHERE nvl(EXPIRE, SYSDATE+1) < SYSDATE;




/*************************************/
Prompt   P A C K A G E   H E A D E R
/*************************************/

/*============================================================================================*/
CREATE OR REPLACE PACKAGE PKG_TASK IS
/*============================================================================================*/

    G_TASK_ID                number(10);
    G_OUTPUT_LINE_NUMBER     number(10) := 0;

  ------------------------------------------------------------------------------------
    -- TASK
    function   F_NEW_TASK( I_SCRIPT_TO_RUN     in varchar2,
                           I_CATEGORY_CODE     in varchar2 default null,
                           I_NAME              in varchar2 default null,                           
                           I_CONDITION_SELECT  in varchar2 default null,
                           I_TIMEOUT           in date     default null,
                           I_EXPIRE            in date     default null,
                           I_REMARK            in varchar2 default null
                         ) return number;

  ------------------------------------------------------------------------------------
    procedure  P_NEW_TASK( I_SCRIPT_TO_RUN     in varchar2,
                           I_CATEGORY_CODE     in varchar2 default null,
                           I_NAME              in varchar2 default null,                           
                           I_CONDITION_SELECT  in varchar2 default null,
                           I_TIMEOUT           in date     default null,
                           I_EXPIRE            in date     default null,
                           I_REMARK            in varchar2 default null
                         );

  ------------------------------------------------------------------------------------
    procedure P_START_TASK ( I_TASK_ID in number, I_TIMED in date default sysdate);
    procedure P_START_TASK (                      I_TIMED in date default sysdate);

  ------------------------------------------------------------------------------------
    procedure P_STOP_TASK  ( I_TASK_ID in number default G_TASK_ID);

  ------------------------------------------------------------------------------------
    function  F_NEW_TASK_FROM_TASK ( I_SOURCE_TASK_ID  in number,
                                     I_TIMEOUT         in date     default null,
                                     I_EXPIRE          in date     default null
                                   ) return number;

  ------------------------------------------------------------------------------------
    function  F_NEW_TASK_FROM_TASK ( I_TIMEOUT         in date     default null,
                                     I_EXPIRE          in date     default null
                                   ) return number;

  ------------------------------------------------------------------------------------
    procedure P_NEW_TASK_FROM_TASK( I_SOURCE_TASK_ID  in number,
                                    I_TIMEOUT         in date     default null,
                                    I_EXPIRE          in date     default null
                                  );

  ------------------------------------------------------------------------------------
    procedure P_NEW_TASK_FROM_TASK( I_TIMEOUT         in date     default null,
                                    I_EXPIRE          in date     default null
                                  );

  ------------------------------------------------------------------------------------
    -- CATEGORY
    procedure P_ADDMOD_CATEGORY ( I_CODE in varchar2, I_NAME in varchar2 );
    procedure P_DELETE_CATEGORY ( I_CODE in varchar2 );

  ------------------------------------------------------------------------------------
    -- TASK ID
    procedure P_SET_TASK_ID ( I_TASK_ID in number );
    function  F_GET_TASK_ID  return number;
    function  TASK_ID        return number;

  ------------------------------------------------------------------------------------
    -- TASK CATEGORY
    procedure P_SET_TASK_CATEGORY  ( I_TASK_ID in number, I_CATEGORY_CODE in varchar2 );
    procedure P_SET_TASK_CATEGORY  (                      I_CATEGORY_CODE in varchar2 );
    function  F_GET_TASK_CATEGORY  ( I_TASK_ID in number default G_TASK_ID ) return varchar2;
    function  TASK_CATEGORY        ( I_TASK_ID in number default G_TASK_ID ) return varchar2;

  ------------------------------------------------------------------------------------
    -- TASK SCRIPT_TO_RUN
    procedure P_SET_TASK_SCRIPT_TO_RUN  ( I_TASK_ID in number, I_SCRIPT_TO_RUN in varchar2 );
    procedure P_SET_TASK_SCRIPT_TO_RUN  (                      I_SCRIPT_TO_RUN in varchar2 );
    function  F_GET_TASK_SCRIPT_TO_RUN  ( I_TASK_ID in number default G_TASK_ID ) return varchar2;
    function  TASK_SCRIPT_TO_RUN        ( I_TASK_ID in number default G_TASK_ID ) return varchar2;

  ------------------------------------------------------------------------------------
    -- TASK NAME
    procedure P_SET_TASK_NAME  ( I_TASK_ID in number, I_NAME in varchar2 );
    procedure P_SET_TASK_NAME  (                      I_NAME in varchar2 );
    function  F_GET_TASK_NAME  ( I_TASK_ID in number default G_TASK_ID ) return varchar2;
    function  TASK_NAME        ( I_TASK_ID in number default G_TASK_ID ) return varchar2;

  ------------------------------------------------------------------------------------
    -- TASK CONDITION_SELECT
    procedure P_SET_TASK_CONDITION_SELECT  ( I_TASK_ID in number, I_CONDITION_SELECT in varchar2 );
    procedure P_SET_TASK_CONDITION_SELECT  (                      I_CONDITION_SELECT in varchar2 );
    function  F_GET_TASK_CONDITION_SELECT  ( I_TASK_ID in number default G_TASK_ID ) return varchar2;
    function  TASK_CONDITION_SELECT        ( I_TASK_ID in number default G_TASK_ID ) return varchar2;

  ------------------------------------------------------------------------------------
    -- TASK TIMEOUT
    procedure P_SET_TASK_TIMEOUT  ( I_TASK_ID in number, I_TIMEOUT in date );
    procedure P_SET_TASK_TIMEOUT  (                      I_TIMEOUT in date );
    function  F_GET_TASK_TIMEOUT  ( I_TASK_ID in number default G_TASK_ID ) return date;
    function  TASK_TIMEOUT        ( I_TASK_ID in number default G_TASK_ID ) return date;

  ------------------------------------------------------------------------------------
    -- TASK EXPIRE
    procedure P_SET_TASK_EXPIRE  ( I_TASK_ID in number, I_EXPIRE in date );
    procedure P_SET_TASK_EXPIRE  (                      I_EXPIRE in date );
    function  F_GET_TASK_EXPIRE  ( I_TASK_ID in number default G_TASK_ID ) return date;
    function  TASK_EXPIRE        ( I_TASK_ID in number default G_TASK_ID ) return date;

  ------------------------------------------------------------------------------------
    -- TASK REMARK
    procedure P_SET_TASK_REMARK  ( I_TASK_ID in number, I_REMARK in varchar2 );
    procedure P_SET_TASK_REMARK  (                      I_REMARK in varchar2 );
    function  F_GET_TASK_REMARK  ( I_TASK_ID in number default G_TASK_ID ) return varchar2;
    function  TASK_REMARK        ( I_TASK_ID in number default G_TASK_ID ) return varchar2;

  ------------------------------------------------------------------------------------
    -- LINE NUMBER
    procedure P_RESET_LINE_NUMBER;
    procedure P_INCREMENT_LINE_NUMBER;
    function  F_GET_LINE_NUMBER  return number;
    function  LINE_NUMBER        return number;
    function  NEXT_LINE_NUMBER   return number;

  ------------------------------------------------------------------------------------
    -- PARAMETERS
    procedure P_SET_PARAMETER ( I_TASK_ID in number, I_NAME in varchar2, I_VALUE in varchar2 );
    procedure P_SET_PARAMETER (                      I_NAME in varchar2, I_VALUE in varchar2 );
    function  F_GET_PARAMETER ( I_TASK_ID in number, I_NAME in varchar2 ) return varchar2;
    function  F_GET_PARAMETER (                      I_NAME in varchar2 ) return varchar2;
    function  TASK_PARAMETER  ( I_TASK_ID in number, I_NAME in varchar2 ) return varchar2;
    function  TASK_PARAMETER  (                      I_NAME in varchar2 ) return varchar2;

  ------------------------------------------------------------------------------------
    -- P_TASK_SUPERVISOR
    procedure P_UPLOAD_TASK_OUTPUT ( I_TASK_ID in number default G_TASK_ID);
    procedure P_SET_TASK_SESSION   ( I_TASK_ID in number default G_TASK_ID);
    procedure P_TASK_SUPERVISOR;

END;
/

/*************************************/
Prompt   T R I G G E R S
/*************************************/

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TRG_TASKS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON TASKS FOR EACH ROW
DECLARE
    L_USER  VARCHAR2(50) := NVL(UPPER(SUBSTR(SYS_CONTEXT('USERENV', 'OS_USER'), 1,50)),'SYSTEM');
BEGIN
    IF :NEW.ID           IS NULL THEN :NEW.ID           := SEQ_TASKS_ID.NEXTVAL;  END IF;
    IF :NEW.STATUS_CODE  IS NULL THEN :NEW.STATUS_CODE  := 'EDITING';             END IF;
    IF :NEW.CREATED      IS NULL THEN :NEW.CREATED      := SYSDATE;               END IF;
    IF :NEW.CREATED_BY   IS NULL THEN :NEW.CREATED_BY   := L_USER;                END IF;
    IF :NEW.TIMED        IS NULL THEN :NEW.TIMED        := SYSDATE;               END IF;
    IF nvl(:OLD.STATUS_CODE,'x')<>nvl(:NEW.STATUS_CODE,'x') THEN
        IF    :NEW.STATUS_CODE = 'RUNNING'  THEN 
            :NEW.STARTED    := SYSDATE;
        ELSIF :NEW.STATUS_CODE = 'FINISHED' THEN 
            :NEW.FINISHED   := SYSDATE;
        ELSIF :NEW.STATUS_CODE = 'FAILED'   THEN 
            :NEW.FINISHED   := SYSDATE;
        ELSIF :NEW.STATUS_CODE = 'DELETED'  THEN 
            :NEW.DELETED    := SYSDATE;
            :NEW.DELETED_BY := nvl(:NEW.DELETED_BY, L_USER);
        ELSIF :NEW.STATUS_CODE = 'KILLED'   THEN 
            :NEW.KILLED     := SYSDATE;
            :NEW.KILLED_BY  := nvl(:NEW.KILLED_BY , L_USER);
        END IF;
    END IF;
END;
/

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TRG_TASK_PARAMETERS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON TASK_PARAMETERS FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN :NEW.ID  := SEQ_TASK_PARAMETERS_ID.NEXTVAL;    END IF;
    begin
        IF :NEW.TASK_ID IS NULL THEN :NEW.TASK_ID := SEQ_TASKS_ID.CURRVAL; END IF;
    exception when others then
        IF :NEW.TASK_ID IS NULL THEN :NEW.TASK_ID := PKG_TASK.TASK_ID;           END IF;
    end;
END;
/


/*============================================================================================*/
CREATE OR REPLACE TRIGGER TRG_TASK_OUTPUT_LINES_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON TASK_OUTPUT_LINES FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN :NEW.ID  := SEQ_TASK_OUTPUT_LINES_ID.NEXTVAL;     END IF;
    begin
        IF :NEW.TASK_ID IS NULL THEN :NEW.TASK_ID := SEQ_TASKS_ID.CURRVAL;    END IF;
    exception when others then
        IF :NEW.TASK_ID IS NULL THEN :NEW.TASK_ID := PKG_TASK.TASK_ID;              END IF;
    end;
    IF :NEW.LINE_NUMBER IS NULL THEN :NEW.LINE_NUMBER := PKG_TASK.NEXT_LINE_NUMBER; END IF;
END;
/



/*************************************/
Prompt   P A C K A G E   B O D Y
/*************************************/


/*============================================================================================*/
CREATE OR REPLACE PACKAGE BODY PKG_TASK IS
/*============================================================================================*/


  ------------------------------------------------------------------------------------
  -- TASKS
  ------------------------------------------------------------------------------------
    function  F_NEW_TASK ( I_SCRIPT_TO_RUN     in varchar2,
                           I_CATEGORY_CODE     in varchar2 default null,
                           I_NAME              in varchar2 default null,                           
                           I_CONDITION_SELECT  in varchar2 default null,
                           I_TIMEOUT           in date     default null,
                           I_EXPIRE            in date     default null,
                           I_REMARK            in varchar2 default null
                         ) return number is
    pragma autonomous_transaction;
    begin
        if I_SCRIPT_TO_RUN is not null then
            G_TASK_ID  := SEQ_TASKS_ID.NEXTVAL;
            insert into TASKS 
              ( ID              ,
                CATEGORY_CODE   ,
                STATUS_CODE     ,
                NAME            ,
                REMARK          ,
                TIMEOUT         ,
                EXPIRE          ,
                CONDITION_SELECT,
                SCRIPT_TO_RUN
              ) values (
               G_TASK_ID         ,
               I_CATEGORY_CODE   ,
               'EDITING'         ,
               I_NAME            ,
               I_REMARK          ,
               I_TIMEOUT         ,
               I_EXPIRE          ,
               I_CONDITION_SELECT,
               I_SCRIPT_TO_RUN
              );
            commit;
        end if;
        return G_TASK_ID;
    exception when others then
        rollback;
        raise_application_error(-20014,'TASK creation has failed: '||sqlerrm);
        return null;
    end;
  ------------------------------------------------------------------------------------
    procedure  P_NEW_TASK( I_SCRIPT_TO_RUN     in varchar2,
                           I_CATEGORY_CODE     in varchar2 default null,
                           I_NAME              in varchar2 default null,                           
                           I_CONDITION_SELECT  in varchar2 default null,
                           I_TIMEOUT           in date     default null,
                           I_EXPIRE            in date     default null,
                           I_REMARK            in varchar2 default null
                         ) is
    begin
        G_TASK_ID := F_NEW_TASK ( I_SCRIPT_TO_RUN    ,
                                  I_CATEGORY_CODE    ,
                                  I_NAME             ,
                                  I_CONDITION_SELECT ,
                                  I_TIMEOUT          ,
                                  I_EXPIRE           ,
                                  I_REMARK           
                                );
    end;
  ------------------------------------------------------------------------------------
    procedure P_START_TASK ( I_TASK_ID in number, I_TIMED in date default sysdate) is
    pragma autonomous_transaction;
    begin
        update TASKS 
           set TIMED       = I_TIMED,
               STATUS_CODE = 'TOSTART'
         where ID = nvl(I_TASK_ID,G_TASK_ID)
           and STATUS_CODE = 'EDITING';
        commit;
    exception when others then
        rollback;
        raise_application_error(-20001,'TASK starting has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_START_TASK ( I_TIMED in date default sysdate) is
    begin
        P_START_TASK ( G_TASK_ID, I_TIMED);
    end;
  ------------------------------------------------------------------------------------
    procedure P_STOP_TASK( I_TASK_ID in number default G_TASK_ID) is
    pragma autonomous_transaction;
        L_TASK     TASKS%rowtype;
        L_USER     varchar2(50) := NVL(UPPER(SUBSTR(SYS_CONTEXT('USERENV', 'OS_USER'), 1,50)),'SYSTEM');
    begin
        select * into L_TASK from TASKS where ID = I_TASK_ID;
        -- depends on the current status
        if    L_TASK.STATUS_CODE in ('EDITING','TOSTART') then
            update TASKS 
               set STATUS_CODE = 'DELETED',
                   DELETED_BY  = L_USER,
                   DELETED     = sysdate
             where ID = I_TASK_ID;
            commit;
        elsif L_TASK.STATUS_CODE in ('RUNNING','FINISHING') then
            update TASKS 
               set STATUS_CODE = 'TOKILL',
                   KILLED_BY   = L_USER,
                   KILLED      = sysdate
             where ID = I_TASK_ID;
            commit;
        end if;
    exception when others then
        rollback;
        raise_application_error(-20002,'TASK stopping has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    function  F_NEW_TASK_FROM_TASK ( I_SOURCE_TASK_ID  in number,
                                     I_TIMEOUT         in date     default null,
                                     I_EXPIRE          in date     default null
                                   ) return number is
    pragma autonomous_transaction;
    begin
        G_TASK_ID  := SEQ_TASKS_ID.NEXTVAL;
        insert into TASKS
          ( ID                ,
            CATEGORY_CODE     ,
            STATUS_CODE       ,
            NAME              ,
            REMARK            ,
            CONDITION_SELECT  ,
            SCRIPT_TO_RUN     )
        select G_TASK_ID       ,
               CATEGORY_CODE   ,
               'EDITING'       ,
               NAME            ,
               REMARK          ,
               CONDITION_SELECT,
               SCRIPT_TO_RUN
          from TASKS
        where ID = I_SOURCE_TASK_ID;

        insert into TASK_PARAMETERS
          ( ID      ,
            TASK_ID ,
            NAME    ,
            VALUE   )
        select SEQ_TASK_PARAMETERS_ID.NEXTVAL,
               G_TASK_ID ,
               NAME      ,
               VALUE  
          from TASK_PARAMETERS
         where TASK_ID = I_SOURCE_TASK_ID;
      
        commit;
        return G_TASK_ID;
    exception when others then
        rollback;
        raise_application_error(-20003,'TASK creation from another task has failed: '||sqlerrm);
        return null;
    end;
  ------------------------------------------------------------------------------------
    function  F_NEW_TASK_FROM_TASK ( I_TIMEOUT         in date     default null,
                                     I_EXPIRE          in date     default null
                                   ) return number is
    begin
        return F_NEW_TASK_FROM_TASK( G_TASK_ID, I_TIMEOUT , I_EXPIRE);
    end;
  ------------------------------------------------------------------------------------
    procedure P_NEW_TASK_FROM_TASK( I_SOURCE_TASK_ID  in number,
                                    I_TIMEOUT         in date     default null,
                                    I_EXPIRE          in date     default null
                                  ) is
    begin
        G_TASK_ID := F_NEW_TASK_FROM_TASK ( I_SOURCE_TASK_ID,
                                            I_TIMEOUT       ,
                                            I_EXPIRE        
                                          );
    end;
  ------------------------------------------------------------------------------------
    procedure P_NEW_TASK_FROM_TASK( I_TIMEOUT         in date     default null,
                                    I_EXPIRE          in date     default null
                                  ) is
    begin
        P_NEW_TASK_FROM_TASK( G_TASK_ID, I_TIMEOUT, I_EXPIRE );
    end;


  ------------------------------------------------------------------------------------
  -- CATEGORY
  ------------------------------------------------------------------------------------
    procedure P_ADDMOD_CATEGORY ( I_CODE in varchar2, I_NAME in varchar2 ) is
    pragma autonomous_transaction;
        L_CNT   integer;
    begin
        select count(*)
          into L_CNT
          from TASK_CATEGORIES
         where CODE = I_CODE;
        if L_CNT = 0 then
            insert into TASK_CATEGORIES (CODE,NAME) values (I_CODE,I_NAME);
        else
            update TASK_CATEGORIES 
               set NAME  = I_NAME
             where CODE  = I_CODE
               and NAME != I_NAME;
        end if;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20004,'TASK category addmod has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_DELETE_CATEGORY ( I_CODE in varchar2 ) is
    pragma autonomous_transaction;
    begin
        delete TASK_CATEGORIES where CODE = I_CODE;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20005,'TASK category delete has failed: '||sqlerrm);
    end;


  ------------------------------------------------------------------------------------
  -- TASK ID
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_ID ( I_TASK_ID in number ) is
    begin
        G_TASK_ID := nvl(I_TASK_ID,G_TASK_ID);
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_ID  return number is
    begin
        return G_TASK_ID;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_ID        return number is
    begin
        return G_TASK_ID;
    end;

  
  ------------------------------------------------------------------------------------
  -- TASK CATEGORY
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_CATEGORY ( I_TASK_ID in number, I_CATEGORY_CODE in varchar2 ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set CATEGORY_CODE  = I_CATEGORY_CODE
         where ID             = nvl(I_TASK_ID,G_TASK_ID)
           and CATEGORY_CODE != I_CATEGORY_CODE;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20006,'TASK category code update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_CATEGORY  (                      I_CATEGORY_CODE in varchar2 ) is
    begin
        P_SET_TASK_CATEGORY ( G_TASK_ID, I_CATEGORY_CODE );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_CATEGORY  ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
        L_CATEGORY_CODE   TASKS.CATEGORY_CODE%type;
    begin
        select CATEGORY_CODE
          into L_CATEGORY_CODE
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_CATEGORY_CODE;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_CATEGORY        ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
    begin
        return F_GET_TASK_CATEGORY ( nvl(I_TASK_ID,G_TASK_ID) );
    end;


  ------------------------------------------------------------------------------------
  -- TASK SCRIPT_TO_RUN
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_SCRIPT_TO_RUN    ( I_TASK_ID in number, I_SCRIPT_TO_RUN    in varchar2 ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set SCRIPT_TO_RUN    = I_SCRIPT_TO_RUN
         where ID               = nvl(I_TASK_ID,G_TASK_ID)
           and I_SCRIPT_TO_RUN != I_SCRIPT_TO_RUN;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20007,'TASK script to run update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_SCRIPT_TO_RUN  (                        I_SCRIPT_TO_RUN in varchar2 ) is
    begin
        P_SET_TASK_SCRIPT_TO_RUN ( G_TASK_ID, I_SCRIPT_TO_RUN );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_SCRIPT_TO_RUN  ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
        L_SCRIPT_TO_RUN   TASKS.SCRIPT_TO_RUN%type;
    begin
        select SCRIPT_TO_RUN
          into L_SCRIPT_TO_RUN
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_SCRIPT_TO_RUN;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_SCRIPT_TO_RUN        ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
    begin
        return F_GET_TASK_SCRIPT_TO_RUN ( nvl(I_TASK_ID,G_TASK_ID) );
    end;


  ------------------------------------------------------------------------------------
  -- TASK NAME
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_NAME     ( I_TASK_ID in number, I_NAME          in varchar2 ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set NAME  = I_NAME
         where ID    = nvl(I_TASK_ID,G_TASK_ID)
           and NAME != I_NAME;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20008,'TASK name update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_NAME  (                      I_NAME in varchar2 ) is
    begin
        P_SET_TASK_NAME ( G_TASK_ID, I_NAME );
    end;

  ------------------------------------------------------------------------------------
    function  F_GET_TASK_NAME  ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
        L_NAME   TASKS.NAME%type;
    begin
        select NAME
          into L_NAME
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_NAME;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_NAME        ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
    begin
        return F_GET_TASK_NAME ( nvl(I_TASK_ID,G_TASK_ID) );
    end;


  ------------------------------------------------------------------------------------
  -- TASK CONDITION_SELECT
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_CONDITION_SELECT  ( I_TASK_ID in number, I_CONDITION_SELECT in varchar2 ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set CONDITION_SELECT  = I_CONDITION_SELECT
         where ID                = nvl(I_TASK_ID,G_TASK_ID)
           and CONDITION_SELECT != I_CONDITION_SELECT;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20009,'TASK conditon select update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_CONDITION_SELECT  (                      I_CONDITION_SELECT in varchar2 ) is
    begin
        P_SET_TASK_CONDITION_SELECT ( G_TASK_ID, I_CONDITION_SELECT );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_CONDITION_SELECT ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
        L_CONDITION_SELECT   TASKS.CONDITION_SELECT%type;
    begin
        select CONDITION_SELECT
          into L_CONDITION_SELECT
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_CONDITION_SELECT;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_CONDITION_SELECT        ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
    begin
        return F_GET_TASK_CONDITION_SELECT ( nvl(I_TASK_ID,G_TASK_ID) );
    end;

  ------------------------------------------------------------------------------------
  -- TASK TIMEOUT
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_TIMEOUT  ( I_TASK_ID in number, I_TIMEOUT in date ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set TIMEOUT  = I_TIMEOUT
         where ID       = nvl(I_TASK_ID,G_TASK_ID)
           and TIMEOUT != I_TIMEOUT;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20010,'TASK timeout update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_TIMEOUT  (                      I_TIMEOUT in date ) is
    begin
        P_SET_TASK_TIMEOUT ( G_TASK_ID, I_TIMEOUT );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_TIMEOUT ( I_TASK_ID in number default G_TASK_ID ) return date is
        L_TIMEOUT   TASKS.TIMEOUT%type;
    begin
        select TIMEOUT
          into L_TIMEOUT
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_TIMEOUT;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_TIMEOUT        ( I_TASK_ID in number default G_TASK_ID ) return date is
    begin
        return F_GET_TASK_TIMEOUT ( nvl(I_TASK_ID,G_TASK_ID) );
    end;


  ------------------------------------------------------------------------------------
  -- TASK EXPIRE
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_EXPIRE   ( I_TASK_ID in number, I_EXPIRE        in date     ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set EXPIRE = I_EXPIRE
         where ID      = nvl(I_TASK_ID,G_TASK_ID)
           and EXPIRE != I_EXPIRE;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20011,'TASK expire time update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_EXPIRE  (                      I_EXPIRE in date ) is
    begin
        P_SET_TASK_EXPIRE ( G_TASK_ID, I_EXPIRE );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_EXPIRE ( I_TASK_ID in number default G_TASK_ID ) return date is
        L_EXPIRE   TASKS.EXPIRE%type;
    begin
        select EXPIRE
          into L_EXPIRE
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_EXPIRE;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_EXPIRE        ( I_TASK_ID in number default G_TASK_ID ) return date is
    begin
        return F_GET_TASK_EXPIRE ( nvl(I_TASK_ID,G_TASK_ID) );
    end;


  ------------------------------------------------------------------------------------
  -- TASK REMARK
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_REMARK   ( I_TASK_ID in number, I_REMARK        in varchar2 ) is
    pragma autonomous_transaction;
    begin  
        update TASKS
           set REMARK = I_REMARK
         where ID      = nvl(I_TASK_ID,G_TASK_ID)
           and REMARK != I_REMARK;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20012,'TASK remark update has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_REMARK  (                      I_REMARK in varchar2 ) is
    begin
        P_SET_TASK_REMARK ( G_TASK_ID, I_REMARK );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_TASK_REMARK ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
        L_REMARK   TASKS.REMARK%type;
    begin
        select REMARK
          into L_REMARK
          from TASKS
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        return L_REMARK;
    end;
  ------------------------------------------------------------------------------------
    function  TASK_REMARK        ( I_TASK_ID in number default G_TASK_ID ) return varchar2 is
    begin
        return F_GET_TASK_REMARK ( nvl(I_TASK_ID,G_TASK_ID) );
    end;


  ------------------------------------------------------------------------------------
  -- LINE NUMBER
  ------------------------------------------------------------------------------------
    procedure P_RESET_LINE_NUMBER is
    begin
        G_OUTPUT_LINE_NUMBER := 0;
    end;
  ------------------------------------------------------------------------------------
    procedure P_INCREMENT_LINE_NUMBER is
    begin
        G_OUTPUT_LINE_NUMBER := G_OUTPUT_LINE_NUMBER + 1;
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_LINE_NUMBER return number is
    begin
        return G_OUTPUT_LINE_NUMBER;
    end;
  ------------------------------------------------------------------------------------
    function  LINE_NUMBER        return number is
    begin
        return G_OUTPUT_LINE_NUMBER;
    end;
  ------------------------------------------------------------------------------------
    function  NEXT_LINE_NUMBER   return number is
    begin
        G_OUTPUT_LINE_NUMBER := G_OUTPUT_LINE_NUMBER + 1;
        return G_OUTPUT_LINE_NUMBER ;
    end;

  ------------------------------------------------------------------------------------
  -- PARAMETERS
  ------------------------------------------------------------------------------------
    function  F_GET_PARAMETER_ID( I_TASK_ID in number, I_NAME in varchar2 ) return number is
        L_C      number(10);
    begin        
        select count(*) 
          into L_C
          from TASK_PARAMETERS
         where TASK_ID = nvl(I_TASK_ID,G_TASK_ID)
           and upper(trim(NAME)) = upper(trim(I_NAME));
        if L_C = 1 then
            select ID
              into L_C
              from TASK_PARAMETERS
             where TASK_ID = nvl(I_TASK_ID,G_TASK_ID)
               and upper(trim(NAME)) = upper(trim(I_NAME));
        else
            L_C := 0;
        end if;
        return L_C;
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_PARAMETER_ID( I_NAME in varchar2 ) return number is
    begin
        return F_GET_PARAMETER_ID( G_TASK_ID, I_NAME );
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_PARAMETER ( I_TASK_ID in number, I_NAME in varchar2, I_VALUE in varchar2 ) is
    pragma autonomous_transaction;
        L_ID      number(10);
    begin
        L_ID := F_GET_PARAMETER_ID( nvl(I_TASK_ID,G_TASK_ID), I_NAME );
        if nvl(L_ID,0) = 0 then
            insert into TASK_PARAMETERS 
              (                            ID,                  TASK_ID,              NAME  ,   VALUE) values
              (SEQ_TASK_PARAMETERS_ID.NEXTVAL, nvl(I_TASK_ID,G_TASK_ID), upper(trim(I_NAME)), I_VALUE);
        else
            update TASK_PARAMETERS set VALUE = I_VALUE where ID = L_ID and VALUE <> I_VALUE ;
        end if;
        commit;
    exception when others then
        rollback;
        raise_application_error(-20013,'The parameter value setting has failed: '||sqlerrm);
    end;
  ------------------------------------------------------------------------------------
    procedure P_SET_PARAMETER ( I_NAME in varchar2, I_VALUE in varchar2 ) is
    begin
        P_SET_PARAMETER ( G_TASK_ID, I_NAME, I_VALUE );
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_PARAMETER( I_TASK_ID in number, I_NAME in varchar2 ) return varchar2 is
        L_ID      number(10);
        L_VALUE   TASK_PARAMETERS.VALUE%type;
    begin
        L_ID := F_GET_PARAMETER_ID( nvl(I_TASK_ID,G_TASK_ID), I_NAME );
        if nvl(L_ID,0) > 0 then
            select VALUE
              into L_VALUE
              from TASK_PARAMETERS
             where ID = L_ID;          
        else
            L_VALUE := null;
        end if;
        return L_VALUE;
    end;
  ------------------------------------------------------------------------------------
    function  F_GET_PARAMETER( I_NAME in varchar2 ) return varchar2 is
    begin
        return F_GET_PARAMETER( G_TASK_ID, I_NAME );
    end;

  ------------------------------------------------------------------------------------
    function  TASK_PARAMETER( I_TASK_ID in number, I_NAME in varchar2 ) return varchar2 is
    begin
        return F_GET_PARAMETER( nvl(I_TASK_ID,G_TASK_ID), I_NAME );
    end;
  ------------------------------------------------------------------------------------
    function  TASK_PARAMETER( I_NAME in varchar2 ) return varchar2 is
    begin
        return F_GET_PARAMETER( G_TASK_ID, I_NAME );
    end;

  ------------------------------------------------------------------------------------
  -- STARTER
  ------------------------------------------------------------------------------------
    procedure P_SET_TASK_SESSION ( I_TASK_ID in number default G_TASK_ID ) is
    begin
        update TASKS 
           set SID    = sys_context('USERENV', 'SID'),
               SERIAL = (select serial# from v$session where audsid=sys_context('USERENV', 'SESSIONID'))
         where ID = nvl(I_TASK_ID,G_TASK_ID);
        commit;
    end;
  ------------------------------------------------------------------------------------
    procedure P_UPLOAD_TASK_OUTPUT ( I_TASK_ID in number default G_TASK_ID ) is
        L_FILE           utl_file.file_type;
        L_FILE_NAME      varchar2(100);
        L_VALUE          varchar2(32000);
    begin
        update TASKS set STATUS_CODE = 'FINISHING' where ID = nvl(I_TASK_ID,G_TASK_ID) and STATUS_CODE='RUNNING';
        commit;

        L_FILE_NAME := 'TASK_'||trim(to_char(nvl(I_TASK_ID,G_TASK_ID)));
        L_FILE      := utl_file.fopen('TASKS_FILES', L_FILE_NAME||'.out', 'R');
        P_RESET_LINE_NUMBER;
        loop
            begin
                utl_file.get_line(L_FILE, L_VALUE);
                P_INCREMENT_LINE_NUMBER;
                insert into TASK_OUTPUT_LINES
                  (                 TASK_ID,          LINE_NUMBER,   VALUE ) values
                  (nvl(I_TASK_ID,G_TASK_ID), G_OUTPUT_LINE_NUMBER, L_VALUE );
                commit;
            exception when no_data_found then
                exit;
            when others then
                L_VALUE := '*** upload error:'||sqlerrm;
                P_INCREMENT_LINE_NUMBER;
                insert into TASK_OUTPUT_LINES
                  (                 TASK_ID,          LINE_NUMBER ,   VALUE ) values
                  (nvl(I_TASK_ID,G_TASK_ID), G_OUTPUT_LINE_NUMBER , L_VALUE);
                commit;
                exit;
            end;
        end loop;

        utl_file.fclose ( L_FILE );
        utl_file.fremove('TASKS_FILES',  L_FILE_NAME||'.out' );

        update TASKS set STATUS_CODE = 'FINISHED'  where ID = nvl(I_TASK_ID,G_TASK_ID) and STATUS_CODE='FINISHING';
        commit;

    exception when others then
        if utl_file.is_open(L_FILE) then
            utl_file.fclose ( L_FILE );
        end if;
    end;
  ------------------------------------------------------------------------------------
    -- if a task run has failed, the out file remains in the folder
    -- this procedure collects and uploads them
    procedure P_FAILED_UPLOADER is
        L_FILE_NAME      varchar2(100);
        L_FILE_OUT_EX    boolean;
        L_FILE_SQL_EX    boolean;
        L_FILE_FLEN      number;
        L_FILE_BSIZE     number; 
    begin
        for L_R in (select ID from TASK_RUNNING_VW) loop
            L_FILE_NAME := 'TASK_'||trim(to_char(L_R.ID));
            utl_file.fgetattr('TASKS_FILES', L_FILE_NAME||'.out', L_FILE_OUT_EX, L_FILE_FLEN, L_FILE_BSIZE);
            utl_file.fgetattr('TASKS_FILES', L_FILE_NAME||'.sql', L_FILE_SQL_EX, L_FILE_FLEN, L_FILE_BSIZE);
            if L_FILE_OUT_EX and not L_FILE_SQL_EX then
                update TASKS set STATUS_CODE = 'FAILED'  where ID = L_R.ID and STATUS_CODE='RUNNING';
                commit;
                P_UPLOAD_TASK_OUTPUT ( L_R.ID );
            end if;
        end loop;
    end;
  ------------------------------------------------------------------------------------
    procedure P_WRITE_SCRIPT ( I_TASK_ID in number default G_TASK_ID ) is
        L_FILE           utl_file.file_type;
        L_FILE_NAME      varchar2(100);
        L_TASK           TASKS%rowtype;
    begin

        select * into L_TASK from TASKS where ID = nvl(I_TASK_ID,G_TASK_ID);

        L_FILE_NAME := 'TASK_'||trim(to_char(nvl(I_TASK_ID,G_TASK_ID)));
        L_FILE      := utl_file.fopen('TASKS_FILES', L_FILE_NAME||'.tmp', 'W');

        utl_file.put_line(L_FILE, 'SET TIMING OFF'       , true);
        utl_file.put_line(L_FILE, 'SET NEWPAGE 0'        , true);
        utl_file.put_line(L_FILE, 'SET SPACE 0'          , true);
        utl_file.put_line(L_FILE, 'SET LINESIZE 4000'    , true);
        utl_file.put_line(L_FILE, 'SET PAGESIZE 0'       , true);
        utl_file.put_line(L_FILE, 'SET ECHO OFF'         , true);
        utl_file.put_line(L_FILE, 'SET FEEDBACK OFF'     , true);
        utl_file.put_line(L_FILE, 'SET HEADING OFF'      , true);
        utl_file.put_line(L_FILE, 'SET TERMOUT OFF'      , true);
        utl_file.put_line(L_FILE, 'SET ARRAYSIZE 5000'   , true);
        utl_file.put_line(L_FILE, 'SET TRIMSPOOL ON'     , true);
        utl_file.put_line(L_FILE, 'SET PAUSE OFF'        , true);
        utl_file.put_line(L_FILE, 'SET VERIFY OFF'       , true);
        utl_file.put_line(L_FILE, 'SET WRAP OFF'         , true);
        utl_file.put_line(L_FILE, 'SET SERVEROUTPUT ON SIZE UNLIMITED' , true);

        utl_file.put_line(L_FILE, 'EXECUTE PKG_TASK.P_SET_TASK_ID( '||nvl(I_TASK_ID,G_TASK_ID)||' );' , true);
        utl_file.put_line(L_FILE, 'EXECUTE PKG_TASK.P_SET_TASK_SESSION( '||nvl(I_TASK_ID,G_TASK_ID)||' );' , true);

        utl_file.put_line(L_FILE, 'SPOOL '||L_FILE_NAME||'.out'      , true);                                   
        utl_file.put_line(L_FILE,  L_TASK.SCRIPT_TO_RUN  , true);
        utl_file.put_line(L_FILE, 'SPOOL OFF'            , true);

        utl_file.put_line(L_FILE, 'EXECUTE PKG_TASK.P_UPLOAD_TASK_OUTPUT( '||nvl(I_TASK_ID,G_TASK_ID)||' );' , true);    
        
        utl_file.put_line(L_FILE, 'EXIT;'                , true);
        utl_file.fclose ( L_FILE );
        -- rename to run
        utl_file.frename('TASKS_FILES',L_FILE_NAME||'.tmp','TASKS_FILES',L_FILE_NAME||'.run',FALSE);

    exception when others then
        if utl_file.is_open(L_FILE) then
            utl_file.fclose ( L_FILE );
        end if;
    end;
  ------------------------------------------------------------------------------------
    procedure P_STARTER is
        L_REC_SET           SYS_REFCURSOR; 
        L_DUMMY             varchar2(32000);
        L_GO_ON             boolean := true;
        L_PREV_TASK_ID      number;
    begin

        L_PREV_TASK_ID := G_TASK_ID;

        for L_R in (select * from TASK_NEED_TO_START_VW) loop

            -- set up the current TASK ID 
            P_SET_TASK_ID( L_R.ID );

            -- that is not enough. We also have to check the conditon
            if L_R.CONDITION_SELECT is not null then

                begin
                    open  L_REC_SET for   L_R.CONDITION_SELECT;
                    fetch L_REC_SET into  L_DUMMY;
                    if L_REC_SET%notfound then     -- the result of the condition is not true!
                        L_GO_ON := false;
                    end if;
                exception when others then
                    L_GO_ON := false;              -- if the condition select was wrong then not start the job ???
                end;

                if L_REC_SET%isopen then 
                    close L_REC_SET;
                end if;

            end if;

            if L_GO_ON then
                update TASKS set STATUS_CODE = 'RUNNING' where ID = L_R.ID;
                commit;
                P_WRITE_SCRIPT ( L_R.ID );
            end if;

        end loop;
    
        P_SET_TASK_ID( L_PREV_TASK_ID );

    end;

  ------------------------------------------------------------------------------------
    -- clean the remained files
    procedure  P_DELETE_FILES(I_TASK_ID in number) is
        L_FILE_NAME      varchar2(100);
    begin
        L_FILE_NAME := 'TASK_'||trim(to_char(nvl(I_TASK_ID,G_TASK_ID)));
        utl_file.fremove('TASKS_FILES',  L_FILE_NAME||'.sql' );
        utl_file.fremove('TASKS_FILES',  L_FILE_NAME||'.run' );
        utl_file.fremove('TASKS_FILES',  L_FILE_NAME||'.out' );
    exception when others then
        null; 
    end;


  ------------------------------------------------------------------------------------
  -- KILLER
  ------------------------------------------------------------------------------------
    procedure P_KILL_A_TASK(I_SID in number, I_SERIAL in number) is
        L_WHAT    varchar2(100);
    begin
        L_WHAT := 'alter system kill session '''||I_SID||','||I_SERIAL||'''' ; 
        execute immediate L_WHAT;
        L_WHAT := 'alter system disconnect session '''||I_SID||','||I_SERIAL||''' immediate' ; 
        execute immediate L_WHAT;
    exception when others then
        null; 
    end;
  ------------------------------------------------------------------------------------
    procedure P_KILLER is
    begin
        -- set TOKILL where needs
        for L_R in (select ID from TASK_NEED_TO_KILL_VW) loop
            update TASKS set STATUS_CODE = 'TOKILL' where ID = L_R.ID;
            commit;
        end loop;
        -- Kill them       
        for L_R in (select * from TASK_TOKILL_VW) loop
            P_KILL_A_TASK(L_R.SID, L_R.SERIAL);
            update TASKS set STATUS_CODE = 'KILLED' where ID = L_R.ID;
            commit;
        end loop;
    end;


  ------------------------------------------------------------------------------------
  -- TIMEOUTER
  ------------------------------------------------------------------------------------
    procedure P_TIMEOUTER is
    begin
        -- set TIMEDOUT where needs
        for L_R in (select ID from TASK_NEED_TO_TIMEOUT_VW) loop
            update TASKS set STATUS_CODE = 'TIMEDOUT' where ID = L_R.ID;
            commit;
        end loop;
    end;

  ------------------------------------------------------------------------------------
  -- CLEANER
  ------------------------------------------------------------------------------------
    procedure P_CLEAN_A_TASK (I_TASK_ID in number) is
    begin
        delete TASK_OUTPUT_LINES where TASK_ID = I_TASK_ID;
        delete TASK_PARAMETERS   where TASK_ID = I_TASK_ID;
        delete TASKS             where ID      = I_TASK_ID;
        commit;
        -- clean the remained files
        P_DELETE_FILES(I_TASK_ID);
    end;
  ------------------------------------------------------------------------------------
    procedure P_CLEANER is
    begin
        for L_R in (select ID from TASK_NEED_TO_REMOVE_VW) loop
            P_CLEAN_A_TASK(L_R.ID);
        end loop;
    end;

  ------------------------------------------------------------------------------------
  -- P_TASK_SUPERVISOR
  ------------------------------------------------------------------------------------
    procedure P_TASK_SUPERVISOR is
    begin

        -- START
--        begin
            P_STARTER;
--        exception when others then
--            TRLG.SET_TRAN_NAME( 'STARTING' );
--            TRLG.ADD_ERROR( sqlerrm );
--        end;
--
        -- FAILED UPLOADER
--        begin
            P_FAILED_UPLOADER;
--        exception when others then
--            TRLG.SET_TRAN_NAME( 'FAILED UPLOADER' );
--            TRLG.ADD_ERROR( sqlerrm );
--        end;
--
        -- KILL
--        begin
            P_KILLER;
--        exception when others then
--            TRLG.SET_TRAN_NAME( 'KILLING' );
--            TRLG.ADD_ERROR( sqlerrm );
--        end;
--
        -- TIMEOUT
--        begin
            P_TIMEOUTER;
--        exception when others then
--            TRLG.SET_TRAN_NAME( 'TIMEOUT' );
--            TRLG.ADD_ERROR( sqlerrm );
--        end;
--
        -- CLEANER
--        begin
            P_CLEANER;
--        exception when others then
--            TRLG.SET_TRAN_NAME( 'CLEANING' );
--            TRLG.ADD_ERROR( sqlerrm );
--        end;

    end;


END;
/

GRANT  EXECUTE ON      PKG_TASK TO  PUBLIC;
CREATE OR REPLACE PUBLIC  SYNONYM PKG_TASK FOR PKG_TASK;


/*************************************/
Prompt   J O B
/*************************************/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
    ( job       => X
     ,what      => 'PKG_TASK.P_TASK_SUPERVISOR;'
     ,next_date => SYSDATE+5/1440
     ,interval  => 'SYSDATE+5/1440'
     ,no_parse  => TRUE
    );
END;
/


