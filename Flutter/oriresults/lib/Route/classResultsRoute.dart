import 'dart:convert';
import 'dart:async';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oriresults/Widget/resultBox.dart';

const apiUrl = 'https://cghd6kwn0k.execute-api.us-east-1.amazonaws.com';

Future<List<Map<String, dynamic>>> fetchResults(
    String raceid, String className) async {
  final response =
      await http.get(Uri.parse('$apiUrl/results?ID=$raceid&class=$className'));

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Caricamento fallito');
  }
}

class ClassResultsRoute extends StatefulWidget {
  final String raceid;
  final String className;
  const ClassResultsRoute(this.raceid, this.className, {Key? key})
      : super(key: key);

  @override
  ClassResultsRouteState createState() => ClassResultsRouteState();
}

class ClassResultsRouteState extends State<ClassResultsRoute> {
  late Future<List<Map<String, dynamic>>> futureResult;

  @override
  void initState() {
    super.initState();
    futureResult = fetchResults(widget.raceid, widget.className);
  }

  Future<void> _refresh() async {
    setState(() {
      futureResult = fetchResults(widget.raceid, widget.className);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Risultati ${widget.className}'),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureResult,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var results = snapshot.data!;
              return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          //Gestione del primo risultato
                          if (results[index]["Result"][0][
                                  "FinishTime"] == //Caso FinishTime non specificato
                              null) {
                            return ResultBox(
                                '${results[index]["Person"][0]["Name"][0]["Family"][0]} ${results[index]["Person"][0]["Name"][0]["Given"][0]}',
                                '${results[index]["Organisation"]?[0]["Name"][0]}',
                                "Posizione: ${results[index]["Result"][0]["Position"]?[0]}",
                                "00:00:00",
                                index % 2);
                          }

                          String stringStart = //Calcolo finish-start
                              "${results[index]["Result"][0]["StartTime"][0]}";
                          stringStart = stringStart.split("T")[1];
                          stringStart = stringStart.split("+")[0];
                          String stringFinish =
                              "${results[index]["Result"][0]["FinishTime"][0]}";
                          stringFinish = stringFinish.split("T")[1];
                          stringFinish = stringFinish.split("+")[0];

                          Duration start = Duration(
                              hours: int.parse(stringStart.split(":")[0]),
                              minutes: int.parse(stringStart.split(":")[1]),
                              seconds: int.parse(stringStart.split(":")[2]));
                          Duration finish = Duration(
                              hours: int.parse(stringFinish.split(":")[0]),
                              minutes: int.parse(stringFinish.split(":")[1]),
                              seconds: int.parse(stringFinish.split(":")[2]));
                          Duration firstTime = finish - start;
                          return ResultBox(
                              '${results[index]["Person"][0]["Name"][0]["Family"][0]} ${results[index]["Person"][0]["Name"][0]["Given"][0]}',
                              '${results[index]["Organisation"]?[0]["Name"][0]}',
                              "Posizione: ${results[index]["Result"][0]["Position"]?[0]}",
                              firstTime.toString().split(".")[0],
                              index % 2);
                        } else if ("${results[index]["Result"][0]["Status"][0]}" !=
                            'OK') {
                          //Caso giocatore non classificato (timebehind=NC)
                          return ResultBox(
                              '${results[index]["Person"][0]["Name"][0]["Family"][0]} ${results[index]["Person"][0]["Name"][0]["Given"][0]}',
                              '${results[index]["Organisation"]?[0]["Name"][0]}',
                              "Posizione: ${results[index]["Result"][0]["Position"]?[0]}",
                              "NC",
                              index % 2);
                        } else {
                          //Altri risultati (si indica il timeBehind invece che il tempo impiegato)
                          Duration tBehind = Duration(
                              //time behind formattato
                              seconds: int.parse(
                                  "${results[index]["Result"][0]["TimeBehind"]?[0]}"));
                          return ResultBox(
                              '${results[index]["Person"][0]["Name"][0]["Family"][0]} ${results[index]["Person"][0]["Name"][0]["Given"][0]}',
                              '${results[index]["Organisation"]?[0]["Name"][0]}',
                              "Posizione: ${results[index]["Result"][0]["Position"]?[0]}",
                              "+${tBehind.toString().split(".")[0]}",
                              index % 2);
                        }
                      })));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _refresh;
          },
          child: const Icon(Icons.refresh)),
    );
  }
}
