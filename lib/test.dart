import 'dart:io';

import 'package:sudoku/Solution.dart';

Future<void> main() async {
  for (int i = 0; i<5; i++) {
    var hej = Solution().create().removeNumbers(60);
    final filename = 'sudokus.txt';
    var file = await File(filename).writeAsString(hej.solution.toString() + '\n', mode:FileMode.writeOnlyAppend);
    printSolution(hej.solution);
    print("done");
  }
}

void printSolution(List<int> solution) {
  new List.generate(9, (i) => i).forEach((rowNo) {
    var firstIndex = rowNo * 9;
    var lastIndex = (rowNo + 1) * 9 - 1;
    var row = solution.getRange(firstIndex, lastIndex);
    print(row.toString());
  });
}
