import 'SolutionFromFile.dart';
import 'SolutionUtil.dart';
import 'SudokuSquareData.dart';

class SudokuModel {
  List<SudokuSquareData> solution =
      new List.filled(81, SudokuSquareData(false, 0));
  SolutionFromFile _solutionFromFile = SolutionFromFile();
  SolutionUtil _solutionUtil = SolutionUtil();
  int selectedNumber = 1;
  var inputModeSelection = [true, false, false];
  Function setState;

  SudokuModel(this.setState) {
    _solutionFromFile.readSolutions().then((str) {
      solution = _solutionFromFile
          .nextSolution()
          .map((value) => SudokuSquareData(value == 0, value))
          .toList();
      setState(this);
    });
  }

  setInputMode(index) {
    inputModeSelection.fillRange(0, 3, false);
    inputModeSelection[index] = true;
    setState(this);
  }

  fillAllHelpNumbers() {
    solution.asMap().forEach((index, square) {
      if (square.value == 0) {
        square.helpDigits = new List.generate(
                9, (number) => _isSafe(index, number + 1) ? number + 1 : 0)
            .where((element) => element != 0)
            .toSet();
      }
    });
    setState(this);
  }

  bool _isSafe(index, number) {
    return  _solutionUtil.isOkToUse(solution.map((s) => s.value).toList(), index, number);
  }

  void selectNumber(int number) {
    selectedNumber = number;
    setState(this);
  }

  void tappedBox(int index) {
    if (solution[index].modifyable) {
      if (inputModeSelection[0]) {
        solution[index].value = selectedNumber;
        solution[index].helpDigits.clear();
      } else if (inputModeSelection[1]) {
        solution[index].value = 0;
        solution[index].helpDigits.clear();
      } else {
        solution[index].helpDigits.contains(selectedNumber)
            ? solution[index].helpDigits.remove(selectedNumber)
            : solution[index].helpDigits.add(selectedNumber);
      }
      setState(this);
    }
  }

  void reloadSudoku() {
    solution.forEach((square) {
      if (square.modifyable) {
        square.value = 0;
        square.helpDigits.clear();
      }
    });
    setState(this);
  }

  void newSudoku() {
    solution = _solutionFromFile
        .nextSolution()
        .map((value) => SudokuSquareData(value == 0, value))
        .toList();
    setState(this);
  }
}
