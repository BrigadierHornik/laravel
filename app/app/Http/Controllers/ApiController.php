<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\JsonResponse;
use App\Models\User;


class ApiController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $credentials = $request->only(keys: ['username', 'password']);

        if (Auth::attempt(credentials: $credentials)) {
            $user = Auth::user();
            
            $token = $user->createToken(name: 'auth-token')->plainTextToken;
            return response()->json(data: ['message' => 'Login successful', 'token' => $token], status: 200);
        }

        return response()->json(data: ['message' => 'Invalid credentials'], status: 401);
    }
}
