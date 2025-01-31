import 'package:flutter/material.dart';

class Course {
  final String name;
  final int hours;
  final List<String> selectedDays;
  final Map<String, Map<String, TimeOfDay>> courseTimes;
  final String sectionNumber;
  final String lectureHallNumber;

  Course({
    required this.name,
    required this.hours,
    required this.selectedDays,
    required this.courseTimes,
    required this.sectionNumber,
    required this.lectureHallNumber,
  });
}
