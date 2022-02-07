import random

index_to_box = []
box_to_index = []

def create_number_sequence():
    numbers = [i for i in range(1,10)]
    random.shuffle(numbers)
    return numbers

def is_ok_to_use(solution, index, number):
    return not number_used_in_row(solution, index, number) and not number_used_in_col(solution, index, number) and not number_used_in_box(solution, index, number)

def number_used_in_row(solution, index, number):
    row = index // 9
    first_index = row * 9
    last_index = ((row + 1) * 9) - 1
    return number in solution[first_index:last_index]

def number_used_in_col(solution, index, number):
    col = index % 9
    indices_in_col = [col + (i * 9) for i in range(9)]
    return number in [solution[i] for i in indices_in_col]

def number_used_in_box(solution, index, number):
    box = index_to_box[index]
    return number in [solution[i] for i in box_to_index[box]]

def create():
    print("Creating solution")
    possible_numbers = [create_number_sequence() for _ in range(81)]
    solution = [0 for _ in range(81)]
    c = 0
    while c < 81:
        if not possible_numbers[c]:
            possible_numbers[c] = create_number_sequence()
            c -= 1
            solution[c] = 0
        else:
            number = possible_numbers[c].pop()
            if is_ok_to_use(solution, c, number):
                solution[c] = number
                c += 1
    return solution

def find_box(row, col):
    if (row < 3 and col < 3):
     return 0;
    elif (row < 3 and col < 6):
     return 1;
    elif (row < 3 and col < 9):
     return 2;
    elif (row < 6 and col < 3):
     return 3;
    elif (row < 6 and col < 6):
     return 4;
    elif (row < 6 and col < 9):
     return 5;
    elif (row < 9 and col < 3):
     return 6;
    elif (row < 9 and col < 6):
     return 7;
    elif (row < 9 and col < 9):
     return 8;
       
def create_boxes():
    rowcol = [find_box(i // 9, i % 9) for i in range(81)]
    return rowcol;

def indices_in_boxes(boxlist):
    boxes = [[] for _ in range(9)]
    for i in range(81):
        boxes[boxlist[i]].append(i)
    return boxes

def exactly_one_solution(solution):
    if 0 not in solution:
        return True
    index = solution.index(0)
    possible_numbers = create_number_sequence()
    found_solution = False
    for number in possible_numbers:
        if is_ok_to_use(solution, index, number):
            solution[index] = number
            if exactly_one_solution(solution):
                if found_solution:
                    return False
                else:
                    found_solution = True
    return found_solution

def remove_numbers(solution, to_remove):
    print(f"removing {to_remove} numbers")
    while to_remove > 0:
        index_remaining = [x for x in range(81) if solution[x] is not 0]
        random.shuffle(index_remaining)
        index = index_remaining.pop()
        backup = solution[index]
        solution[index] = 0

        solution_copy = [i for i in solution]
        if not exactly_one_solution(solution_copy):
            solution[index] = backup;
        else:
            to_remove -= 1
    return solution

def main():
    global index_to_box
    index_to_box = create_boxes()
    global box_to_index
    box_to_index = indices_in_boxes(index_to_box)
    for x in range(100):
        solution = create()
        solution = remove_numbers(solution, 64)

        f = open("sudoku.txt", "a")
        f.write(str(solution) + "\n")
        f.close()

if __name__ == '__main__':
    main()

#
#   List<List<int>> getGrid():
#     var chunks = new List<List<int>>.empty();
#     int chunkSize = 2;
#     for (var i = 0; i < solution.length; i += chunkSize):
#       chunks.add(solution.sublist(i,
#           i + chunkSize > solution.length ? solution.length : i + chunkSize));
#     
#     return chunks;
#   
#
#   List<int> _createNumberSequence():
#     var list = new List<int>.generate(9, (i) => i + 1);
#     list.shuffle();
#     return list;
#   
#
#
#   bool _solved(List<int> solution):
#     return solution.none((value) => value == 0);
#   
# 
