<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ApiController;

Route::post(uri: '/login', action: [ApiController::class, 'login']);