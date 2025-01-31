<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('Grade', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // اسم المقرر
            $table->integer('credit_hours'); // عدد ساعات المقرر
            $table->integer("user_id"); // القريد
           
           
          
        });
    }

    /**
     * Reverse the migrations.
     */

public function down()
{
    Schema::table('grades', function (Blueprint $table) {
        $table->dropColumn('type'); // حذف الحقل إذا تم التراجع عن الميجريشن
    });
}
};

