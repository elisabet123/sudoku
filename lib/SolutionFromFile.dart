import 'package:flutter/services.dart' show rootBundle;

class SolutionFromFile {
  late List<List<int>> _solutions;
  late Iterator<List<int>> _solutionsIterator;

  Future<String> readSolutions() async {
    var content = await rootBundle.loadString('assets/sudoku.txt');
    var temp = content
        .split('\n')
        .map((str) => str.replaceAll('[', '').replaceAll(']', '').split(','))
        .where((list) => list.length == 81)
        .toList();
    _solutions = temp
        .map((s) => s.map((i) {
              return int.parse(i.trim());
            }).toList())
        .toList();
    _solutionsIterator = _solutions.iterator;
    return content;
  }

  List<int> nextSolution() {
    if (_solutionsIterator.moveNext()) {
      return _solutionsIterator.current;
    } else {
      _solutionsIterator = _solutions.iterator;
      _solutionsIterator.moveNext();
      return _solutionsIterator.current;
    }
  }
}
