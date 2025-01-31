import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/course_provider.dart';
import 'package:provider/provider.dart';
import 'AcademicScheduleScreen.dart';
import 'Course.dart';

class YourWayScreen extends StatefulWidget {
  const YourWayScreen({super.key});

  @override
  _YourWayScreenState createState() => _YourWayScreenState();
}

class _YourWayScreenState extends State<YourWayScreen> {
  final _formKey = GlobalKey<FormState>();
  String courseName = "";
  int courseHours = 2;
  String sectionNumber = "";
  String lectureHallNumber = "";
  List<String> selectedDays = [];
  Map<String, Map<String, TimeOfDay>> courseTimes = {
    "Sunday": {
      "start": TimeOfDay(hour: 9, minute: 0),
      "end": TimeOfDay(hour: 11, minute: 0)
    },
    "Monday": {
      "start": TimeOfDay(hour: 9, minute: 0),
      "end": TimeOfDay(hour: 11, minute: 0)
    },
    "Tuesday": {
      "start": TimeOfDay(hour: 9, minute: 0),
      "end": TimeOfDay(hour: 11, minute: 0)
    },
    "Wednesday": {
      "start": TimeOfDay(hour: 9, minute: 0),
      "end": TimeOfDay(hour: 11, minute: 0)
    },
    "Thursday": {
      "start": TimeOfDay(hour: 9, minute: 0),
      "end": TimeOfDay(hour: 11, minute: 0)
    },
  };
  bool _isLoading = false;

  void _selectTime(String day, String timeType) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: courseTimes[day]?[timeType] ?? TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        courseTimes[day]?[timeType] = picked;
      });
    }
  }

  void _addCourse() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      for (var day in selectedDays) {
        final startTime = courseTimes[day]!['start']!;
        final endTime = courseTimes[day]!['end']!;
        if (startTime.hour > endTime.hour ||
            (startTime.hour == endTime.hour &&
                startTime.minute >= endTime.minute)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Start time must be before end time for $day.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        context.read<CourseProvider>().courses.add(Course(
              name: courseName,
              hours: courseHours,
              selectedDays: List.from(selectedDays),
              courseTimes: Map.from(courseTimes),
              sectionNumber: sectionNumber,
              lectureHallNumber: lectureHallNumber,
            ));
        courseName = "";
        courseHours = 2;
        sectionNumber = "";
        lectureHallNumber = "";
        selectedDays.clear();
        courseTimes = {
          "Sunday": {
            "start": TimeOfDay(hour: 9, minute: 0),
            "end": TimeOfDay(hour: 11, minute: 0)
          },
          "Monday": {
            "start": TimeOfDay(hour: 9, minute: 0),
            "end": TimeOfDay(hour: 11, minute: 0)
          },
          "Tuesday": {
            "start": TimeOfDay(hour: 9, minute: 0),
            "end": TimeOfDay(hour: 11, minute: 0)
          },
          "Wednesday": {
            "start": TimeOfDay(hour: 9, minute: 0),
            "end": TimeOfDay(hour: 11, minute: 0)
          },
          "Thursday": {
            "start": TimeOfDay(hour: 9, minute: 0),
            "end": TimeOfDay(hour: 11, minute: 0)
          },
        };
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "$courseName" added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _viewSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2B666E),
            title: Text('Academic Schedule'),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: AcademicScheduleScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B666E),
        title: const Text(
          'Your Way',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text(
                  "Enter the course details to create your schedule:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B666E),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildCard(
                        title: "Enter Course Name:",
                        child: _buildTextField(
                          label: "Course Name",
                          onSaved: (value) => courseName = value!,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter course name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCard(
                        title: "Enter Number of Hours:",
                        child: _buildDropdown<int>(
                          value: courseHours,
                          items: [2, 3, 4, 6, 8],
                          onChanged: (value) {
                            setState(() {
                              courseHours = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCard(
                        title: "Select Course Days:",
                        child: DropdownButton<String>(
                          value:
                              selectedDays.isNotEmpty ? selectedDays[0] : null,
                          items: courseTimes.keys
                              .map((day) => DropdownMenuItem<String>(
                                    value: day,
                                    child: Text(day),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null &&
                                !selectedDays.contains(value)) {
                              setState(() {
                                selectedDays.add(value);
                              });
                            }
                          },
                          hint: const Text("Select days"),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCard(
                        title: "Course Details",
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: "Section Number",
                                    onSaved: (value) => sectionNumber = value!,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter section number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    label: "Lecture Hall Number",
                                    onSaved: (value) =>
                                        lectureHallNumber = value!,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter lecture hall number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (var day in selectedDays)
                        _buildCard(
                          title: "$day Schedule",
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Start: ${courseTimes[day]!['start']!.format(context)}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: const Icon(Icons.access_time),
                                onTap: () => _selectTime(day, 'start'),
                              ),
                              ListTile(
                                title: Text(
                                  "End: ${courseTimes[day]!['end']!.format(context)}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: const Icon(Icons.access_time),
                                onTap: () => _selectTime(day, 'end'),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),
                      _buildElevatedButton("Add Course", _addCourse),
                      const SizedBox(height: 20),
                      _buildElevatedButton("View Schedule", _viewSchedule),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (context.read<CourseProvider>().courses.isNotEmpty)
                  Column(
                    children: [
                      const Text(
                        " Courses:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B666E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...context
                          .read<CourseProvider>()
                          .courses
                          .map((course) => Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Course: ${course.name}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF2B666E),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                context
                                                    .read<CourseProvider>()
                                                    .courses
                                                    .remove(course);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Course "${course.name}" deleted!'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text('Hours: ${course.hours}'),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Section Number: ${course.sectionNumber}'),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Lecture Hall Number: ${course.lectureHallNumber}'),
                                      const SizedBox(height: 10),
                                      for (var day in course.selectedDays)
                                        Text(
                                          '$day: ${course.courseTimes[day]!['start']!.format(context)} - ${course.courseTimes[day]!['end']!.format(context)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                    ],
                  ),
              ],
            ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B666E),
                ),
              ),
            if (title.isNotEmpty) const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: const Color(0xFF2B666E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButton<T>(
      value: value,
      items: items
          .map((item) =>
              DropdownMenuItem<T>(value: item, child: Text(item.toString())))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: const Color(0xFF2B666E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
