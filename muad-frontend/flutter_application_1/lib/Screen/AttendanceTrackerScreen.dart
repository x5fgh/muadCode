import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/HomeScreen.dart';
import 'package:flutter_application_1/Screen/ProfileScreen.dart';
import 'AcademicScheduleScreen.dart';

class AttendanceTrackerScreen extends StatefulWidget {
  const AttendanceTrackerScreen({super.key});

  @override
  _AttendanceTrackerScreenState createState() =>
      _AttendanceTrackerScreenState();
}

class _AttendanceTrackerScreenState extends State<AttendanceTrackerScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    AcademicScheduleScreen(),
    ProfileScreen(),
  ];

  List<Map<String, dynamic>> courses = [
    {
      'name': 'HCI course',
      'hours': 6,
      'absent': 5,
      'status': 'UnExcused',
      'isEditable': true,
      'isWarning': false,
      'isCloseToBan': false,
      'isFirstWarning': false,
    },
    {
      'name': 'ERP course',
      'hours': 3,
      'absent': 8,
      'status': 'Excused',
      'isEditable': true,
      'isWarning': false,
      'isCloseToBan': false,
      'isFirstWarning': false,
    },
  ];

  final List<String> statuses = ['Excused', 'UnExcused'];
  bool hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Tracker',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B666E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.add, color: Color(0xFF2B666E), size: 30),
                  onPressed: _addNewRow,
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Color(0xFF2B666E), size: 30),
                  onPressed: _deleteLastRow,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                double tableWidth = constraints.maxWidth;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(
                        color: const Color(0xFF2B666E), width: 1),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FixedColumnWidth(tableWidth * 0.3),
                      1: FixedColumnWidth(tableWidth * 0.2),
                      2: FixedColumnWidth(tableWidth * 0.2),
                      3: FixedColumnWidth(tableWidth * 0.3),
                    },
                    children: [
                      TableRow(
                        decoration:
                            const BoxDecoration(color: Color(0xFF2B666E)),
                        children: [
                          _buildTableHeader('Name course'),
                          _buildTableHeader('Hours'),
                          _buildTableHeader('Absent'),
                          _buildTableHeader('Status'),
                          const SizedBox(), // For the delete column
                        ],
                      ),
                      ...courses.map((course) {
                        return TableRow(
                          children: [
                            _buildEditableCell(course, 'name'),
                            _buildEditableCell(course, 'hours'),
                            _buildEditableCell(course, 'absent'),
                            _buildDropdownCell(course),
                            _buildDeleteButton(course), // Add delete button
                          ],
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: hasUnsavedChanges ? _saveData : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasUnsavedChanges
                        ? const Color(0xFF2B666E)
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _enableEditing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B666E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // New row for displaying course data horizontally at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: courses.map((course) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: course['isCloseToBan']
                          ? Colors.red[100]
                          : course['isFirstWarning']
                              ? Colors.orange[100]
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${course['name']} (${course['absent']} hrs absent)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: course['isCloseToBan']
                                ? Colors.red
                                : course['isFirstWarning']
                                    ? Colors.orange
                                    : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${course['status']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _screens[index]),
          );
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

  void _addNewRow() {
    setState(() {
      courses.add({
        'name': '',
        'hours': 0,
        'absent': 0,
        'status': statuses[0],
        'isEditable': true,
        'isWarning': false,
        'isCloseToBan': false,
        'isFirstWarning': false,
      });
      hasUnsavedChanges = true;
    });
  }

  void _deleteLastRow() {
    setState(() {
      if (courses.isNotEmpty) {
        courses.removeLast(); // حذف آخر صف من القائمة
        hasUnsavedChanges = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Last row deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _saveData() {
    _calculateWarnings();
    setState(() {
      for (var course in courses) {
        course['isEditable'] = false;
      }
      hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _enableEditing() {
    setState(() {
      for (var course in courses) {
        course['isEditable'] = true;
      }
      hasUnsavedChanges = true;
    });
  }

  void _calculateWarnings() {
    setState(() {
      for (var course in courses) {
        int hours = course['hours'];
        int absent = course['absent'];
        String status = course['status'];

        int firstWarningThreshold = 0;
        int banThreshold = 0;

        if (hours == 2) {
          firstWarningThreshold = status == 'Excused' ? 6 : 4;
          banThreshold = status == 'Excused' ? 6 : 4;
        } else if (hours == 3) {
          firstWarningThreshold = status == 'Excused' ? 8 : 5;
          banThreshold = status == 'Excused' ? 9 : 8;
        } else if (hours == 4) {
          firstWarningThreshold = status == 'Excused' ? 11 : 6;
          banThreshold = status == 'Excused' ? 12 : 8;
        } else if (hours == 5) {
          firstWarningThreshold = status == 'Excused' ? 13 : 7;
          banThreshold = status == 'Excused' ? 15 : 11;
        } else if (hours == 6) {
          firstWarningThreshold = status == 'Excused' ? 16 : 10;
          banThreshold = status == 'Excused' ? 17 : 11;
        } else {
          firstWarningThreshold = 0;
          banThreshold = 0;
        }

        course['isWarning'] =
            absent >= firstWarningThreshold && absent < banThreshold;
        course['isCloseToBan'] = absent >= banThreshold;
        course['isFirstWarning'] = absent == firstWarningThreshold;
      }
    });
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEditableCell(Map<String, dynamic> course, String key) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        initialValue: course[key].toString(),
        enabled: course['isEditable'],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
        style: const TextStyle(fontSize: 16),
        keyboardType: key == 'hours' || key == 'absent'
            ? TextInputType.number
            : TextInputType.text,
        onChanged: (value) {
          setState(() {
            if (key == 'hours' || key == 'absent') {
              course[key] = int.tryParse(value) ?? 0;
            } else {
              course[key] = value;
            }
            hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  Widget _buildDropdownCell(Map<String, dynamic> course) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DropdownButton<String>(
        value: course['status'],
        isExpanded: true,
        onChanged: course['isEditable']
            ? (newValue) {
                setState(() {
                  course['status'] = newValue!;
                  hasUnsavedChanges = true;
                });
              }
            : null,
        items: statuses
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 16),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDeleteButton(Map<String, dynamic> course) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        setState(() {
          courses.remove(course);
          hasUnsavedChanges = true;
        });
      },
    );
  }
}
