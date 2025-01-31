<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GradeController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\AmbassadorController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// حساب المعدل
Route::post('/calculate-gpa', [GradeController::class, 'calculateGPA']);
//  حساب الغياب
Route::post('calculate-attendance', [AttendanceController::class, 'calculateAttendance']);

// // قائمة السفراء
Route::get('ambassadors', [AmbassadorController::class, 'getAmbassadors']);
Route::post('create-ambassador', [AmbassadorController::class, 'createAmbassador']);

// الكورس
