
class SudokuSquareData {
  final bool modifyable;
  int value;
  Set<int> helpDigits = new Set();

  SudokuSquareData(this.modifyable, this.value);
}