<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>VersoTech – Sincronização</title>

    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
</head>
<body>

<div class="container">

    <h1>VersoTech – Sincronização de Dados</h1>

    <div class="actions">
        <button onclick="syncProdutos()">Sincronizar Produtos</button>
        <button onclick="syncPrecos()">Sincronizar Preços</button>
    </div>

    <div id="status" class="status info">Pronto.</div>

    <table>
        <thead>
            <tr>
                <th>Código</th>
                <th>Produto</th>
                <th>Preço</th>
            </tr>
        </thead>
        <tbody id="tabela">
            <tr>
                <td colspan="3">Carregando...</td>
            </tr>
        </tbody>
    </table>

</div>

<script>
document.addEventListener('DOMContentLoaded', () => {

    const statusEl = document.getElementById('status');
    const tbody = document.getElementById('tabela');

    function setStatus(msg, type = 'info') {
        if (!statusEl) return;
        statusEl.textContent = msg;
        statusEl.className = 'status ' + type;
    }

    async function request(url, method = 'GET') {
        const res = await fetch(url, {
            method,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            }
        });

        const text = await res.text();
        let body;
        try {
            body = JSON.parse(text);
        } catch {
            body = { message: text };
        }

        if (!res.ok) {
            throw new Error(`${res.status} - ${body.message || 'Erro desconhecido'}`);
        }

        return body;
    }

    async function carregar() {
        try {
            setStatus('Carregando lista...', 'loading');
            const dados = await request('/api/produtos/lista', 'GET');

            tbody.innerHTML = '';

            if (!Array.isArray(dados) || dados.length === 0) {
                tbody.innerHTML = `<tr><td colspan="3">Nenhum dado encontrado.</td></tr>`;
                setStatus('Lista carregada (vazia).', 'info');
                return;
            }

            dados.forEach(p => {
                tbody.innerHTML += `
                    <tr>
                        <td>${p.prod_cod ?? '-'}</td>
                        <td>${p.prod_nome ?? '-'}</td>
                        <td>${p.prc_valor ?? '-'}</td>
                    </tr>
                `;
            });

            setStatus(`Lista carregada ✅ (${dados.length} itens)`, 'success');

        } catch (e) {
            setStatus('Erro ao carregar lista: ' + e.message, 'error');
        }
    }

    async function syncProdutos() {
        try {
            setStatus('Sincronizando produtos...', 'loading');
            await request('/api/sincronizar/produtos', 'POST');
            setStatus('Produtos sincronizados com sucesso ✅', 'success');
            await carregar();
        } catch (e) {
            setStatus('Erro ao sincronizar produtos: ' + e.message, 'error');
        }
    }

    async function syncPrecos() {
        try {
            setStatus('Sincronizando preços...', 'loading');
            await request('/api/sincronizar/precos', 'POST');
            setStatus('Preços sincronizados com sucesso ✅', 'success');
            await carregar();
        } catch (e) {
            setStatus('Erro ao sincronizar preços: ' + e.message, 'error');
        }
    }


    window.syncProdutos = syncProdutos;
    window.syncPrecos = syncPrecos;

    carregar();
});
</script>

</body>
</html>
