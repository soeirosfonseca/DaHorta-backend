<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Delivery extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'basket_type',
        'delivered_at',
        'picked_up',
    ];

    protected $casts = [
        'delivered_at' => 'date',
        'picked_up' => 'boolean',
    ];
}
