<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\CollectionPoint;

class CollectionPointController extends Controller
{
    public function index()
    {
        return response()->json(CollectionPoint::all());
    }
}
