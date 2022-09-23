import 'dart:math';

String evaluate2(String input) {
  String output = input;
  final regex = [
    RegExp(r"\(([^\(\)]*)\)"),
    RegExp(r"(-?[0-9\.]+)(\^)(-?[0-9\.]+)"),
    RegExp(r"(-?[0-9\.]+)([*\/])(-?[0-9\.]+)"),
    RegExp(r"(-?[0-9\.]+)([+\-])(-?[0-9\.]+)")
  ];
  for (var r in regex) {
    while (r.hasMatch(output)) {
      (r == regex[0])
          ? output = output.replaceFirst(
              r, evaluate2(r.firstMatch(output)!.group(1).toString()))
          : output = _calcular(r, output);
    }
  }
  return (output);
}

String _calcular(RegExp regex, String input) {
  String output = input;
  RegExpMatch match = regex.firstMatch(input)!;

  final operacao = match.group(2);
  final numA = double.parse(match.group(1) as String);
  final numB = double.parse(match.group(3) as String);

  double resultado = 0;
  switch (operacao) {
    case "+":
      resultado = numA + numB;
      break;
    case "-":
      resultado = numA - numB;
      break;
    case "/":
      resultado = numA / numB;
      break;
    case "*":
      resultado = numA * numB;
      break;
    case "%":
      resultado = numA % numB;
      break;
    case "^":
      resultado = pow(numA, numB) as double;
      break;
  }
  output = input.replaceFirst(regex, resultado.toString());
  return (output);
}
