import 'package:flutter/material.dart';
import 'package:quiz_project/widget/next_button.dart';
import './constants.dart';
import './models/question_model.dart';
import './widget/question_widget.dart';
import './widget/option_card.dart';
import './widget/result_box.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Questions> _question = [
    Questions(id: '1', title: 'What is 2 + 2 ?', options: {
      '5': false, '30': false, '4': true, '10': false
    },
    ),
     Questions(id: '2', title: 'What is 4 + 4 ?', options: {
      '50': false, '30': false, '40': true, '10': false
    },
    )
  ];


  //we create an index to loop through questions
  int index = 0;
  //create a score variable
  int score = 0;

  //create a boolean value to check if the user has clicked
  bool isPressed = false;

 //create a function to display the next question
 bool isAlreadySelected = false;
  void nextQuestion () {


    // create a function for changing color
    if(index == _question.length -1){
      //this is the block where the question end
      showDialog(
        context: context,
        barrierDismissible: false, //this will disable the dismiss function on clicking outside of box 
         builder: (ctx) => ResultBox(result: score, //total points the user got
      questionLength: _question.length,
      onPressed: startOver,
      ));
    }else{
    if(isPressed){
      setState(() {
      index++; // when the index will change to 1. rebuild the app
      isPressed = false;
      isAlreadySelected = false;
    });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select any option'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
    }
  }

  }

  // create a function for changing color
  void checkAnswerAndUpdate(bool value){
    if(isAlreadySelected){
      return;
    }else{
      if(value == true){
      score++;
      }
      setState(() {
      isPressed = true;
      isAlreadySelected = true;
    });
    }
  }

  //create a function to startover
  void startOver(){
    setState(() {
      index = 0;
    score = 0;
    isPressed = false;
    isAlreadySelected = false;
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(padding: const EdgeInsets.all(18.0), child: Text('Score: $score',
          style: const TextStyle(fontSize: 18.0),
          ),)
        ],
        
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            //Add the questions widget here
            QuestionWidget(question: _question[index].title, indexAction: index, totalQuestions: _question.length),
            const Divider(color: neutral,),

            //add some space
            const SizedBox(height: 25,),
            for(int i = 0; i < _question[index].options.length; i++)
            GestureDetector(
              onTap: () => checkAnswerAndUpdate(_question[index].options.values.toList()[i]),
              child: OptionCard(
                option: _question[index].options.keys.toList()[i],
                //we need to check if the answer is correct or not
                color: isPressed ? _question[index].options.values.toList()[i] == true ? correct : incorrect : neutral,
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}