SET search_path TO public;

DROP TABLE IF EXISTS preco_insercao;
DROP TABLE IF EXISTS produto_insercao;

-- =========================
-- produto_insercao
-- =========================
CREATE TABLE produto_insercao (
  id SERIAL PRIMARY KEY,
  prod_cod VARCHAR(30) UNIQUE NOT NULL,
  prod_nome VARCHAR(150),
  prod_cat VARCHAR(50),
  prod_subcat VARCHAR(50),
  prod_desc TEXT,
  prod_fab VARCHAR(100),
  prod_mod VARCHAR(50),
  prod_cor VARCHAR(30),
  prod_peso_kg NUMERIC(10,3),
  prod_larg_cm NUMERIC(10,2),
  prod_alt_cm NUMERIC(10,2),
  prod_prof_cm NUMERIC(10,2),
  prod_und VARCHAR(10),
  prod_dt_cad DATE,
  updated_at TIMESTAMP DEFAULT now()
);

-- =========================
-- preco_insercao
-- =========================
CREATE TABLE preco_insercao (
  id SERIAL PRIMARY KEY,
  prc_cod_prod VARCHAR(30) NOT NULL UNIQUE,
  prc_valor NUMERIC(12,2),
  prc_moeda VARCHAR(10),
  prc_desc_percent NUMERIC(5,2),
  prc_acres_percent NUMERIC(5,2),
  prc_promo NUMERIC(12,2),
  prc_dt_ini_promo DATE,
  prc_dt_fim_promo DATE,
  prc_dt_atual DATE,
  prc_origem VARCHAR(50),
  prc_tipo_cli VARCHAR(30),
  prc_vend_resp VARCHAR(100),
  prc_obs TEXT,
  updated_at TIMESTAMP DEFAULT now(),

  CONSTRAINT fk_produto
    FOREIGN KEY (prc_cod_prod)
    REFERENCES produto_insercao (prod_cod)
    ON DELETE CASCADE
);

