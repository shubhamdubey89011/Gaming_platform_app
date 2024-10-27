import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> dummyGames = [
    'Game 1',
    'Game 2',
    'Game 3',
    'Game 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: dummyGames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dummyGames[index]),
          );
        },
      ),
    );
  }
}
