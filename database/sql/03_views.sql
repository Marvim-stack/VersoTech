SET search_path TO public;

DROP VIEW IF EXISTS vw_precos_tratados;
DROP VIEW IF EXISTS vw_produtos_tratados;

CREATE OR REPLACE VIEW vw_produtos_tratados AS
SELECT
  upper(trim(prod_cod)) AS prod_cod,
  initcap(regexp_replace(trim(prod_nome), '\s+', ' ', 'g')) AS prod_nome,
  upper(trim(prod_cat)) AS prod_cat,
  upper(trim(prod_subcat)) AS prod_subcat,
  trim(prod_desc) AS prod_desc,
  initcap(trim(prod_fab)) AS prod_fab,
  upper(trim(prod_mod)) AS prod_mod,
  initcap(trim(prod_cor)) AS prod_cor,

  CASE
    WHEN lower(prod_peso) LIKE '%kg%' THEN fn_parse_numeric(prod_peso)
    WHEN lower(prod_peso) LIKE '%g%'  THEN fn_parse_numeric(prod_peso) / 1000
    ELSE fn_parse_numeric(prod_peso)
  END AS prod_peso_kg,

  fn_parse_numeric(prod_larg) AS prod_larg_cm,
  fn_parse_numeric(prod_alt)  AS prod_alt_cm,
  fn_parse_numeric(prod_prof) AS prod_prof_cm,

  upper(trim(prod_und)) AS prod_und,
  prod_atv,
  fn_parse_date(prod_dt_cad) AS prod_dt_cad
FROM produtos_base
WHERE prod_atv = TRUE;

CREATE OR REPLACE VIEW vw_precos_tratados AS
SELECT
  upper(trim(prc_cod_prod)) AS prc_cod_prod,
  fn_parse_numeric(prc_valor) AS prc_valor,
  upper(trim(prc_moeda)) AS prc_moeda,
  fn_parse_numeric(prc_desc) AS prc_desc_percent,
  fn_parse_numeric(prc_acres) AS prc_acres_percent,
  fn_parse_numeric(prc_promo) AS prc_promo,
  fn_parse_date(prc_dt_ini_promo) AS prc_dt_ini_promo,
  fn_parse_date(prc_dt_fim_promo) AS prc_dt_fim_promo,
  fn_parse_date(prc_dt_atual) AS prc_dt_atual,
  upper(trim(prc_origem)) AS prc_origem,
  upper(trim(prc_tipo_cli)) AS prc_tipo_cli,
  initcap(trim(prc_vend_resp)) AS prc_vend_resp,
  trim(prc_obs) AS prc_obs,
  lower(trim(prc_status)) AS prc_status
FROM precos_base
WHERE lower(trim(prc_status)) = 'ativo';
