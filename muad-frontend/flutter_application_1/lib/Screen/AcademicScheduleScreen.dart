import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/course_provider.dart';
import 'package:provider/provider.dart';
import 'Course.dart';

class AcademicScheduleScreen extends StatelessWidget {
  const AcademicScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, value, child) {
        // استخدام MediaQuery للحصول على حجم الشاشة
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // ضبط عرض وارتفاع الخلايا بناءً على حجم الشاشة
        final cellWidth = screenWidth / 6; // 6 أعمدة
        final cellHeight = screenHeight / 12; // 12 صفًا

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: cellWidth * 6,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: {
                  for (int i = 0; i < 6; i++) i: FixedColumnWidth(cellWidth),
                },
                children: [
                  _buildHeaderRow(context, cellHeight),
                  ..._buildScheduleRows(context, cellHeight, value.courses),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _buildHeaderRow(BuildContext context, double cellHeight) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFF006770)),
      children: [
        _buildTableCell(context, 'Time', isHeader: true, height: cellHeight),
        _buildTableCell(context, 'Sunday', isHeader: true, height: cellHeight),
        _buildTableCell(context, 'Monday', isHeader: true, height: cellHeight),
        _buildTableCell(context, 'Tuesday', isHeader: true, height: cellHeight),
        _buildTableCell(context, 'Wednesday',
            isHeader: true, height: cellHeight),
        _buildTableCell(context, 'Thursday',
            isHeader: true, height: cellHeight),
      ],
    );
  }

  List<TableRow> _buildScheduleRows(
      BuildContext context, double cellHeight, List<Course> courses) {
    final List<String> times = [
      '8:00- 8:50',
      '9:00- 9:50',
      '10:00- 10:50',
      '11:00- 11:50',
      '12:00- 12:50',
      '1:00- 1:50',
      '2:00- 2:50',
      '3:00- 3:50',
      '4:00- 4:50',
      '5:00- 5:50',
    ];

    return times.map((time) {
      return TableRow(
        children: [
          _buildTableCell(context, time, height: cellHeight),
          ...['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']
              .map((day) {
            final course = _getCourseForDayAndTime(day, time, courses);
            return _buildCourseCell(context, course, height: cellHeight);
          }).toList(),
        ],
      );
    }).toList();
  }

  Course? _getCourseForDayAndTime(
      String day, String time, List<Course> courses) {
    final timeParts = time.split('-');
    final tableStartTime = TimeOfDay(
      hour: int.parse(timeParts[0].split(':')[0]),
      minute: int.parse(timeParts[0].split(':')[1]),
    );

    final tableEndTime = TimeOfDay(
      hour: int.parse(timeParts[1].split(':')[0]),
      minute: int.parse(timeParts[1].split(':')[1]),
    );

    for (final course in courses) {
      if (!course.selectedDays.contains(day)) continue;

      final courseStartTime = course.courseTimes[day]!['start']!;
      final courseEndTime = course.courseTimes[day]!['end']!;

      if ((tableStartTime.hour > courseStartTime.hour ||
              (tableStartTime.hour == courseStartTime.hour &&
                  tableStartTime.minute >= courseStartTime.minute)) &&
          (tableEndTime.hour < courseEndTime.hour ||
              (tableEndTime.hour == courseEndTime.hour &&
                  tableEndTime.minute <= courseEndTime.minute))) {
        return course;
      }
    }

    return null;
  }

  Widget _buildCourseCell(BuildContext context, Course? course,
      {double height = 50.0}) {
    return GestureDetector(
      onTap: () {
        if (course != null) {
          _showCourseDetails(context, course);
        }
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        color: course != null ? const Color(0xFFB18C43) : Colors.white,
        child: Text(
          course?.name ?? '',
          style: TextStyle(
            color: course != null ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showCourseDetails(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            course.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006770),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Hours: ${course.hours}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Section Number: ${course.sectionNumber}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Lecture Hall Number: ${course.lectureHallNumber}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                for (var day in course.selectedDays)
                  Text(
                    '$day: ${course.courseTimes[day]!['start']!.format(context)} - ${course.courseTimes[day]!['end']!.format(context)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFF006770),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableCell(BuildContext context, String text,
      {bool isHeader = false, double height = 50.0}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(6.0),
      alignment: Alignment.center,
      color: isHeader ? const Color(0xFF006770) : Colors.white,
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? Colors.white : Colors.black,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 12, // حجم الخط مناسب للرأس
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
