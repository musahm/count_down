import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:showcase/features/stopwatch/presentation/cubit/stopwatch_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String initDisplayText = "000000";
String formatText(String text) {
  return "${text.substring(0, 2)}h ${text.substring(2, 4)}m ${text.substring(4, 6)}s";
}

String removeFormating(String text) {
  return text.replaceAll(RegExp(r'h|m|s|:|\s'), "");
}

double iconSize = 60.0;

Color backgroudColor = HexColor("202243");

IconButton customIconButton(
    {required IconData iconName,
    required VoidCallback onPress,
    Color color = Colors.white,
    double iconSize = 30,
    bool isActive = false}) {
  return IconButton(
    color: color,
    icon: Icon(
      iconName,
      size: iconSize,
    ),
    onPressed: onPress,
  );
}

class StopWatchPage extends StatelessWidget {
  final TextEditingController inputController = TextEditingController();

  final bool enableStartButton = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroudColor,
              backgroudColor,
            ],
            stops: [
              0.5,
              1,
            ],
          ),
        ),
        child: BlocProvider(
          create: (context) => StopwatchCubit(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TopMenu(),
                Divider(
                  color: Colors.white60,
                ),
                BlocBuilder<StopwatchCubit, StopwatchState>(
                  builder: (context, state) {
                    if (state is StartTimer) {
                      return Expanded(child: CustomTimer());
                    }
                    // return getBody(size, context);

                    return getBody(size, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBody(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TimerInputDisplay(inputController: inputController),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Divider(
              color: Colors.white,
            ),
          ),
          Container(
            // 70% of the screen size
            constraints: BoxConstraints(minHeight: size.height * 0.5),
            child: NumericKeyPad(inputController: this.inputController),
          ),
          StartTimerButton()
        ],
      ),
    );
  }
}

class StartTimerButton extends StatelessWidget {
  const StartTimerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.04),
      child: IconButton(
        iconSize: iconSize,
        color: Colors.yellow,
        icon: Icon(
          Icons.play_circle_fill_outlined,
        ),
        onPressed: () {
          BlocProvider.of<StopwatchCubit>(context).emit(StartTimer());
        },
      ),
    );
  }
}

class TopMenu extends StatelessWidget {
  const TopMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        topMenuItem(context, iconName: Icons.alarm, onPress: dispatchAlarm),
        topMenuItem(context,
            iconName: Icons.access_time, onPress: dispatchAlarm),
        topMenuItem(context,
            iconName: Icons.hourglass_bottom,
            onPress: dispatchAlarm,
            isActive: true),
        topMenuItem(context, iconName: Icons.timer, onPress: dispatchAlarm),
        topMenuItem(context, iconName: Icons.more_vert, onPress: dispatchAlarm),
      ],
    );
  }

  IconButton topMenuItem(BuildContext context,
      {required IconData iconName,
      required VoidCallback onPress,
      bool isActive = false}) {
    return IconButton(
      iconSize: 30,
      color: isActive ? Colors.white : Colors.white70,
      icon: Icon(iconName),
      onPressed: isActive ? onPress : () {},
    );
  }

  void dispatchAlarm() {
    print("clicked");
  }
}

class TimerInputDisplay extends StatelessWidget {
  const TimerInputDisplay({
    Key? key,
    required this.inputController,
  }) : super(key: key);

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<StopwatchCubit, StopwatchState>(
      builder: (context, state) {
        if (state is NumberButtonPressed) {
          String displayText = removeFormating(inputController.text);

          inputController.text =
              formatText(state.getValue(displayText, state.number));

          return getDisplay(size, context);
        }

        if (state is ClearButtonPress) {
          String displayText = removeFormating(inputController.text);

          inputController.text = formatText(state.getValue(displayText));
          return getDisplay(size, context);
        } else {
          inputController.text = formatText(initDisplayText);
          return getDisplay(size, context);
        }
      },
    );
  }

  Row getDisplay(Size size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints:
              BoxConstraints.tight(Size(size.width * 0.6, size.height * 0.1)),
          child: TextField(
              controller: this.inputController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  )),
        ),
        DeleteButton(onPress: () {
          BlocProvider.of<StopwatchCubit>(context).emit(ClearButtonPress());
        }),
      ],
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPress;

  DeleteButton({required this.onPress});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: Icon(Icons.backspace_rounded),
      onPressed: () {
        this.onPress();
      },
    );
  }
}

class NumericKeyPad extends StatelessWidget {
  final TextEditingController inputController;

  const NumericKeyPad({Key? key, required this.inputController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        numericKeyPadRow(
          [
            KeyPadNumbericButton(text: "1"),
            KeyPadNumbericButton(text: "2"),
            KeyPadNumbericButton(text: "3"),
          ],
        ),
        numericKeyPadRow(
          [
            KeyPadNumbericButton(text: "4"),
            KeyPadNumbericButton(text: "5"),
            KeyPadNumbericButton(text: "6"),
          ],
        ),
        numericKeyPadRow(
          [
            KeyPadNumbericButton(text: "7"),
            KeyPadNumbericButton(text: "8"),
            KeyPadNumbericButton(text: "9"),
          ],
        ),
        numericKeyPadRow(
          [
            KeyPadNumbericButton(text: "0"),
          ],
        ),
      ],
    );
  }

  Widget numericKeyPadRow(List<Widget> keypadButtons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keypadButtons,
    );
  }
}

class KeyPadNumbericButton extends StatelessWidget {
  final String text;

  const KeyPadNumbericButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.white),
        ),
        onPressed: () {
          BlocProvider.of<StopwatchCubit>(context)
              .emit(NumberButtonPressed(number: text));
        },
      ),
    );
  }
}

class CustomTimer extends StatefulWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..forward();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Column(
            children: [circularProgression(_animationController), Row()],
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget circularProgression(AnimationController animationController) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ShaderMask(
          shaderCallback: (Rect rect) {
            return SweepGradient(
              startAngle: 0,
              endAngle: 3.14 * 2,
              colors: [Colors.yellow, Colors.grey],
              stops: [animationController.value, animationController.value],
            ).createShader(rect);
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          constraints: BoxConstraints.tight(Size(195, 195)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroudColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                child: Text(
                  "Sage",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                (animationController.value * 20).ceil().toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                ),
              ),
              Container(
                height: 20,
                child: customIconButton(
                    iconName: Icons.replay,
                    iconSize: 20,
                    onPress: () {
                      animationController.reset();
                      animationController.forward();
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
