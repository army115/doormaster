import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

bool isAnimating = true;
//enum to declare 3 state of button
enum ButtonState { init, submitting, completed }

class ButtonStates extends StatefulWidget {
  const ButtonStates({Key? key}) : super(key: key);
  @override
  _ButtonStatesState createState() => _ButtonStatesState();
}

class _ButtonStatesState extends State<ButtonStates> {
  ButtonState state = ButtonState.init;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    // update the UI depending on below variable values
    final isInit = isAnimating || loading == false;
    final isDone = state == ButtonState.completed;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            onEnd: () => setState(() {
                  isAnimating = !isAnimating;
                }),
            width: !loading ? buttonWidth : 70,
            height: 60,
            // If Button State is Submiting or Completed  show 'buttonCircular' widget as below
            child: isInit
                ? buildButton()
                : Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )),
      ),
    );
  }

  // If Button State is init : show Normal submit button
  Widget buildButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
        onPressed: () async {
          // here when button is pressed
          // we are changing the state
          // therefore depending on state our button UI changed.
          setState(() {
            loading = true;
            // state = ButtonState.submitting;
          });
          //await 2 sec // you need to implement your server response here.
          // await Future.delayed(Duration(seconds: 2));
          // setState(() {
          //   state = ButtonState.completed;
          // });
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            loading = false;
            // state = ButtonState.init;
          });
        },
        child: const Text('SUBMIT'),
      );
  // this is custom Widget to show rounded container
  // here is state is submitting, we are showing loading indicator on container then.
  // if it completed then showing a Icon.
  Widget circularContainer(bool done) {
    final color = done ? Colors.green : Colors.blue;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 50, color: Colors.white)
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
