<?php

// app/Http/Controllers/ProductSelectionController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ProductSelection;
use Illuminate\Support\Facades\Auth;

class ProductSelectionController extends Controller
{
    public function store(Request $request)
    {
        $user = Auth::user();

        $validated = $request->validate([
            'product_ids' => 'required|array',
            'product_ids.*' => 'exists:products,id',
        ]);

        $weekRef = now()->format('o-\WW'); // exemplo: 2025-W15

        // Remove seleções anteriores desta semana
        ProductSelection::where('user_id', $user->id)
            ->where('week_reference', $weekRef)
            ->delete();

        // Insere os novos produtos selecionados
        foreach ($validated['product_ids'] as $productId) {
            ProductSelection::create([
                'user_id' => $user->id,
                'product_id' => $productId,
                'week_reference' => $weekRef,
            ]);
        }

        return response()->json(['message' => 'Seleção de produtos salva com sucesso']);
    }
}
