CREATE OR REPLACE FUNCTION bitacora_insertupdate() 
RETURNS trigger as
$BODY$
begin
    INSERT INTO bitacora(date, modified_table,time, usuario, tipo, modified_field)
    VALUES(current_date, TG_TABLE_NAME,current_time, NEW.modified_by, TG_OP, NEW.modified_field);
	RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql'
;

CREATE OR REPLACE FUNCTION bitacora_delete()
RETURNS trigger as
$BODY$
begin
    INSERT INTO bitacora(date, modified_table,time, usuario, tipo, modified_field)
    VALUES(current_date, TG_TABLE_NAME,current_time, OLD.modified_by, TG_OP, NULL);
	RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql'
;

CREATE TRIGGER insert_bitacora
AFTER INSERT
ON artist
FOR EACH ROW
EXECUTE PROCEDURE bitacora_insertupdate();