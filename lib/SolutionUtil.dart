import "package:collection/collection.dart";

class SolutionUtil {
  late List<int> indexToBox;
  late List<List<int>> boxToIndices;

  SolutionUtil() {
    indexToBox = _getBoxes();
    boxToIndices = _getBoxIndices(indexToBox);
  }

  bool isOkToUse(List<int> solution, int index, int number) {
    return !_numberUsedInBox(solution, index, number) &&
        !_numberUsedInCol(solution, index, number) &&
        !_numberUsedInRow(solution, index, number);
  }

  bool _numberUsedInRow(List<int> solution, int index, int number) {
    var row = index ~/ 9;
    var firstIndex = row * 9;
    var lastIndex = (row + 1) * 9;
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
    var box = indexToBox[index];
    var othersInBox = boxToIndices[box];
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
}
