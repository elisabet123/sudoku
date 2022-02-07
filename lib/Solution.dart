import 'dart:math';
import "package:collection/collection.dart";

class Solution {
  final Random random = new Random();
  List<int> solution = new List.filled(81, 0);
  late List<int> boxes;
  late List<List<int>> boxIndices;

  Solution() {
    boxes = _getBoxes();
    boxIndices = _getBoxIndices(boxes);
  }

  Solution create() {
    print("Creating solution");
    var possibleNumbers =
        new List.generate(81, (index) => _createNumberSequence());
    var solution = new List.filled(81, 0);
    var c = 0;
    while (c < 81) {
      if (possibleNumbers[c].isEmpty) {
        possibleNumbers[c] = _createNumberSequence();
        c--;
        solution[c] = 0;
      } else {
        var num = possibleNumbers[c].removeLast();
        if (_isOkToUse(solution, c, num)) {
          solution[c] = num;
          c++;
        }
      }
    }
    this.solution = List<int>.from(solution);
    return this;
  }

  Solution removeNumbers(int toRemove) {
    print("Removing $toRemove numbers.");
    var stopwatch = Stopwatch();
    stopwatch.start();
    for (int removal = 0; removal < toRemove; removal++) {
      var indexRemaining = solution.mapIndexed((index, value) => value == 0 ? 0 : index).whereNot((c) => c == 0).toList();
      indexRemaining.shuffle();
      indexRemaining.firstWhere((option) {
        var solutionCopy = new List<int>.from(solution);
        solutionCopy[option] = 0;

        if (_exactlyOneSolution(solutionCopy)) {
          solution = solutionCopy;
          return true;
        }
        return false;
      });
    }
    print("Took ${stopwatch.elapsed}.");
    return this;
  }

  bool _exactlyOneSolution(List<int> solution) {
    if (_solved(solution)) {
      return true;
    }
    var index = solution.indexOf(0);
    var possibleNumbers = _createNumberSequence();
    var foundSolution = false;
    for (int i = 0; i < possibleNumbers.length; i++) {
      var number = possibleNumbers[i];
      if (_isOkToUse(solution, index, number)) {
        var nextSolution = new List<int>.from(solution);
        nextSolution[index] = number;
        if (_exactlyOneSolution(nextSolution)) {
          if (foundSolution) {
            return false;
          }
          foundSolution = true;
        }
      }
    }
    return foundSolution;
  }

  List<List<int>> getGrid() {
    var chunks = new List<List<int>>.empty();
    int chunkSize = 2;
    for (var i = 0; i < solution.length; i += chunkSize) {
      chunks.add(solution.sublist(i,
          i + chunkSize > solution.length ? solution.length : i + chunkSize));
    }
    return chunks;
  }

  List<int> _createNumberSequence() {
    var list = new List<int>.generate(9, (i) => i + 1);
    list.shuffle();
    return list;
  }

  bool _isOkToUse(List<int> solution, int index, int number) {
    return !_numberUsedInBox(solution, index, number) &&
        !_numberUsedInRow(solution, index, number) &&
        !_numberUsedInCol(solution, index, number);
  }

  bool _numberUsedInRow(List<int> solution, int index, int number) {
    var row = index ~/ 9;
    var firstIndex = row * 9;
    var lastIndex = (row + 1) * 9 - 1;
    return solution
        .getRange(firstIndex, lastIndex)
        .any((point) => point == number);
  }

  bool _numberUsedInCol(List<int> solution, int index, int number) {
    var col = index % 9;
    return new List.generate(9, (i) => col + (9 * i))
        .any((index) => solution[index] == number);
  }

  bool _numberUsedInBox(List<int> solution, int index, int number) {
    var box = boxes[index];
    var othersInBox = boxIndices[box];
    return othersInBox.any((index) => solution[index] == number);
  }

  List<int> _getBoxes() {
    return new List.generate(81, (index) {
      var row = index ~/ 9;
      var col = index % 9;

      if (row < 3 && col < 3) {
        return 0;
      } else if (row < 3 && col < 6) {
        return 1;
      } else if (row < 3 && col < 9) {
        return 2;
      } else if (row < 6 && col < 3) {
        return 3;
      } else if (row < 6 && col < 6) {
        return 4;
      } else if (row < 6 && col < 9) {
        return 5;
      } else if (row < 9 && col < 3) {
        return 6;
      } else if (row < 9 && col < 6) {
        return 7;
      } else if (row < 9 && col < 9) {
        return 8;
      }
      throw FormatException("Couldn't find group for index");
    });
  }

  List<List<int>> _getBoxIndices(List<int> boxlist) {
    var boxes =
        new List.generate(9, (index) => new List<int>.empty(growable: true));
    boxlist.forEachIndexed((index, box) {
      boxes[box].add(index);
    });
    return boxes;
  }

  bool _solved(List<int> solution) {
    return solution.none((value) => value == 0);
  }
}
