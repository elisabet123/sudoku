import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sudoku/SolutionFromFile.dart';

import 'SudokuModel.dart';
import 'SudokuSquareData.dart';

class Sudoko extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoko> {
  late SudokuModel _model;

  _SudokuState() {
    _model = SudokuModel(_setState);
  }

  _setState(SudokuModel model) {
    setState(() {
      _model = model;
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
          isSelected: _model.inputModeSelection,
          onPressed: _model.setInputMode,
          borderRadius: BorderRadius.circular(1),
          fillColor: Theme.of(context).primaryColorLight,
        ));
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        ElevatedButton(onPressed: _model.reloadSudoku, child: Text('Reset')),
        ElevatedButton(onPressed: _model.newSudoku, child: Text('New')),
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
              var selected = number == _model.selectedNumber;
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
                  _model.selectNumber(number);
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
                  child: _model.solution[index].value > 0
                      ? Text(
                          '${_model.solution[index].value}',
                          style: TextStyle(
                              color: _model.solution[index].modifyable
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.onSurface),
                        )
                      : _model.solution[index].helpDigits.isNotEmpty
                          ? GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children: List.generate(
                                9,
                                (i) {
                                  var number = i + 1;
                                  return Center(
                                      child: Text(
                                    _model.solution[index].helpDigits.contains(number)
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
                  _model.tappedBox(index);
                },
              );
            })));
  }
}

