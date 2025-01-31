import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'ProfileScreen.dart';
import 'ScheduleScreen.dart';

double convertDegreeToPoint(String degree) {
  switch (degree) {
    case 'A+':
      return 4.00;
    case 'A':
      return 3.75;
    case 'B+':
      return 3.50;
    case 'B':
      return 3.00;
    case 'C+':
      return 2.50;
    case 'C':
      return 2.00;
    case 'D+':
      return 1.50;
    case 'D':
      return 1.00;
    case 'F':
    default:
      return 0.0;
  }
}

class Course {
  final int id;
  final String name;
  final int hours;
  final String grade;

  Course({
    required this.name,
    required this.hours,
    required this.grade,
    required this.id,
  });

  double get points => hours * convertDegreeToPoint(grade);

  Course copyWith({
    String? name,
    int? hours,
    String? grade,
    double? points,
  }) =>
      Course(
        name: name ?? this.name,
        hours: hours ?? this.hours,
        grade: grade ?? this.grade,
        id: id,
      );

  @override
  String toString() =>
      'Course: id: $id, name:$name, hours: $hours, grade: $grade';

  @override
  bool operator ==(Object other) => other is Course && id == other.id;

  @override
  int get hashCode => Object.hashAll([name, id]);
}

class GPACalculatorScreen extends StatefulWidget {
  const GPACalculatorScreen({super.key});

  @override
  _GPACalculatorScreenState createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> {
  int _currentIndex = 0;

  final previousGPAController = TextEditingController();
  final recordedHoursController = TextEditingController();
  final hoursPassedController = TextEditingController();

  @override
  void dispose() {
    previousGPAController.dispose();
    recordedHoursController.dispose();
    hoursPassedController.dispose();
    super.dispose();
  }

  List<Course> courses = [];

  double semesterGPA = 0.0;
  double cumulativeGPA = 0.0;

  final List<String> grades = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];

  String expectedGPA = "0.0";

  @override
  Widget build(BuildContext context) {
    print('courses length: ${courses.length}');
    print('courses: $courses');
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B666E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:
            const Text('GPA Calculator', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Image.asset(
                'assets/images/Logo.png',
                height: screenHeight * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: previousGPAController,
                          decoration: _inputDecoration('Previous GPA'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: TextField(
                          controller: recordedHoursController,
                          decoration: _inputDecoration('Recorded Hours'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: hoursPassedController,
                          decoration: _inputDecoration('Hours Passed'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose Grade',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B666E),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Form(
                    child: Column(
                      children: [
                        ...courses.map((course) {
                          return _buildCourseRow(
                              course, screenHeight, screenWidth);
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildAddCourseButton(screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  _buildBottomSection(screenHeight),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(selectedIndex: 1)),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(selectedIndex: 2)),
            );
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2B666E),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildAddCourseButton(double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              courses.add(
                Course(
                  name: '',
                  hours: 0,
                  grade: '',
                  id: (courses.length + 1),
                ),
              );
            });
          },
          icon: Icon(
            Icons.add,
            color: const Color(0xFF006D68),
            size: screenWidth * 0.06,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseRow(
      Course course, double screenHeight, double screenWidth) {
    return Padding(
      key: ValueKey(course.id),
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Row(
            children: [
              Expanded(
                child: _buildTextFieldName(course, 'Course name'),
              ),
              SizedBox(width: screenWidth * 0.02),
              SizedBox(
                width: screenWidth * 0.2,
                child:
                    _buildTextFieldHours(course, 'Hours', TextInputType.number),
              ),
              SizedBox(width: screenWidth * 0.02),
              SizedBox(
                width: screenWidth * 0.3,
                child: _buildDropdown(course),
              ),
              SizedBox(width: screenWidth * 0.02),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    courses.remove(course);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldName(Course course, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            courses[courses.indexOf(course)] = course.copyWith(
              name: value,
            );
          });
        }
      },
    );
  }

  Widget _buildTextFieldHours(Course course, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            courses[courses.indexOf(course)] = course.copyWith(
              hours: int.tryParse(value) ?? 0,
            );
          });
        }
      },
    );
  }

  Widget _buildDropdown(Course course) {
    return DropdownButtonFormField<String>(
      items: grades
          .map((grade) => DropdownMenuItem(
                value: grade,
                child: Text(grade),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          courses[courses.indexOf(course)] = course.copyWith(
            grade: value ?? '',
          );
        });
      },
      decoration: _inputDecoration('Grade'),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildBottomSection(double screenHeight) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Expected GPA',
            style: TextStyle(
              fontSize: screenHeight * 0.025,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B666E),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 165,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF2B666E),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Semester GPA: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '${semesterGPA.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 165,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF2B666E),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'cumulative GPA: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '${cumulativeGPA.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        SizedBox(
          height: 48.0,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              var totalPoints = 0.0;
              for (var course in courses) {
                totalPoints += course.points;
              }

              var totalHourse = 0.0;
              for (var course in courses) {
                totalHourse += course.hours;
              }

              final semesterResult = totalPoints / totalHourse;
              print('total points: $totalPoints');
              print('total hours: $totalHourse');
              print(semesterResult);

              final double preivousGPA =
                  double.tryParse(previousGPAController.text) ?? 0.0;
              final double recordedHours =
                  double.tryParse(recordedHoursController.text) ?? 0.0;
              final int hoursPassed =
                  int.tryParse(hoursPassedController.text) ?? 0;

              final totalHours = recordedHours + hoursPassed;

              final cumulativeResult = ((preivousGPA * hoursPassed) +
                      (semesterResult * recordedHours)) /
                  totalHours;

              setState(() {
                semesterGPA = semesterResult;
                cumulativeGPA = cumulativeResult;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B666E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Calculate the rate',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
