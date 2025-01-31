<?php

namespace App\Http\Controllers;
use App\Models\Course;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class courseController extends Controller
{


    public function addCourse(Request $request){

        $course = Course::create([
            'name' => $request->name,
            'credit_hours' => $request->credit_hours,
            'grade' => $request->grade,
        ]);
        return response()->json($course, 201);
    }


}
