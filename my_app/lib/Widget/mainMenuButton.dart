import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oriresults/Route/classResultsRoute.dart';
import 'package:oriresults/Route/classStartRoute.dart';
import 'package:oriresults/Route/classesRoute.dart';

class MainMenuButton extends StatelessWidget {
  final String tl;
  final String isNew;
  final String bl;
  final String raceid;
  const MainMenuButton(this.tl, this.bl, this.isNew, this.raceid, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: FlexColumnWidth(MediaQuery.of(context).size.width * 0.49),
          1: FlexColumnWidth(MediaQuery.of(context).size.width * 0.07),
          2: FlexColumnWidth(MediaQuery.of(context).size.width * 0.20),
          3: FlexColumnWidth(MediaQuery.of(context).size.width * 0.20)
        },
        children: <TableRow>[
          TableRow(children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      '$tl\n',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      bl,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15),
                    ))
                  ],
                )
              ],
            ),
            Column(
              children: [
                Text(
                  isNew,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassesRoute(raceid, "Start")),
                    );
                  },
                  child: Text("Start"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightGreen)),
                )
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ClassesRoute(raceid, "Result")),
                      );
                    },
                    child: Text("Result"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreen)))
              ],
            )
          ])
        ]);
  }
}