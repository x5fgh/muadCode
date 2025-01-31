import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/HomeScreen.dart';
import 'package:flutter_application_1/Screen/ProfileScreen.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import 'ScheduleScreen.dart';

class ScheduleAi extends StatefulWidget {
  const ScheduleAi({super.key});

  @override
  _ScheduleAiState createState() => _ScheduleAiState();
}

class _ScheduleAiState extends State<ScheduleAi> {
  int _selectedIndex = 1;
  int maxLectures = 1;
  String selectedDayOff = "Sunday";
  String priority = "Days you would like to have off";
  File? _image;
  String? _imageError;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScheduleScreen()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    }
  }

  // اختيار الصورة
  Future<void> _pickImage() async {
    final params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.image,
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath != null) {
      setState(() {
        _image = File(filePath);
        _imageError = null;
      });
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B666E),
        title: const Text(
          'Schedule',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCard(
              title:
                  "Choose the maximum number of lectures you'd like to have in one day:",
              child: _buildDropdown<int>(
                value: maxLectures,
                items: List.generate(5, (index) => index + 1),
                onChanged: (value) {
                  setState(() {
                    maxLectures = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Select the days you prefer to keep free from lectures:",
              child: _buildDropdown<String>(
                value: selectedDayOff,
                items: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"],
                onChanged: (value) {
                  setState(() {
                    selectedDayOff = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "What is your priority in organizing the schedule?",
              child: _buildDropdown<String>(
                value: priority,
                items: [
                  "Maximum number of lectures per day",
                  "Days you would like to have off"
                ],
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(
                      Icons.upload_file,
                      color: Colors.white,
                    ),
                    label: const Text("Upload Image"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF2B666E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Upload a picture of your schedule to make it easier to organize your lectures:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.file(
                        _image!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (_imageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _imageError!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
              title: '',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_image == null) {
                  setState(() {
                    _imageError = "Please upload an image of your schedule.";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: const Color(0xFF2B666E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Create",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2B666E),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/Logo.png',
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          "Create a creative study schedule:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2B666E),
          ),
        ),
      ],
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

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButton<T>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
