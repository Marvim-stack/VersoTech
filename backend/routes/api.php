<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\SyncController;

Route::post('/sincronizar/produtos', [SyncController::class, 'syncProdutos']);
Route::post('/sincronizar/precos', [SyncController::class, 'syncPrecos']);
Route::get('/produtos/lista', [SyncController::class, 'listaProdutos']);
