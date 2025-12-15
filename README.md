# VersoTech – Teste Técnico (Implantador de Sistemas)

Projeto desenvolvido como teste técnico para a vaga de **Implantador de Sistemas**.

O objetivo é demonstrar a **padronização, tratamento e sincronização de dados** de produtos e preços utilizando **Views SQL no PostgreSQL**, com orquestração via **API Laravel**.

---

##  Arquitetura da Solução

- **PostgreSQL**
  - Armazena dados brutos
  - Executa tratamento e padronização via Views
  - Mantém integridade entre produtos e preços

- **Laravel 12**
  - Orquestra a sincronização
  - Expõe API REST
  - Interface simples para acionamento manual

 Toda a regra de negócio de dados fica concentrada no **banco**, simulando um cenário real de implantação e integração entre sistemas.

---

##  Estrutura do Projeto

```
backend/
├── app/
├── routes/
├── resources/views/
├── public/
├── composer.json
└── .env.example

database/sql/
├── 01_base.sql      # Tabelas base + dados de origem
├── 03_views.sql     # Views de tratamento e padronização
└── 05_sync.sql      # Tabelas finais + sincronização
```

---

## Banco de Dados (PostgreSQL)

### 1 Criar o banco

```sql
CREATE DATABASE implantador;
```

### 2 Executar os scripts SQL (na ordem)

```sql
01_base.sql
03_views.sql
05_sync.sql
```

---

##  Backend (Laravel)

### Requisitos

- PHP 8+
- Composer
- PostgreSQL

### Instalação

```bash
cd backend
composer install
copy .env.example .env
php artisan key:generate
php artisan serve
```

Servidor disponível em:

```
http://127.0.0.1:8000
```

---

##  Rotas da API

###  Sincronizar produtos
```
POST /api/sincronizar/produtos
```

###  Sincronizar preços
```
POST /api/sincronizar/precos
```

###  Listar produtos + preços
```
GET /api/produtos/lista
```

---

##  Validação no Banco

```sql
SELECT COUNT(*) FROM produto_insercao;
SELECT COUNT(*) FROM preco_insercao;

SELECT
  p.prod_cod,
  p.prod_nome,
  pr.prc_valor
FROM produto_insercao p
LEFT JOIN preco_insercao pr
  ON pr.prc_cod_prod = p.prod_cod;
```

---

##  Segurança

- O arquivo `.env` não é versionado
- Dependências (`vendor/`) não são versionadas
- Nenhuma credencial sensível é exposta no repositório
