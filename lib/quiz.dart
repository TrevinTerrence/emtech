import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helloworld/class/question.dart';
import 'package:helloworld/main.dart';
import 'package:helloworld/topScorer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  int _hitung = 10;
  int _initValue = 10;
  late Timer _timer; // add “late” to initialize it later in initState() @override
  List<QuestionObj> _questions = [];
  int _question_no = 0;
  int _point = 0;
  String _user_id = "";
  int topPoint = 0;
  String topUser = "";

  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
        _user_id = value;
      },
    ));


    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        // _hitung++;
        if (_hitung == 0) {
          // _timer.cancel();
          _hitung = 10;
          // showDialog<String>(
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //           title: Text('Quiz'),
          //           content: Text('Quiz Ended'),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () => Navigator.pop(context, 'OK'),
          //               child: const Text('OK'),
          //             ),
          //           ],
          //         ));
          _question_no++;
          if (_question_no > _questions.length - 1) endGame();
        } else {
          _hitung--;
        }
      });
    });
    _questions.add(QuestionObj("Not a member of Avenger ", 'Ironman', 'Spiderman', 'Thor', 'Hulk Hogan', 'Hulk Hogan', '0.jpeg'));
    _questions.add(QuestionObj("Not a member of Teletubbies", 'Dipsy', 'Patrick', 'Laalaa', 'Poo', 'Patrick', '1.jpeg'));
    _questions.add(QuestionObj("Not a member of justice league", 'batman', 'aquades', 'superman', 'flash', 'aquades', '2.jpeg'));
    _questions.add(QuestionObj("Not a member of BTS", 'Jungkook', 'Jimin', 'Gong Yoo', 'Suga', 'Gong Yoo', '3.jpeg'));
    _questions.add(QuestionObj("Name of this man", 'Jungkook', 'Jimin', 'Gong Yoo', 'Chandra', 'Chandra', '4.jpg'));
    _questions.add(QuestionObj("UBAYA Chancellor", 'Jungkook', 'Dr. Ir. Benny Lianto, M.M.B.A.T, Ph.D', 'Gong Yoo', 'Suga', 'Dr. Ir. Benny Lianto, M.M.B.A.T, Ph.D', '5.jpeg'));
    _questions.add(QuestionObj("Emerging Technology Lecturer", 'Daniel Hary Prasetyo, Ph.D.', 'Jimin', 'Gong Yoo', 'Suga', 'Daniel Hary Prasetyo, Ph.D.', '6.jpg'));
    _questions.add(QuestionObj("Name of this man", 'Jungkook', 'Jimin', 'Gong Yoo', 'Chandra', 'Chandra', '4.jpg'));
    _questions.add(QuestionObj("1+1", '2', '4', '5', '6','2','5.jpeg'));
    _questions.add(QuestionObj("1+3", '4', '1', '2', '5', '4', '6.jpg'));
    _questions.add(QuestionObj("1+4", '5', '1', '3', '4', '5', '6.jpg'));
    _questions.shuffle();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_hitung == 0) {
          _timer.cancel();
          _hitung = 10;
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Quiz'),
                    content: Text('Quiz Ended'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        } else {
          _hitung--;
        }
      });
    });
  }

  Future<String> checkUser() async {

    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    topPoint = prefs.getInt("top_point") ?? 0;
    topUser = prefs.getString("top_user") ?? "";
    print(topPoint);
    print(topUser);
    return user_id;
  }

  void endGame() async{
    _question_no = 0;
    _timer.cancel();

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Quiz'),
              content: Text('Retry?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _point = 0;
                    startTimer();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('No'),
                ),
              ],
            ));
    if(_point>topPoint){
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("top_user", active_user);
      prefs.setInt("top_point", _point);
    }

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Quiz'),
              content: Text('Quiz Ended, $active_user \nyour score: $_point'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopUserScreen(
                          topUser: topUser, // Example top user
                          topPoint: topPoint,      // Example top point
                        ),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void checkAnswer(String answer) {
    setState(() {
      if (answer == _questions[_question_no].answer) {
        _point += 100;
      } else {
        _point -= 50;
      }
      if (_question_no + 1 < _questions.length) {
        _question_no++;
      } else {
        endGame();
      }
      if (_question_no > _questions.length - 1) {
        endGame();
      }
      _hitung = _initValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        // Text(formatTime(_hitung).toString(),
        //     style: const TextStyle(
        //       fontSize: 24,
        //     )),
        // CircularPercentIndicator(
        //   radius: 120.0,
        //   lineWidth: 20.0,
        //   percent: 1 - (_hitung / _initValue),
        //   center: Text(formatTime(_hitung)),
        //   progressColor: Colors.red,
        // ),
        LinearPercentIndicator(
          center: Text(formatTime(_hitung)),
          width: MediaQuery.of(context).size.width,
          lineHeight: 20.0,
          percent: 1 - (_hitung / _initValue),
          backgroundColor: Colors.grey,
          progressColor: Colors.red,
        ),
        // ElevatedButton(
        //     onPressed: () {
        //       setState(() {
        //         _timer.isActive ? _timer.cancel() : startTimer();
        //       });
        //     },
        //     child: Text(_timer.isActive ? "Stop" : "Start")
        // ),
        Image.asset(
          _questions[_question_no].photo,
          width: 200,
          height: 200,
        ),
        Text(_questions[_question_no].narration),
        TextButton(
            onPressed: () {
              checkAnswer(_questions[_question_no].optionC);
            },
            child: Text("A. ${_questions[_question_no].optionA}")),
        TextButton(
            onPressed: () {
              checkAnswer(_questions[_question_no].optionC);
            },
            child: Text("B. ${_questions[_question_no].optionB}")),
        TextButton(
            onPressed: () {
              checkAnswer(_questions[_question_no].optionC);
            },
            child: Text("C. ${_questions[_question_no].optionC}")),
        TextButton(
            onPressed: () {
              checkAnswer(_questions[_question_no].optionD);
            },
            child: Text("D. ${_questions[_question_no].optionD}")),
      ])),
    );
  }
}
