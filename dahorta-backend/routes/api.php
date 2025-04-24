<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Controllers
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\DeliveryController;
use App\Http\Controllers\SubscriptionController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\PointController; // Assume-se que o nome correto seja PointController
use App\Http\Controllers\ProductSelectionController;


// Rotas públicas
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Rotas protegidas
Route::middleware('auth:sanctum')->group(function () {
    
    // Usuário
    Route::get('/user', [UserController::class, 'profile']);
    Route::put('/user', [UserController::class, 'update']);

    // Perfil
    Route::get('/user', [ProfileController::class, 'profile']);
    Route::put('/user', [ProfileController::class, 'update']);

    // Produtos
    Route::get('/produtos', [ProductController::class, 'index']);

    // Pontos de coleta
    Route::get('/pontos-coleta', [PointController::class, 'index']);

    // Entregas
    Route::get('/entregas', [DeliveryController::class, 'index']);

    Route::get('/user/entregas', [DeliveryController::class, 'index']);

    // Assinaturas
    Route::post('/assinatura', [SubscriptionController::class, 'criar']);
    Route::get('/assinatura/status', [SubscriptionController::class, 'status']);

    // Notificações (se for usada)
    Route::get('/notificacoes', [NotificationController::class, 'index']);

    // Logout
    Route::post('/logout', [AuthController::class, 'logout']);

    // SELEÇÃO DE PRODUTOS
    Route::post('/selected-products', [ProductSelectionController::class, 'store']);
    
    // Rotas específicas para agricultores
    Route::middleware('role:agricultor')->group(function () {
        Route::post('/produtos', [ProductController::class, 'store']);
        Route::put('/produtos/{id}', [ProductController::class, 'update']);
        Route::delete('/produtos/{id}', [ProductController::class, 'destroy']);
    });
});
