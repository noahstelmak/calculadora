import 'evaluate.dart';
import 'package:flutter/material.dart';

class Input {
  final String type;
  final String value;
  //String text;
  //String icon;
  const Input(this.type, this.value);
}

const buttonList = [
  Input('Special', 'C'),
  Input('Special', '()'),
  Input('Operator', '^'),
  Input('Operator', '/'),
  Input('Numeric', '7'),
  Input('Numeric', '8'),
  Input('Numeric', '9'),
  Input('Operator', '*'),
  Input('Numeric', '6'),
  Input('Numeric', '5'),
  Input('Numeric', '4'),
  Input('Operator', '-'),
  Input('Numeric', '3'),
  Input('Numeric', '2'),
  Input('Numeric', '1'),
  Input('Operator', '+'),
  Input('Numeric', '.'),
  Input('Numeric', '0'),
  Input('Special', '<'),
  Input('Special', '='),
];

void main(List<String> args) => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculadora",
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 26)),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String resposta = "0", inputString = "";
  bool parentesesAberto = false;
  Widget calculatorButton(Input button) {
    void handleButton(Input button) {
      setState(() {
        switch (button.type) {
          case "Special":
            switch (button.value) {
              case "()":
                if (["+", "-", "^", "*", "/", "("].any(inputString.endsWith) ||
                    inputString.isEmpty) {
                  inputString += "(";
                } else {
                  inputString += ")";
                }
                break;
              case "=":
                inputString = evaluate2(inputString);
                break;
              case "<":
                if (inputString.isNotEmpty) {
                  inputString =
                      inputString.substring(0, inputString.length - 1);
                }
                break;
              case "C":
                resposta = "0";
                inputString = "";
                break;
            }
            break;
          case "Numeric":
            inputString = inputString + button.value;
            break;
          case "Operator":
            if (["+", "-", "^", "*", "/"].any(inputString.endsWith)) {
              inputString = inputString.substring(0, inputString.length - 1);
            }
            inputString = inputString + button.value;
            break;
        }
        var temp = evaluate2(inputString);
        if (!temp.contains(RegExp(r'[+\-\^*\/\(\)]')) && temp.isNotEmpty) {
          resposta = temp;
        }
      });
    }

    Color colorSwitch(type) {
      switch (type) {
        case "Special":
          return Colors.white24;
        case "Operator":
          return Colors.white12;
        default:
          return Colors.white38;
      }
    }

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            backgroundColor: colorSwitch(button.type)),
        child: Text(button.value),
        onPressed: () {
          handleButton(button);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 20),
                child: Text(
                  '$inputString\n', // minLines:
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 60),
                child: Text(
                  resposta,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 40, color: Colors.white38),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 5 / 4,
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return calculatorButton(buttonList[index]);
                }),
          ),
        ],
      ),
    );
  }
}
