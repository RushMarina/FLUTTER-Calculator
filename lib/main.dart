import 'package:flutter/material.dart';
import 'package:calc_v_2/Buttons.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '';
  String _outputHistory = '';
  double? previousAnswer;

//Knappar
  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', 'x',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', 'ANS', '=',
  ];

  @override
  Widget build(BuildContext context) {
    // Srceen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
        backgroundColor: Color.fromRGBO(194, 194, 194, 1),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            //Result
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      _outputHistory,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 125, 124, 124)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _output,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            //Knappar - Grid Systemet
            Expanded(
              flex: 2,
              child: Container(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: screenWidth / (screenHeight / 2),),
                  itemBuilder: (BuildContext context, int index) {
                    Color buttonColor;
                    if (index == 0) {
                      buttonColor = Color.fromARGB(255, 52, 124, 55);
                    } else if (index == 1) {
                      buttonColor = Color.fromARGB(255, 246, 70, 57);
                    } else if (index == 19) {
                      buttonColor = Color.fromARGB(255, 107, 60, 131);
                    } else if (isOperator(buttons[index])) {
                      buttonColor = Color.fromARGB(189, 74, 99, 171);
                    } else {
                      buttonColor = Color.fromRGBO(223, 223, 223, 1);
                    }
                    return GestureDetector(
                      onTap: () {
                        onButtonPressed(buttons[index]);
                      },
                      child: MyButton(
                        buttonText: buttons[index],
                        color: buttonColor,
                        textColor: index == 0 || index == 1 ? Colors.white : isOperator(buttons[index]) ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onButtonPressed(String buttonText) {
    if (buttonText == 'C') {
      clear();
    } else if (buttonText == 'DEL') {
      delete();
    } else if (buttonText == '=') {
      calculate();
    } else if (buttonText == 'ANS') {
      updateOutput(previousAnswer.toString()); //ANS
    } else {
      updateOutput(buttonText);
    }
  }

  void updateOutput(String text) {
    setState(() {
      _output += text;
    });
  }

  void clear() {
    setState(() {
      _output = '';
      _outputHistory = '';
    });
  }

  void delete() {
    setState(() {
      if (_output.length > 0) {
        _output = _output.substring(0, _output.length - 1);
      }
    });
  }

  void calculate() {
    List<String> operands = _output.split(RegExp(r'[+\-*/%x]'));
    String operator = _output.replaceAll(RegExp(r'[0-9.]'), '');

    if (operands.length < 2 || operator.isEmpty) {
      return;
    }

    double result = double.parse(operands[0]);
    for (int i = 1; i < operands.length; i++) {
      double operand = double.parse(operands[i]);
      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case 'x':
        case '*':
          result *= operand;
          break;
        case '/':
        if (operand != 0) {
          result /= operand;
        } else {
          // Regeln är att man inte kan dividera med noll
          setState(() {
            _output = 'Error';
            _outputHistory = '';
          });
          return;
        }
        break;
        case '%':
          result = result * (operand / 100);
          break;
        default:
          return;
      }
    }

    
  setState(() {
    _outputHistory = _output;
    previousAnswer = result; // Skapa ANS
    _output = result.toString();
  });
  }
  //Hur man förstår att en knapp är en operatör
  bool isOperator(String x){
    if(x == '%' || x == '/' || x == 'x' || x == '-' || x =='+' || x == '=') {
      return true;
    }
    return false;
  }
}
