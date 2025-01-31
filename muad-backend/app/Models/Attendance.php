<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
      use HasFactory;
    protected $fillable = ['course_name', 'credit_hours', 'excused', 'absence_count'];
}
