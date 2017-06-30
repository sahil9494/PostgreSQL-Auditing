-- create the main product table

create table products(
product_id numeric(7) primary key,
product_name text,
price numeric(7)
);


-- create table for auditing changes to the main table

create table audit_tablefor_products(
product_id numeric(7),
product_name text,
price numeric(7),
changed_on timestamp(6),
typeofchange text
);


-- create appropriate functions for the changes
-- create function for new insertions

CREATE OR REPLACE FUNCTION log_table_inserts()
RETURNS trigger AS
$BODY$
BEGIN
 INSERT INTO audit_tablefor_products(product_id,product_name,price,changed_on,typeofchange)
 VALUES(NEW.product_id,NEW.product_name,NEW.price,now(),'inserted');
 RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;





--create function for updates

CREATE OR REPLACE FUNCTION log_table_updates()
RETURNS trigger AS
$BODY$
BEGIN
 IF( (NEW.product_id <> OLD.product_id) OR
  (NEW.product_name <> OLD.product_name) OR
  (NEW.price <> OLD.price))
 THEN
 INSERT INTO audit_tablefor_products(product_id,product_name,price,changed_on,typeofchange)
 VALUES(OLD.product_id,OLD.product_name,OLD.price,now(),'updated');
 END IF;
 
 RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;




--create function for deletions


CREATE OR REPLACE FUNCTION log_table_deletions()
RETURNS trigger AS
$BODY$
BEGIN
 INSERT INTO audit_tablefor_products(product_id,product_name,price,changed_on,typeofchange)
 VALUES(OLD.product_id,OLD.product_name,OLD.price,now(),'deleted'); 
 RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;


--create trigger for updates

CREATE TRIGGER log_updates
  BEFORE UPDATE
  ON products
  FOR EACH ROW
  EXECUTE PROCEDURE log_table_updates();


--create trigger for deletions

CREATE TRIGGER log_deletions
  BEFORE DELETE
  ON products
  FOR EACH ROW
  EXECUTE PROCEDURE log_table_deletions();


--create trigger for new insertions

CREATE TRIGGER log_insertions
  AFTER INSERT
  ON products
  FOR EACH ROW
  EXECUTE PROCEDURE log_table_inserts();

