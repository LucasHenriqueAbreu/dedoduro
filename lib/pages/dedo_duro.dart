import 'package:dedoduro/pages/dashboard/dashboard.dart';
import 'package:dedoduro/pages/reclamacoes/reclamacoes.dart';
import 'package:flutter/material.dart';

import 'profile/profile.dart';

class DedoDuro extends StatefulWidget {
  @override
  _DedoDuroState createState() => _DedoDuroState();
}

class _DedoDuroState extends State<DedoDuro> {
  int _selectIndex = 0;

  static const List<Widget> _pages = [
    DashBoard(
      title: 'Dashboard',
    ),
    Reclamacoes(
      title: 'Reclamações',
    ),
    Profile(
      title: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: 'Reclamações',
            icon: Icon(Icons.people_alt),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.face),
          ),
        ],
        currentIndex: _selectIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
