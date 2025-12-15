<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class SyncController extends Controller
{
    private function runSqlFile(string $relativePath): void
    {
        $path = base_path($relativePath);
        $sql = file_get_contents($path);

        // split by ; to avoid driver issues with multi-statements
        $statements = array_filter(array_map('trim', explode(';', $sql)));

        DB::beginTransaction();
        try {
            foreach ($statements as $stmt) {
                if ($stmt !== '') DB::statement($stmt);
            }
            DB::commit();
        } catch (\Throwable $e) {
            DB::rollBack();
            throw $e;
        }
    }

    public function syncProdutos()
    {
        $this->runSqlFile('..\\database\\sql\\05_sync.sql');
        return response()->json(['status' => 'Produtos sincronizados com sucesso']);
    }

    public function syncPrecos()
    {
        $this->runSqlFile('..\\database\\sql\\05_sync.sql');
        return response()->json(['status' => 'Preços sincronizados com sucesso']);
    }

    public function listaProdutos()
    {
        $dados = DB::table('produto_insercao as p')
            ->leftJoin('preco_insercao as pr', 'pr.prc_cod_prod', '=', 'p.prod_cod')
            ->select(
                'p.prod_cod',
                'p.prod_nome',
                'p.prod_cat',
                'p.prod_subcat',
                'pr.prc_valor',
                'pr.prc_moeda'
            )
            ->orderBy('p.prod_nome')
            ->get();

        return response()->json($dados);
    }
}
