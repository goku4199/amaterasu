import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';//direct dependency animation
import 'package:amaterasu/components/rounded_button.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';//due to static id will belong to class

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{//SingleTickerProviderStateMixin for 1 animation and TickerProviderStateMixin for multiple animation this helps the class to act as ticker provider

//Ticker:-every time ticker ticks it triggers a new setstate so that we can render something different
//Animation controller:- manager of animation it tells animation to start,stop,forward,reverse
//Animation value or animation:- it is the this which does animation by default it will go from 0 to 1
  AnimationController controller;//will coordinate whole animation
  Animation animation;//will help in defining properties of animation such as curves,colorTween

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(//for custom animation
      duration: Duration(seconds: 1),
      vsync: this,//this represent current object
      upperBound: 1.0//now instead of 0 to 1 it will go from 0 to 100
    );

    /*animation = CurvedAnimation(parent: controller, curve: Curves.decelerate); for assigning curves to animation.....this will return new animation value*/
    //in curves upperbound is 1
    controller.forward();
    //to make reverse animation controller.reverse(from: 1.0)

    animation = ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);//color tween will make a animation starting from start color to end color A linear interpolation between a beginning and ending value.

    /*animation.addStatusListener((status) {//will listen status of animation
      if(status == AnimationStatus.completed){//AnimationStatus.completed will occur when forward is completed
        controller.reverse(from:1.0);
      }else if(status == AnimationStatus.dismissed){//AnimationStatus.dismissed will occur when reverse is completed
        controller.forward();
      }
    });*/
    //controller.value will print controller value i.e value from 0 to 1
    //controller.value is the actual animation(in from of numbers)
    //animation.value is the real animation
    controller.addListener(() {//to see what the controller is doing
      setState(() {});
      //print(animation.value);
    });

  }

  @override
  void dispose() {//will be called when welcome screen is destroyed
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              
              children: <Widget>[
                Expanded(
                  child: Hero(//hero widget for animation transition
                    tag: 'logo',
                    child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 60/*animation.value * 100*/,
                      ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: TyperAnimatedTextKit(//a dependency animation
                    text:['Amaterasu_'],/*${animation.value.toInt() * 100}%'*/
                    textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log in', colour: Colors.lightBlueAccent,onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(title: 'Register',colour: Colors.blueAccent,onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}



//refactoring using extract widget in flutter outline