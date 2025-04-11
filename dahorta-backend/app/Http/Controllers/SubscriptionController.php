<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Subscription;

class SubscriptionController extends Controller
{
    public function subscribe(Request $request)
    {
        $request->validate([
            'plan' => 'required|in:simple,premium,master',
        ]);

        $user = $request->user();

        // Cria ou atualiza assinatura
        $subscription = Subscription::updateOrCreate(
            ['user_id' => $user->id],
            ['plan' => $request->plan]
        );

        return response()->json([
            'message' => 'Assinatura atualizada com sucesso.',
            'subscription' => $subscription,
        ]);
    }

    public function getSubscription(Request $request)
    {
        $subscription = Subscription::where('user_id', $request->user()->id)->first();

        if (!$subscription) {
            return response()->json(['message' => 'Nenhuma assinatura encontrada.'], 404);
        }

        return response()->json(['subscription' => $subscription]);
    }
}
