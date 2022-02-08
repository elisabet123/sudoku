import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sudoku/SolutionFromFile.dart';

class Sudoko extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoko> {
  List<_SudokuSquareData> _solution =
      new List.filled(81, _SudokuSquareData(false, 0));
  SolutionFromFile _solutionFromFile = SolutionFromFile();
  int _selectedNumber = 1;
  var _inputModeSelection = [true, false, false];

  _SudokuState() {
    _solutionFromFile.readSolutions().then((str) {
      _solution = _solutionFromFile
          .nextSolution()
          .map((value) => _SudokuSquareData(value == 0, value))
          .toList();
      setState(() {
        _solution = _solution;
      });
    });
  }

  void _tappedBox(int index) {
    if (_solution[index].modifyable) {
      if (_inputModeSelection[0]) {
        _solution[index].value = _selectedNumber;
        _solution[index].helpDigits.clear();
      } else if (_inputModeSelection[1]) {
        _solution[index].value = 0;
        _solution[index].helpDigits.clear();
      } else {
        _solution[index].helpDigits.contains(_selectedNumber)
            ? _solution[index].helpDigits.remove(_selectedNumber)
            : _solution[index].helpDigits.add(_selectedNumber);
      }
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
        .map((value) => _SudokuSquareData(value == 0, value))
        .toList();
    setState(() {
      _solution = _solution;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        children: [
          _sudokuGrid(),
          _inputModeButtons(),
          _numberBar(),
        ],
      ),
      _bottomButtons(),
    ]);
  }

  Widget _inputModeButtons() {
    return Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: ToggleButtons(
          children: [
            Icon(Icons.add_circle_outline),
            Icon(Icons.delete_outline),
            Icon(Icons.create)
          ],
          isSelected: _inputModeSelection,
          onPressed: (int index) {
            _inputModeSelection.fillRange(0, 3, false);
            _inputModeSelection[index] = true;
            setState(() {
              _inputModeSelection = _inputModeSelection;
            });
          },
          borderRadius: BorderRadius.circular(1),
          fillColor: Theme.of(context).primaryColorLight,
        ));
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
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 9,
            children: List.generate(9, (index) {
              var number = index + 1;
              var selected = number == _selectedNumber;
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).primaryColorLight
                          : Colors.white,
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(
                          width: 0.5, color: Theme.of(context).highlightColor)),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                          color: selected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onSurface),
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
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 9,
            children: List.generate(81, (index) {
              var row = index ~/ 9;
              var col = index % 9;
              return InkWell(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                      col % 3 == 0 ? 2 : 1,
                      row % 3 == 0 ? 2 : 1,
                      col % 3 == 2 ? 2 : 1,
                      row % 3 == 2 ? 2 : 1),
                  child: _solution[index].value > 0
                      ? Text(
                          '${_solution[index].value}',
                          style: TextStyle(
                              color: _solution[index].modifyable
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.onSurface),
                        )
                      : _solution[index].helpDigits.isNotEmpty
                          ? GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children: List.generate(
                                9,
                                (i) {
                                  var number = i + 1;
                                  return Center(
                                      child: Text(
                                    _solution[index].helpDigits.contains(number)
                                        ? '$number'
                                        : '',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                    textScaleFactor: 0.9,
                                  ));
                                },
                              ),
                            )
                          : Text(''),
                ),
                onTap: () {
                  _tappedBox(index);
                },
              );
            })));
  }
}

class _SudokuSquareData {
  final bool modifyable;
  int value;
  Set<int> helpDigits = new Set();

  _SudokuSquareData(this.modifyable, this.value);
}
