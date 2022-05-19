import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:html';

import 'package:flutter/material.dart'; //Serve sempre
import 'package:http/http.dart' as http; //Import di funzioni http
import 'package:oriresults/Widget/menuButton.dart';

import 'Route/classesRoute.dart'; //Altro file .dart per definire la schermata

const apiUrl =
    'https://cghd6kwn0k.execute-api.us-east-1.amazonaws.com'; //URL dell' API

//Funzione che fa il fetch dei dati
Future<List<Map<String, dynamic>>> fetchRaces() async {
  //Una Future è come una Promise
  //La funzione restituisce Una Future contenente una lista di Map (JSON)
  //la cui chiave è una stringa di tipo dinamico

  //E' una funzione asincrona per recuperare la lista delle gare
  //Le recupera dall'endopoint /list_races

  //come prima cosa fa una get sull'endpoint
  final response = await http.get(Uri.parse('$apiUrl/list_races'));

  if (response.statusCode == 200) {
    //Se ottengo statusCode = 200 allora restituisco il JSON ottenuto dal fetch
    //decodificato
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    //Se non ottengo 200 allora lancio un' eccezione
    throw Exception('Caricamento fallito');
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Homepage',
    home: MyApp(),
  ));
}
//Nel main si crea l'app come widget MaterialApp con titolo e home la classe
//MyApp

class MyApp extends StatefulWidget {
  //My app  uno stateful widget (mantiene le gare caricate)
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
  //Faccio partire lo stato da _MyAppState
}

class _MyAppState extends State<MyApp> {
  late Future<List<Map<String, dynamic>>> futureRaces;
  //Inizializzo la variabile futureRaces come late, ovvero definita dopo
  //In questo caso viene definita quando si chiama initState

  @override
  void initState() {
    //Determino lo stato iniziale
    super.initState(); //Stato iniziale precedente
    futureRaces = fetchRaces(); //+ fetch delle gare
  }

  Future<void> _refresh() async {
    setState(() {
      futureRaces = fetchRaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold è il container a più alto livello
      appBar: AppBar(
        //Contiene un app bar
        title: const Text('Gare disponibili'), //Con title un Text
      ),
      body: Center(
        //Il body è un center (contenuto centrato) che avrà una serie di child
        child: FutureBuilder<List<Map<String, dynamic>>>(
          //I figli sono dei FutureBuilder
          //ovvero widget costruiti quando avrò i dati disponibili
          future: futureRaces, //Il future è futureRaces
          builder: (context, snapshot) {
            //Bisogna definire come funziona il FutureBuilder
            //snapshot conterrà la Future quando disponibile
            if (snapshot.hasData) {
              //Se snapshot contiene dei dati
              var races = snapshot.data!;
              //le categorie sono prese da snapshot.data
              //snapshot.data era un oggetto Nullable (poteva essere nullo)
              //tramite il ! inizializziamo races come non Nullable (non può essere null)
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  //Ritorniamo una Lista
                  itemCount: races.length, //Il numero di item è casses.length
                  itemBuilder: ((context, index) => ElevatedButton(
                        //Ogni item è un bottone
                        onPressed: () {
                          //Quando si preme il bottone
                          Navigator.push(
                            //Mi muovo in un altra pagina
                            context,
                            MaterialPageRoute(
                                //Specifico la pagina in cui andare
                                builder: (context) =>
                                    ClassesRoute(races[index]["ID"])),
                            //Schermata definita nel secondo file .dart
                          );
                        },
                        style: MenuButton,
                        child: Text(races[index]["NomeGara"]),
                        //Il bottone contiene il nome della categoria dell'indice giusto
                      )),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            //Se invece snapshot contiene un errore, lo mostriamo

            return const CircularProgressIndicator();
            //Di base mostriamo un caricamento (prima di aver ricevuto i dati)
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _refresh;
          },
          child: const Icon(Icons.refresh_rounded)),
    );
  }
}
