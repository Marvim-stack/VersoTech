SET search_path TO public;

-- =========================
-- SINCRONIZA PRODUTOS
-- =========================
INSERT INTO produto_insercao (
  prod_cod, prod_nome, prod_cat, prod_subcat, prod_desc,
  prod_fab, prod_mod, prod_cor,
  prod_peso_kg, prod_larg_cm, prod_alt_cm, prod_prof_cm,
  prod_und, prod_dt_cad
)
SELECT
  prod_cod, prod_nome, prod_cat, prod_subcat, prod_desc,
  prod_fab, prod_mod, prod_cor,
  prod_peso_kg, prod_larg_cm, prod_alt_cm, prod_prof_cm,
  prod_und, prod_dt_cad
FROM vw_produtos_tratados
ON CONFLICT (prod_cod) DO UPDATE SET
  prod_nome       = EXCLUDED.prod_nome,
  prod_cat        = EXCLUDED.prod_cat,
  prod_subcat     = EXCLUDED.prod_subcat,
  prod_desc       = EXCLUDED.prod_desc,
  prod_fab        = EXCLUDED.prod_fab,
  prod_mod        = EXCLUDED.prod_mod,
  prod_cor        = EXCLUDED.prod_cor,
  prod_peso_kg    = EXCLUDED.prod_peso_kg,
  prod_larg_cm    = EXCLUDED.prod_larg_cm,
  prod_alt_cm     = EXCLUDED.prod_alt_cm,
  prod_prof_cm    = EXCLUDED.prod_prof_cm,
  prod_und        = EXCLUDED.prod_und,
  prod_dt_cad     = EXCLUDED.prod_dt_cad,
  updated_at      = now();

-- =========================
-- SINCRONIZA PREÇOS
-- =========================
INSERT INTO preco_insercao (
  prc_cod_prod, prc_valor, prc_moeda,
  prc_desc_percent, prc_acres_percent, prc_promo,
  prc_dt_ini_promo, prc_dt_fim_promo, prc_dt_atual,
  prc_origem, prc_tipo_cli, prc_vend_resp, prc_obs
)
SELECT
  prc_cod_prod, prc_valor, prc_moeda,
  prc_desc_percent, prc_acres_percent, prc_promo,
  prc_dt_ini_promo, prc_dt_fim_promo, prc_dt_atual,
  prc_origem, prc_tipo_cli, prc_vend_resp, prc_obs
FROM vw_precos_tratados
ON CONFLICT (prc_cod_prod) DO UPDATE SET
  prc_valor          = EXCLUDED.prc_valor,
  prc_moeda          = EXCLUDED.prc_moeda,
  prc_desc_percent   = EXCLUDED.prc_desc_percent,
  prc_acres_percent  = EXCLUDED.prc_acres_percent,
  prc_promo          = EXCLUDED.prc_promo,
  prc_dt_ini_promo   = EXCLUDED.prc_dt_ini_promo,
  prc_dt_fim_promo   = EXCLUDED.prc_dt_fim_promo,
  prc_dt_atual       = EXCLUDED.prc_dt_atual,
  prc_origem         = EXCLUDED.prc_origem,
  prc_tipo_cli       = EXCLUDED.prc_tipo_cli,
  prc_vend_resp      = EXCLUDED.prc_vend_resp,
  prc_obs            = EXCLUDED.prc_obs,
  updated_at         = now();
