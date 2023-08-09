import 'package:flutter/material.dart';
import 'question.dart';
import 'quiz_brain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

QuizBrain quizBrain = QuizBrain();
int finalScore = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Directionality(
      textDirection: TextDirection.ltr, // or TextDirection.rtl as needed
      child: SplashScreen(),
    ),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Perform any initialization here
    // Example: Load data, set up services, etc.
    // After initialization, navigate to the next screen.
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Quizzler()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/splash.png'),
      ),
    );
  }
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Quizzler")),
          backgroundColor: Colors.grey.shade900,
        ),
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Icon(
  //   Icons.check,
  //   color: Colors.green,
  // ),
  // Icon(
  //   Icons.close,
  //   color: Colors.red,
  // )

  // List<String> questions = [
  //   'You can lead a cow down stairs but not up stairs.',
  //   'Approximately one quarter of human bones are in the feet.',
  //   'A slug\'s blood is green.'
  // ];
  //
  // List<String> answers = ['False', 'True', 'True'];
  //
  // Question q1 = Question(
  //     q: 'You can lead a cow down stairs but not up stairs.', a: false);

  // int i = 0;
  @override
  Widget build(BuildContext context) {
    // return Text("hello");
    return PageView.builder(
        itemCount: quizBrain.questionBank.length,
        itemBuilder: (context, index) {
          return QuestionWidget(i: index);
        });
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/

class QuestionWidget extends StatefulWidget {
  late int i;
  QuestionWidget({required this.i});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<Widget> scoreKeeper = [];
  bool scoreAdded = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(widget.i),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Text Color
              ),
              // textColor: Colors.white,
              // color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  // backgroundColor: Colors.yellow,
                  fontSize: 20.0,
                ),
              ),

              onPressed: () {
                setState(() {
                  if (quizBrain.getQuestionAnswer(widget.i) == true) {
                    if (scoreAdded) {
                      finalScore++;
                      scoreAdded = false;
                    }
                  }
                });
              },
              // onPressed: () {
              //   if (iconAdded) {
              //     iconAdded = false;
              //     setState(() {
              //       if (quizBrain.getQuestionAnswer(widget.i) == true) {
              //         scoreKeeper.add(Icon(
              //           Icons.check,
              //           color: Colors.green,
              //         ));
              //       } else {
              //         scoreKeeper.add(Icon(
              //           Icons.close,
              //           color: Colors.red,
              //         ));
              //       }
              //       // if (widget.i < 12) {
              //       //   widget.i++;
              //       // }
              //     });
              //   }
              //
              //   //The user picked true.
              // },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent, // Text Color
              ),
              // color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),

              onPressed: () {
                setState(() {
                  if (quizBrain.getQuestionAnswer(widget.i) == false) {
                    if (scoreAdded) {
                      finalScore++;
                      scoreAdded = false;
                    }
                  }
                });
              },

              // onPressed: () {
              //   if (iconAdded) {
              //     iconAdded = false;
              //     setState(() {
              //       if (quizBrain.getQuestionAnswer(widget.i) == false) {
              //         scoreKeeper.add(Icon(
              //           Icons.check,
              //           color: Colors.green,
              //         ));
              //       } else {
              //         scoreKeeper.add(Icon(
              //           Icons.close,
              //           color: Colors.red,
              //         ));
              //       }
              //       // if (widget.i < 12) {
              //       //   widget.i++;
              //       // }
              //     });
              //   }
              //
              //   //The user picked false.
              // },
            ),
          ),
        ),
        //TODO: Add a Row here as your score keeper
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Score : ",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Text(
                finalScore.toString(),
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
