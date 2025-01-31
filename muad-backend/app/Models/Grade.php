<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Grade extends Model
{
    use HasFactory;

    // إضافة 'type' للحفاظ على قابلية التعيين للحقل
    protected $fillable = ['course_name', 'credit_hours', 'grade', 'type'];
}
