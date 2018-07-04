REN %1 %~n1.SQL
SQLPLUS ca/xx@localhost:1521/orcl.abc.local @%~n1.SQL
DEL %~n1.SQL
EXIT
