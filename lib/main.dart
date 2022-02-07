import 'package:flutter/material.dart';
import 'package:sudoku/Soduko.dart';

void main() {
  runApp(SudokuApp());
}

class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sudoku'),
        ),
        body: Sudoko(),
      ),
    );
  }
}
