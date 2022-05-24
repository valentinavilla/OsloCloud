import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:html';

import 'package:flutter/material.dart'; //Serve sempre
import 'package:http/http.dart' as http; //Import di funzioni http
import 'package:oriresults/Route/startOrResultsRoute.dart';
import 'package:oriresults/Widget/mainMenuButton.dart';
import 'package:oriresults/Widget/menuButton.dart';
import 'package:oriresults/Widget/menuButtonStyle.dart';

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

  late List<Map<String, dynamic>> races;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  //Inizializzo la variabile futureRaces come late, ovvero definita dopo
  //In questo caso viene definita quando si chiama initState

  @override
  void initState() {
    //Determino lo stato iniziale
    super.initState(); //Stato iniziale precedente
    futureRaces = fetchRaces(); //+ fetch delle gare
  }

  Future<void> _refresh() async {
    List<Map<String, dynamic>> oldData = races;
    setState(() {
      futureRaces = fetchRaces();
      futureRaces.then((newData) => {
            newData.forEach((element) {
              var found = false;
              oldData.forEach((oldElement) {
                if (element["ID"] == oldElement["ID"]) {
                  found = true;
                }
              });
              if (found) {
                element["isNew"] = false;
              } else {
                element["isNew"] = true;
              }
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold è il container a più alto livello
      appBar: AppBar(
        //Contiene un app bar
        title: RichText(
          // Il titolo contiene un' icona
          text: const TextSpan(
            //Qua si può modificare lo stile del titolo
            //style: , //Theme.of(context).textTheme.body1,
            children: [
              TextSpan(
                  text: 'Gare disponibili',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(Icons.directions_run),
                ),
              ),
            ],
          ),
        ),

        // Se si vuole aggiungere la dark mode

        /*actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: (){
              Get.isDarkMode
                ? Get.changeTheme(ThemeData.light())
                : Get.changeTheme(ThemeData.dark());
            })
        ],*/

        centerTitle: true, //centrato
        backgroundColor: Color.fromARGB(255, 97, 206, 100),
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
              races = snapshot.data!;
              //le categorie sono prese da snapshot.data
              //snapshot.data era un oggetto Nullable (poteva essere nullo)
              //tramite il ! inizializziamo races come non Nullable (non può essere null)
              return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: Colors.lightGreen,
                  strokeWidth: 4.0,
                  onRefresh: _refresh,
                  child: ListView.builder(
                      //Ritorniamo una Lista
                      itemCount:
                          races.length, //Il numero di item è casses.length
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.height * 0.01,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.height * 0.01),
                      itemBuilder: ((context,
                                  index) => /*DropdownButton<String>(
                            value: "",
                            items: [
                              DropdownMenuItem(
                                  child: MenuButton("Start", "", "", ""),
                                  value: "Start"),
                              DropdownMenuItem(
                                  child: MenuButton("Result", "", "", ""),
                                  value: "Result")
                            ],
                            onChanged: (String? value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClassesRoute(
                                          races[index]["ID"], value)));
                            },*/
                              ElevatedButton(
                                //Ogni item è un bottone
                                onPressed: () {
                                  //Quando si preme il bottone
                                  Navigator.push(
                                    //Mi muovo in un altra pagina
                                    context,
                                    MaterialPageRoute(
                                        //Specifico la pagina in cui andare
                                        builder: (context) =>
                                            StartOrResultRoute(
                                                races[index]["ID"])),
                                    //Schermata definita nel secondo file .dart
                                  );
                                },
                                style: menuButtonStyle(),

                                child: MainMenuButton(
                                  '${races[index]["DataGara"]}',
                                  isNuovo(races[index]),
                                  '${races[index]["NomeGara"]}',
                                  "",
                                ),
                              )
                          //Il bottone contiene il nome della categoria dell'indice giusto
                          )));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            //Se invece snapshot contiene un errore, lo mostriamo

            return const CircularProgressIndicator(color: Colors.lightGreen);
            //Di base mostriamo un caricamento (prima di aver ricevuto i dati)
          },
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            //style:,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
            child: Text('Menù'),
          ),
          ListTile(
            //style: ,
            title: RichText(
              // Il titolo contiene un' icona
              text: const TextSpan(
                //Qua si può modificare lo stile del titolo
                //style: , //Theme.of(context).textTheme.body1,
                children: [
                  WidgetSpan(
                    child: Icon(Icons.account_circle),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                  ),
                  TextSpan(text: 'Account'),
                ],
              ),
            ),
            onTap: () {
              //update the state, se si vuole navigare in un'altra pagina
              Navigator.pop(context);
            },
          ),
          ListTile(
            //style: ,
            title: RichText(
              // Il titolo contiene un' icona
              text: const TextSpan(
                //Qua si può modificare lo stile del titolo
                //style: , //Theme.of(context).textTheme.body1,
                children: [
                  WidgetSpan(child: Icon(Icons.settings)),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                  ),
                  TextSpan(text: 'Settings'),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      )),

      //Pulsante per il refresh
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show refresh indicator programmatically on button tap.
          _refreshIndicatorKey.currentState?.show();
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}

isNuovo(race) {
  if (race["isNew"] != null) {
    if (race["isNew"]) {
      return ("NUOVO");
    }
  }
  return ("");
}
