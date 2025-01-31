import 'package:flutter/material.dart';
import 'Course.dart'; // استيراد الكلاس Course

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners(); // إشعار واجهة المستخدم بالتحديث
  }

  void removeCourse(Course course) {
    _courses.remove(course);
    notifyListeners(); // إشعار واجهة المستخدم بالتحديث
  }
}
