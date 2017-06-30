# PostgreSQL-Auditing

This repository contains the PostgreSQL file which serves as an example for people trying to write functions in Psql. 
It also helps in getting an understanding about triggers and auditing a Psql table. I have just used a small table called products. 
Any inserts, deletions and updates will be logged/ audited into another table called audits_tablefor_products.
This auditing helps keep track of changes as they occur and helps in decision making when dealing with a regular updates to a very large database.
