import 'package:flutter/material.dart';
import 'package:oriresults/Route/classesRoute.dart';
import 'package:oriresults/Widget/menuButtonStyle.dart';

class StartOrResultRoute extends StatelessWidget {
  final String raceid;
  const StartOrResultRoute(this.raceid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color.fromARGB(255, 97, 206, 100),
        ),
        body: Center(
            child: ListView(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.02,
              MediaQuery.of(context).size.height * 0.01,
              MediaQuery.of(context).size.width * 0.02,
              MediaQuery.of(context).size.height * 0.01),
          children: [
            ElevatedButton(
              style: menuButtonStyle(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassesRoute(raceid, "Start")));
              },
              child: const Text('StartList'),
            ),
            ElevatedButton(
              style: menuButtonStyle(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassesRoute(raceid, "Result")));
              },
              child: const Text('Result List'),
            )
          ],
        )));
  }
}