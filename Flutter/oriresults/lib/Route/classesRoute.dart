import 'dart:convert';
import 'dart:async';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oriresults/Route/classResultsRoute.dart';

const apiUrl = 'https://cghd6kwn0k.execute-api.us-east-1.amazonaws.com';

Future<List<String>> fetchClasses(String raceid) async {
  //Come nella schermata precedente si crea una funzione di fetch per il caricamento
  //questa volta delle categorie di una certa gara identificata con il suo id

  final response = await http.get(Uri.parse('$apiUrl/list_classes?ID=$raceid'));

  if (response.statusCode == 200) {
    return List<String>.from(jsonDecode(response.body));
  } else {
    //Se non ottengo 200 allora lancio un' eccezione
    throw Exception('Caricamento fallito');
  }
}

class ClassesRoute extends StatefulWidget {
  final String raceid;
  const ClassesRoute(this.raceid, {Key? key}) : super(key: key);

  @override
  ClassesRouteState createState() => ClassesRouteState();
}

class ClassesRouteState extends State<ClassesRoute> {
  late Future<List<String>> futureClasses;

  @override
  void initState() {
    super.initState();
    futureClasses = fetchClasses(widget.raceid);
  }

  Future<void> _refresh() async {
    setState(() {
      futureClasses = fetchClasses(widget.raceid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorie'),
      ),
      body: Center(
          child: FutureBuilder<List<String>>(
              future: futureClasses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> classes = snapshot.data!;
                  return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                          itemCount: classes.length,
                          itemBuilder: ((context, index) => ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClassResultsRoute(widget.raceid,
                                                  classes[index])));
                                },
                                child: Text(classes[index]),
                              ))));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.data}');
                }

                return const CircularProgressIndicator();
              })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _refresh;
          },
          child: const Icon(Icons.refresh)),
    );
  }
}
