<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    public function index()
    {
        return response()->json(Product::all());
    }

    public function store(Request $request)
    {
        // Apenas agricultores podem cadastrar
        if ($request->user()->role !== 'farmer') {
            return response()->json(['error' => 'Apenas agricultores podem cadastrar produtos.'], 403);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'unit' => 'required|string|max:50',
            'available_quantity' => 'required|integer|min:1',
        ]);

        $product = Product::create([
            'user_id' => $request->user()->id,
            'name' => $request->name,
            'price' => $request->price,
            'unit' => $request->unit,
            'available_quantity' => $request->available_quantity,
        ]);

        return response()->json([
            'message' => 'Produto cadastrado com sucesso.',
            'product' => $product,
        ]);
    }
}
