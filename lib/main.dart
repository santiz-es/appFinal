
import 'package:appfinal/Pag2.dart';
import 'package:appfinal/pag1.dart';
import 'package:appfinal/pag3.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CRUD medicamento",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Pag1(),
    Pag2(),
    Pag3(),
  ];

  final List<String> _titles = [
    "Medicamentos",
    "Farmacias",
    "Relacion",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.cyan,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Medicamentos'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Farmacias'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Relacion'),

        ],
      ),
    );
  }
}
