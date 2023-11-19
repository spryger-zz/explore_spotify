CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_streams_timestamp
BEFORE UPDATE ON streams
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();