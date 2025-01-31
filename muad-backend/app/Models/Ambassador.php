<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ambassador extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'college', 'specialization', 'gender', 'twitter_link', 'linkedin_link'];
}
