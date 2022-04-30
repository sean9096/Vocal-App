import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocal_app/sound_player.dart';


//Note the analyzer needs sum function to confirm that a audio recording has been made

class Vocal_Analyzer extends StatefulWidget{

  @override
  Vocal_Analyzer_State createState() => Vocal_Analyzer_State();
}

class Vocal_Analyzer_State extends State<Vocal_Analyzer>{
  //Initialize audio players
  final timerController = TimerController();
  final player = SoundPlayer();
  //current list of notes with corresponding frequencies
  final List<String> tone_names = ["Soprano","Alto","Tenor","Bass"];
  final notes_values = {"Soprano":1,"Alto":2,"Tenor":2,"Bass":2};
  //current frequency of the recording
  int desired_frequency = 0;
  int current_frequency = 0;
  //is the frequency too high or too low
  bool is_high = false;
  bool is_low = false;

  @override
  void initState() {
    super.initState();

    player.init();
  }

  @override
  void dispose() {
    player.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(

      //top of the page with back key
      appBar: AppBar(
        backgroundColor: Color(0xFF180C0C),
        title: Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 10.0),
            child: Text(
              'Voice Analyzer',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: Row(
          children: [
            SizedBox(
              width: 8.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(FontAwesomeIcons.angleLeft),
            ),
          ],
        ),
      ),
      body: Center(

        child:
        Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.red,
                Colors.blue,
              ],
            )
        ),
          child: Column(
          //IMPLEMENTED WIDGETS BUILT HERE
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimer(),
              SizedBox(height: 16),
              buildToneGraph(),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPause(),
                  SizedBox(width: 36),
                  buildDropMenu(),
                  SizedBox(width: 36),
                  buildPlay()
                ],
              ),
              SizedBox(height: 50),
              buildFeedback()
            ]
          ),
        ),
      ),
    );
  }
  //timer box (NEEDS IMPLEMENTATION)
  Widget buildTimer(){
    return Container(
      width: 150,
      height: 50,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder (
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                  width: 10,
                  color: Colors.white
              )
          )
      ),
      child: Center(
          child: Column(
              children: [
                Text("00:00",style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )
              ],
          )
      ),
    );
  }
  //visualized graph (NEEDS RE-IMPLEMENTATION)
  //most likely cartesian graphs will not be a sufficient vector for live visualization
  Widget buildToneGraph(){
    return Container(
      width: 400,
      height: 250,
      decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder (
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                  width: 3,
                  color: Colors.grey
              )
          )
      ),
      child: Center(
          child: Container(
            child: SfCartesianChart(

                primaryXAxis: CategoryAxis(
                    title: AxisTitle(
                        text: "Time ",
                    textStyle: TextStyle(color: Colors.red))
            ),
                primaryYAxis: CategoryAxis(
                    title: AxisTitle(
                        text: "Pitch db",
                    textStyle: TextStyle(color: Colors.red))),
                // Sets 15 logical pixels as margin for all the 4 sides.
                plotAreaBorderWidth: 0,
                margin: EdgeInsets.fromLTRB(0,0,0,0)

            ),
          )
      ),
    );
  }
  //drop down menu for tone selection (NEEDS IMPLEMENTATION)(Needs Redesign)
  Widget buildDropMenu(){
    String dropdownValue = 'Select';

    return Container(
        width: 120,
        height: 70,
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder (
                borderRadius: BorderRadius.circular(32.0),
                side: BorderSide(
                    width: 3,
                    color: Colors.white
                )
            )
        ),
        child:DropdownButtonFormField(
          icon: const Icon(Icons.arrow_drop_down_sharp),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            ),
        value: tone_names[0],
        onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;

        });
        },
        items: tone_names.map((tone_names) {
        return DropdownMenuItem<String>(
          value: tone_names,
          child: Text(tone_names),
        );
            }).toList(),
          ),
    );
  }
  //outputs feedback to the user (NEEDS IMPLEMENTATION)
  Widget buildFeedback(){
    String current_text = "";
    if(player.isPlaying){
      current_text = "audio is playing";
    }
    else{
      current_text = "Press play to begin Analyzing";
    }
    //should dynamically change text based on current analyzer frequency
    /*while(player.isPlaying){
      if(current_frequency > desired_frequency){
      }
    }*/
    return Container(
      width: 300,
      height: 100,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder (
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                  width: 10,
                  color: Colors.white
              )
          )
      ),
      child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(current_text,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.redAccent),
              )
            ],
          )
      ),
    );
  }
  //play button
Widget buildPlay(){
    return RawMaterialButton(
      onPressed: () async{
        await player.togglePlaying(whenFinished: () => setState(() {}));
        setState(() {});
      },
      elevation: 2.0,
      fillColor: Colors.green,
      child: Icon(
        Icons.play_arrow,
        size: 35.0,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
}
//pause button
Widget buildPause(){
    return RawMaterialButton(
      onPressed: () {
      /* NOT IMPLEMENTED */
      },
      elevation: 2.0,
      fillColor: Colors.red,
      child: Icon(
        Icons.stop,
        size: 35.0,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}
