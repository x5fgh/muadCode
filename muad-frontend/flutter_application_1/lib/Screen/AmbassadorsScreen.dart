import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HomeScreen.dart';
import 'ProfileScreen.dart';
import 'ScheduleScreen.dart';

class AmbassadorsScreen extends StatefulWidget {
  const AmbassadorsScreen({super.key});

  @override
  _AmbassadorsPageState createState() => _AmbassadorsPageState();
}

class _AmbassadorsPageState extends State<AmbassadorsScreen> {
  int _selectedIndex = 0;

  String selectedSpecialty = "All specializations";
  String selectedGender = "All genders";
  String searchQuery = "";

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fail')));
    }
  }

  final List<Map<String, String>> ambassadors = [
    {
      "name": "Lujain Al-Harbi",
      "specialty": "Information Systems",
      "gender": "Female",
      "description":
          "User studies information systems, has a passion for technology, and aims to provide innovative solutions to simplify life and solve big problems..",
      "contactX": "https://x.com/@xvcic1",
      "contactLinkedIn": "https://linkedin.com/in/Lujain",
    },
    {
      "name": "Raghad Al-Zahrani",
      "specialty": "Information Systems",
      "gender": "Female",
      "description":
          "Al-Udud is a student in the Information Systems Department who is excited to help his new classmates at the college, especially in achieving a balance between studies and social life.",
      "contactX": "https://x.com/uqucis?s=21&t=0DlzpU8PH3KxzG_Waz_mQw",
      "contactLinkedIn":
          "https://www.linkedin.com/in/raghadal-zahrani?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app",
    },
    {
      "name": "Ahmed Ali",
      "specialty": "Engineering",
      "gender": "Male",
      "description":
          "User is an AI student passionate about technology and machine learning, aiming to develop innovative solutions to improve daily life and solve complex problems.",
      "contactX": "https://x.com/@layla_hassan@ahmed_ali",
      "contactLinkedIn": "https://linkedin.com/in/ahmedali",
    },
  ];

  List<Map<String, String>> get filteredAmbassadors {
    return ambassadors.where((ambassador) {
      final matchesSpecialty = selectedSpecialty == "All specializations" ||
          ambassador["specialty"] == selectedSpecialty;
      final matchesGender = selectedGender == "All genders" ||
          ambassador["gender"] == selectedGender;
      final matchesSearch = searchQuery.isEmpty ||
          ambassador["name"]!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSpecialty && matchesGender && matchesSearch;
    }).toList();
  }

  void _onItemTapped(int index) {
    print('object');
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(selectedIndex: 1)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(selectedIndex: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B666E),
        title: const Text(
          'Ambassadors',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Search for an ambassador...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2B666E)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF2B666E)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedSpecialty,
                  items: [
                    "All specializations",
                    "Engineering",
                    "Information Systems",
                  ].map((specialty) {
                    return DropdownMenuItem(
                      value: specialty,
                      child: Text(specialty),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSpecialty = value!;
                    });
                  },
                  dropdownColor: Colors.grey[300],
                ),
                DropdownButton<String>(
                  value: selectedGender,
                  items: [
                    "All genders",
                    "Male",
                    "Female",
                  ].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  dropdownColor: Colors.grey[300],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAmbassadors.length,
                itemBuilder: (context, index) {
                  final ambassador = filteredAmbassadors[index];
                  return Card(
                    color: index % 2 == 0
                        ? Colors.grey[300]
                        : const Color(0xFF2B666E),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_circle,
                                  size: 24, color: Colors.grey[500]),
                              const SizedBox(width: 8),
                              Text(
                                ambassador["name"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: index % 2 == 0
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Specialty: ${ambassador["specialty"]}",
                            style: TextStyle(
                              color:
                                  index % 2 == 0 ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ambassador["description"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  index % 2 == 0 ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _launchUrl('${ambassador['contactX']}');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB18C43),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "X",
                                      style: TextStyle(
                                        color: Color(0xFF2B666E),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  _launchUrl(
                                      '${ambassador["contactLinkedIn"]}');
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB18C43),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "in",
                                      style: TextStyle(
                                        color: Color(0xFF2B666E),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
}
