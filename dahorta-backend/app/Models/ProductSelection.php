<?php

// app/Models/ProductSelection.php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ProductSelection extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'product_id',
        'week_reference',
    ];
}
