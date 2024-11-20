import 'dart:async';

import 'package:flutter/material.dart';

class Animasi extends StatefulWidget {
  const Animasi({super.key});

  @override
  State<Animasi> createState() => _AnimasiState();
}

class _AnimasiState extends State<Animasi> {
  bool _animated = false;
  late Timer _timer;
  late Timer _timer2;
  double _opacityLevel = 0.0;

  Widget widget1() {
    return ElevatedButton(
        onPressed: () {},
        child: const Text(
          "Click me!",
          style: TextStyle(fontSize: 30),
        ));
  }

  Widget widget2() {
    return TextButton(
        onPressed: () {},
        child: const Text(
          "Click me!",
          style: TextStyle(fontSize: 30),
        ));
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      setState(() {
        _animated = !_animated;
      });
    });
    _timer2 = Timer.periodic(Duration(milliseconds: 5000), (timer) {
      setState(() {
        _opacityLevel = 1.0 - _opacityLevel;
      });
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('animation test'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          AnimatedDefaultTextStyle(
            style: _animated
                ? const TextStyle(
                    color: Colors.blue,
                    fontSize: 60,
                  )
                : const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
            duration: const Duration(milliseconds: 1000),
            child: const Center(child: Text('Hello')),
          ),
          TextButton(
            child: const Text('Animate'),
            onPressed: () {
              setState(() {
                _animated = !_animated;
              });
            },
          ),
          SizedBox(
            width: 250.0,
            height: 250.0,
            child: AnimatedAlign(
              alignment: _animated ? Alignment.topRight : Alignment.bottomLeft,
              duration: const Duration(seconds: 3),
              curve: Curves.fastOutSlowIn,
              child: ClipOval(
                child: Image.network(
                  'https://i.pravatar.cc/100',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
              width: 250.0,
              height: 250.0,
              child: AnimatedOpacity(
                opacity: _opacityLevel,
                duration: const Duration(seconds: 5),
                child: Image.network('https://i.pravatar.cc/240?img=6'),
              )),
          AnimatedContainer(
            height: _animated ? 200 : 300,
            width: _animated ? 300 : 200,
            decoration: _animated
                ? BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/400?img=1'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.blue,
                      width: 10,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  )
                : BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/400?img=15'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.red,
                      width: 5,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
            duration: const Duration(seconds: 3),
            curve: Curves.fastOutSlowIn,
          ),
          Center(
              child: AnimatedCrossFade(
            duration: const Duration(seconds: 3),
            firstChild: const Image(image: NetworkImage('https://i.pravatar.cc/400?img=1'), fit: BoxFit.fitWidth, width: 200, height: 240),
            secondChild: const Image(image: NetworkImage('https://i.pravatar.cc/400?img=15'), fit: BoxFit.fitWidth, width: 200, height: 240),
            crossFadeState: _animated ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          )),
          AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(turns: animation, child: child);
              //return ScaleTransition(child: child, scale: animation);
            },
            child: _animated ? widget1() : widget2(),
          )
        ]),
      ),
    );
  }
}
