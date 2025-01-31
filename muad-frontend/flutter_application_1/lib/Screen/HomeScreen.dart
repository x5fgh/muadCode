import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AmbassadorsScreen.dart';
import 'AttendanceTrackerScreen.dart';
import 'GPACalculatorScreen.dart';
import 'ProfileScreen.dart';
import 'ScheduleScreen.dart';
import 'UserProvider.dart';
import 'AcademicScheduleScreen.dart';

class HomeScreen extends StatefulWidget {
  int selectedIndex;

  HomeScreen({super.key, this.selectedIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<AppBar> appBars = [
    AppBar(
      backgroundColor: const Color(0xFF2B666E),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Home',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
    AppBar(
      backgroundColor: const Color(0xFF2B666E),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Academic Schedule',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
    AppBar(
      backgroundColor: const Color(0xFF2B666E),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
  ];

  final List<Widget> pages = [
    HomeWidget(),
    AcademicScheduleScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBars[widget.selectedIndex],
      body: pages[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2B666E),
        unselectedItemColor: Colors.grey,
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Academic Schedule', // تغيير النص هنا
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

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.firstName.isEmpty || userProvider.lastName.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final firstName = userProvider.firstName;
        final lastName = userProvider.lastName;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF2B666E),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B666E),
                  ),
                ),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB58D35),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Tap a service below:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendanceTrackerScreen()),
                        );
                      },
                      child: const ServiceCard(
                        imagePath: 'assets/images/Attendance.png',
                        title: 'Attendance',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduleScreen()),
                        );
                      },
                      child: const ServiceCard(
                        imagePath: 'assets/images/Student Schedule.png',
                        title: 'Student Schedule',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const GPACalculatorScreen()),
                        );
                      },
                      child: const ServiceCard(
                        imagePath: 'assets/images/Caculate GPA.png',
                        title: 'Calculate GPA',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AmbassadorsScreen()),
                        );
                      },
                      child: const ServiceCard(
                        imagePath: 'assets/images/Ambassador.png',
                        title: 'Ambassador',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// بطاقة الخدمة التي يتم استخدامها في GridView
class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const ServiceCard({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF2B666E), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: 75,
                height: 75,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B666E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
