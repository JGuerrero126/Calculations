import 'package:flutter/material.dart';
import './calculator.dart' as calculator;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List buttons = ['AC', '+/-', '%'];
List numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
List calculations = ['÷', 'x', '-', '+', '=', '.'];

// buttonPressed(value) {
//   calculator.handleInput(value);
//   debugPrint('button $value is pressed');
// }

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;

  Future<void> buttonPressed(value) async {
    // calculator.handleInput(value);
    if (calculations.contains(value)) {
      switch (value) {
        case "÷":
          value = '/';
          break;
        case "x":
          value = '*';
          break;
        default:
          value = value;
      }
    }
    setState(() {
      calculator.handleInput(value.toLowerCase());
      _controller.text = calculator.dispStr;
    });
    debugPrint('button $value is pressed');
  }

  Widget buildButton(String buttonText) {
    return Expanded(
        child: SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: OutlinedButton(
                  child:
                      Text(buttonText, style: const TextStyle(fontSize: 20.0)),
                  onPressed: () => buttonPressed(buttonText),
                ))));
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calculator Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(),
            body: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                // children: [],
                // child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    // alignment: Alignment.centerRight,
                    // padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                    // child: Text(
                    // _controller.text,
                    // style: TextStyle(
                    //   fontSize: 40.0,
                    //   fontWeight: FontWeight.bold,
                  ),
                  // ),

                  const Expanded(
                    child: Divider(),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          buildButton(calculator.acButtonText),
                          buildButton('+/-'),
                          buildButton('%'),
                          buildButton('÷')
                        ],
                      ),
                      Row(
                        children: [
                          buildButton('7'),
                          buildButton('8'),
                          buildButton('9'),
                          buildButton('x'),
                        ],
                      ),
                      Row(
                        children: [
                          buildButton('4'),
                          buildButton('5'),
                          buildButton('6'),
                          buildButton('-')
                        ],
                      ),
                      Row(
                        children: [
                          buildButton('1'),
                          buildButton('2'),
                          buildButton('3'),
                          buildButton('+'),
                        ],
                      ),
                      Row(
                        children: [
                          buildButton('0'),
                          buildButton('.'),
                          buildButton('=')
                        ],
                      )
                    ],
                  )
                ])));
    // );
  }
}
