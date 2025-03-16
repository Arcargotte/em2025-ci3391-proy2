@echo off
chcp 65001
SET server=localhost
SET database=postgres
SET port=5432
SET username=postgres
SET PGPASSWORD=admin
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h %server% -U %username% -d %database% -p %port%