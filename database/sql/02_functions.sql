SET search_path TO public;

DROP FUNCTION IF EXISTS fn_parse_numeric(TEXT);
DROP FUNCTION IF EXISTS fn_parse_date(TEXT);

CREATE OR REPLACE FUNCTION fn_parse_numeric(txt TEXT)
RETURNS NUMERIC AS $$
DECLARE s TEXT;
BEGIN
  IF txt IS NULL THEN RETURN NULL; END IF;
  s := lower(trim(txt));
  IF s = '' OR s LIKE '%sem%' THEN RETURN NULL; END IF;

  s := regexp_replace(s, '[^0-9\.,\-]', '', 'g');
  IF s = '' THEN RETURN NULL; END IF;

  IF s ~ '^\d{1,3}(\.\d{3})+,\d+$' THEN
    s := replace(s, '.', '');
    s := replace(s, ',', '.');
    RETURN s::numeric;
  END IF;

  IF s ~ '^\d+,\d+$' THEN
    s := replace(s, ',', '.');
    RETURN s::numeric;
  END IF;

  RETURN s::numeric;
EXCEPTION WHEN others THEN
  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION fn_parse_date(txt TEXT)
RETURNS DATE AS $$
DECLARE s TEXT;
BEGIN
  IF txt IS NULL THEN RETURN NULL; END IF;
  s := trim(txt);
  IF s = '' THEN RETURN NULL; END IF;

  s := replace(replace(s, '/', '-'), '.', '-');

  IF s ~ '^\d{4}-\d{2}-\d{2}$' THEN
    RETURN to_date(s, 'YYYY-MM-DD');
  END IF;

  IF s ~ '^\d{2}-\d{2}-\d{4}$' THEN
    RETURN to_date(s, 'DD-MM-YYYY');
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
