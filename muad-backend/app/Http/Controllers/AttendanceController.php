<?php

namespace App\Http\Controllers;
use App\Models\Attendance;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AttendanceController extends Controller
{
    
 
    public function calculateAttendance(Request $request){
        $attendanceRecords = Attendance::all(); // جلب جميع سجلات الغياب
        $totalAbsences = 0;
        foreach ($attendanceRecords as $attendance) {
            $totalAbsences += $attendance->absence_count; } 
        // فرضًا أن الغياب المحدد (مثلاً 15) هو الحد الأقصى للغياب قبل التحذير
        if ($totalAbsences > 15) {            return response()->json(['message' => 'تحذير! أنت قريب من الحرمان.'], 400);}
        return response()->json(['total_absences' => $totalAbsences], 200);

    }

   

}
