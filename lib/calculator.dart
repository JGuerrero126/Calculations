import 'package:flutter/material.dart';

List<double> numsHop = []; // holds numbers for calculation
List<String> opsHop = []; // holds math operations for calculation
double dispDbl =
    0; // this variable and the next one hold the display value in double and String formats, respectively
String dispStr = "1";

String acButtonText = "AC"; // AC button changes to C after a value is entered
String highlight =
    "none"; // indicates which button should be highlighted, if any
bool decimalEntered = false; // used to prevent entry of more than one decimal
bool readyForNewNumber =
    true; // used to clear display when a new number is entered after an operation
bool startingFromEqual = false;

int opsOrder(s) {
  // note: as more orders are added calcHops will need to be updated
  switch (s) {
    case "=":
      return 0;
    case "+":
    case "-":
      return 1;
    case "*":
    case "/":
      return 2;
    default:
      return 3;
  }
}

double mathOp(val1, s, val2) {
  switch (s) {
    case "+":
      return val1 + val2;
    case "-":
      return val1 - val2;
    case "*":
      return val1 * val2;
    case "/":
      return val1 / val2;
    default:
      debugPrint("error - invalid operation in mathOp");
      return 0;
  }
}

// 3*2+4+
// check sequence of ops; stop when lower order
// move from front; find highest order; solve 3, then 2, then 1
// 3+2*4+
double calcHop(s) {
  List<double> wkgNums = [...numsHop];
  List<String> wkgOps = [...opsHop];
  int index = wkgOps.length - 1;
  while (index >= 0 && opsOrder(s) <= opsOrder(wkgOps[index])) {
    index--;
  }
  index++; // this is the lowest index in the working hopper for which we want to calculate the result (could be zero)
  for (int opOrder = 2; opOrder >= 0; opOrder--) {
    // adjust this depending on how many levels of operation order there are
// print("opOrder: $opOrder, index: $index, s: $s");
    int place = index;
    while (place < wkgOps.length - 1) {
      if (opsOrder(wkgOps[place]) == opOrder) {
// print("calc: ${wkgNums[place]}, ${wkgOps[place]}, ${wkgNums[place + 1]}, opOrder: $opOrder");
// combine hopper: [2, +][5, -] -> [7, -]
// calc num
        wkgNums[place] =
            mathOp(wkgNums[place], wkgOps[place], wkgNums[place + 1]);
// update operation
        wkgOps[place] = wkgOps[place + 1];
// delete place+1
        wkgNums.removeAt(place + 1);
        wkgOps.removeAt(place + 1);
// print("after: $wkgNums, $wkgOps");
      } else {
// go to next
        place++;
      }
    }
  }
// print("start: $numsHop, $opsHop");
// print("calc result: ${wkgNums}, ${wkgOps}");
  return wkgNums[0];
}

void reset() {
  // reset calculator variables
  numsHop = [];
  opsHop = [];
  dispDbl = 0;
  dispStr = "0";
  acButtonText = "AC";
  highlight = "none";
  decimalEntered = false;
  readyForNewNumber = true;
  startingFromEqual = false;
  debugPrint(" --------");
}

// button input should be handled by the handleInput function below; example, the 5 button should call handleInput("5")
void handleInput(String s) {
  debugPrint("input: $s");
  highlight = "none";
// input handling
  switch (s) {
    case "c": // input of either "c" or "a" represents the AC/C button being pressed
    case "a":
      if (acButtonText == "AC") {
        reset();
      } else {
        dispDbl = 0;
        dispStr = "0";
        acButtonText = "AC";
        decimalEntered = false;
        readyForNewNumber = true;
      }
      break;
    case "m":
      if (dispStr[0] == "-") {
        dispStr = dispStr.substring(1);
      } else {
        dispStr = "-$dispStr";
      }
      dispDbl = double.parse(dispStr);
      acButtonText = "C";
      break;
    case ".":
      if (readyForNewNumber) dispStr = "0";
      if (!decimalEntered) {
        // only add a decimal if it hasn't already been entered
        dispStr += ".";
        decimalEntered = true;
        acButtonText = "C";
      }
      break;
    case "0":
      if (readyForNewNumber || startingFromEqual) {
        dispStr = "0";
        readyForNewNumber = false;
      } else {
        dispStr += "0";
        if (dispStr == "00") dispStr = "0"; // prevent entry of multiple zeroes
        if (dispStr == "-00") dispStr = "0";
      }
      dispDbl = double.parse(dispStr);
      acButtonText = "C";
      break;
    case "1":
    case "2":
    case "3":
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
      if (readyForNewNumber || startingFromEqual) dispStr = "0";
      if (dispStr == "0") dispStr = "";
      if (dispStr == "-0") dispStr = "-";
      dispStr += s;
      dispDbl = double.parse(dispStr);
      acButtonText = "C";
      readyForNewNumber = false;
      startingFromEqual = false;
      break;
    case "+":
    case "-":
    case "*":
    case "/":
      if (readyForNewNumber && !startingFromEqual) {
        // last entry was an operator, so s is a replacement operator
        opsHop.removeLast();
        opsHop.add(s);
      } else {
        // last entry was a number
        numsHop.add(dispDbl);
        opsHop.add(s);
      }
      dispDbl = calcHop(s);
      dispStr = dispDbl.toString();
      highlight = s;
      decimalEntered = false;
      readyForNewNumber = true;
      break;
    case "=":
      if (readyForNewNumber) {
        // last entry was an operator, so we need to use the last nums as the new nums
        numsHop.add(numsHop[numsHop.length - 1]);
        opsHop.add(s);
      } else {
        // last entry was a number
        numsHop.add(dispDbl);
        opsHop.add(s);
      }
      dispDbl = calcHop(s);
      dispStr = dispDbl.toString();
      numsHop = [];
      opsHop = [];
      acButtonText =
          "C"; // TODO; why isn't text "AC" after "="? what is in memory?
      highlight = "none";
      decimalEntered = false;
      readyForNewNumber = true;
      startingFromEqual = true;
      break;
    case "%":
      if (readyForNewNumber) {
// when % follows "+" or "-", it runs a calculation: disp * n1/100
        if (numsHop.isNotEmpty &&
            (opsHop[opsHop.length - 1] == "+" ||
                opsHop[opsHop.length - 1] == "-")) {
          dispDbl = dispDbl * (numsHop[numsHop.length - 1] / 100);
          dispStr = dispDbl.toString();
        } else {
// when % follows any other operation or no operation, it changes disp to disp/100
          dispDbl = dispDbl / 100;
          dispStr = dispDbl.toString();
        }
      } else {
// when % follows a num(n1) that follows "+" or "-", it runs a calculation: n2 * n1/100
        if (numsHop.isNotEmpty &&
            (opsHop[opsHop.length - 1] == "+" ||
                opsHop[opsHop.length - 1] == "-")) {
          dispDbl = numsHop[numsHop.length - 1] * (dispDbl / 100);
          dispStr = dispDbl.toString();
        } else {
// when % follows a num that follows any other operation or no operation, it changes the num to num/100
          dispDbl = dispDbl / 100;
          dispStr = dispDbl.toString();
        }
      }
      break;
  }
// display handling
  if (dispDbl % 1 == 0 && decimalEntered == false) {
    dispStr = dispStr.split(".")[0];
  }
// print("nums: $numsHop; ops: $opsHop");
// print("dispDbl: $dispDbl DISPLAY: $dispStr");
  debugPrint("ac/c: $acButtonText; highlt: $highlight; DISPLAY: $dispStr");
}
