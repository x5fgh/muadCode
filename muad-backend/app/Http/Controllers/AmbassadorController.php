<?php

namespace App\Http\Controllers;
use App\Models\Ambassador;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


class AmbassadorController extends Controller
{
    public function getAmbassadors(Request $request)
    {

        $ambassadors = Ambassador::all();
        return response()->json($ambassadors, 200);

    }

// s
    public function createAmbassador(Request $request){

        $ambassador = Ambassador::create([
            'name' => $request->name,
            'college' => $request->college,
            'specialization' => $request->specialization,
            'gender' => $request->gender,
            'twitter_link' => $request->twitter_link,
            'linkedin_link' => $request->linkedin_link,
        ]);

        return response()->json($ambassador, 201);
    }
    

}
