<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

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

    public function storeSelection(Request $request)
    {
        $request->validate([
            'product_ids' => 'required|array',
            'product_ids.*' => 'integer|exists:products,id',
        ]);

        $user = Auth::user();

        // Aqui vamos apenas salvar os IDs como JSON num campo fictício
        // Em produção, talvez seja uma tabela com relacionamento

        $user->selected_products = json_encode($request->product_ids);
        $user->save();

        return response()->json(['message' => 'Seleção salva com sucesso']);
    }
}
