<?php

// app/Http/Controllers/DeliveryController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Delivery;
use Illuminate\Support\Facades\Auth;

class DeliveryController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        $deliveries = Delivery::where('user_id', $user->id)
            ->orderByDesc('delivered_at')
            ->get();

        return response()->json($deliveries);
    }
}
