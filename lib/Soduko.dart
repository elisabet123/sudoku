import 'package:flutter/material.dart';
import 'package:sudoku/SolutionFromFile.dart';

class Sudoko extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoko> {
  List<_SudokuSquare> _solution = new List.filled(81, _SudokuSquare(false, 0));
  SolutionFromFile _solutionFromFile = SolutionFromFile();
  int _selectedNumber = 1;

  _SudokuState() {
    _solutionFromFile.readSolutions().then((str) {
      _solution = _solutionFromFile
          .nextSolution()
          .map((value) => _SudokuSquare(value == 0, value))
          .toList();
      setState(() {
        _solution = _solution;
      });
    });
  }

  void _tappedBox(int index) {
    if (_solution[index].modifyable) {
      _solution[index].value = _selectedNumber == 10 ? 0: _selectedNumber;
      setState(() {
        _solution = _solution;
      });
    }
  }

  void _selectNumber(int number) {
    _selectedNumber = number;
    setState(() {
      _selectedNumber = _selectedNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _sudokuGrid(),
      _numberBar(),
      _bottomButtons(),
    ]);
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        ElevatedButton(onPressed: _reloadSudoku, child: Text('Reset')),
        ElevatedButton(onPressed: _newSudoku, child: Text('New')),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  Widget _numberBar() {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.teal),
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 10,
            children: List.generate(10, (index) {
              var number = index + 1;
              var selected = number == _selectedNumber;
              return InkWell(
                child: Container(
                  color: selected ? Colors.teal : Colors.white,
                  margin: EdgeInsets.fromLTRB(number == 1 ? 1 : 0.5, 1, number == 10 ? 1 : 0.5, 1),
                  child: Center(
                    child: number == 10
                        ? Icon(Icons.delete_outline)
                        : Text(
                            '$number',
                            style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selected ? Colors.white : Colors.teal),
                          ),
                  ),
                ),
                onTap: () {
                  _selectNumber(number);
                },
              );
            })));
  }

  Widget _sudokuGrid() {
    return Container(
        decoration: BoxDecoration(color: Colors.teal),
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 9,
            children: List.generate(81, (index) {
              var row = index ~/ 9;
              var col = index % 9;
              return InkWell(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(
                      col % 3 == 0 ? 2 : 1,
                      row % 3 == 0 ? 2 : 1,
                      col % 3 == 2 ? 2 : 1,
                      row % 3 == 2 ? 2 : 1),
                  child: Center(
                    child: Text(
                      '${_solution[index].value > 0 ? _solution[index].value : ''}',
                      style: TextStyle(
                          color: _solution[index].modifyable
                              ? Colors.teal
                              : Colors.black),
                    ),
                  ),
                ),
                onTap: () {
                  _tappedBox(index);
                },
              );
            })));
  }

  void _reloadSudoku() {
    _solution.forEach((square) {
      if (square.modifyable) {
        square.value = 0;
      }
    });
    setState(() {
      _solution = _solution;
    });
  }

  void _newSudoku() {
    _solution = _solutionFromFile
        .nextSolution()
        .map((value) => _SudokuSquare(value == 0, value))
        .toList();
    setState(() {
      _solution = _solution;
    });
  }
}

class _SudokuSquare {
  final bool modifyable;
  int value;

  _SudokuSquare(this.modifyable, this.value);
}
