<!doctype html>
<html lang="pt-br">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VersoTech - Teste Técnico</title>
</head>
<body style="font-family: Arial; padding: 20px;">
  <h2>Sincronização</h2>

  <button onclick="sync('/api/sincronizar/produtos')">Sincronizar Produtos</button>
  <button onclick="sync('/api/sincronizar/precos')">Sincronizar Preços</button>

  <h2>Produtos + Preços</h2>
  <pre id="out" style="background:#f5f5f5; padding:10px; white-space:pre-wrap;"></pre>

  <script>
    async function sync(url) {
      document.getElementById('out').textContent = 'Sincronizando...';
      await fetch(url, { method: 'POST' });
      await load();
    }

    async function load() {
      const res = await fetch('/api/produtos/lista');
      const data = await res.json();
      document.getElementById('out').textContent = JSON.stringify(data, null, 2);
    }

    load();
  </script>
</body>
</html>
