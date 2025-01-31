<?php

namespace App\Http\Controllers;

use App\Models\Grade;
use Illuminate\Http\Request;

class GradeController extends Controller
{
    // دالة حساب المعدل
    public function calculateGPA(Request $request)
    {
        // الحصول على نوع المعدل من الطلب (فصلي أو تراكمي)
        $type = $request->input('type');

        // التحقق إذا كان النوع صحيح (فصلي أو تراكمي)
        if (!in_array($type, ['fossil', 'cumulative'])) {
            return response()->json(['message' => 'النوع غير صحيح. يجب أن يكون "فصلي" أو "تراكمي".'], 400);
        }

        // جلب جميع البيانات من جدول الدرجات حيث النوع يتطابق مع النوع المطلوب
        $grades = Grade::where('type', $type)->get();
        
        // إذا كانت لا توجد مواد مسجلة
        if ($grades->isEmpty()) {
            return response()->json(['message' => 'لا توجد مواد مسجلة بهذا النوع.'], 400);
        }

        $totalCredits = 0;
        $totalPoints = 0;

        // حساب النقاط الإجمالية والوحدات
        foreach ($grades as $grade) {
            $points = $this->gradeToPoints($grade->grade);  // تحويل التقدير إلى نقاط
            $totalCredits += $grade->credit_hours;  // إضافة وحدات المادة
            $totalPoints += $points * $grade->credit_hours;  // جمع نقاط المواد
        }

        // التحقق إذا كانت الوحدات هي 0 (لا يمكن حساب المعدل)
        if ($totalCredits == 0) {
            return response()->json(['message' => 'لا توجد وحدات مسجلة أو أن البيانات غير صحيحة.'], 400);
        }

        // حساب المعدل
        $gpa = $totalPoints / $totalCredits;

        // العودة بالنتيجة مع تقريب المعدل
        return response()->json(['gpa' => round($gpa, 2)], 200);
    }

    // تحويل التقدير إلى نقاط
    private function gradeToPoints($grade)
    {
        switch ($grade) {
            case 'A+': return 4.0;
            case 'A': return 4.0;
            case 'B+': return 3.5;
            case 'B': return 3.0;
            case 'C+': return 2.5;
            case 'C': return 2.0;
            case 'D+': return 1.5;
            case 'D': return 1.0;
            case 'F': return 0.0;
            default: return 0.0;
        }
    }
}