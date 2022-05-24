import 'dart:convert';
import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final String tl;
  final String isNew;
  final String bl;
  final String br;
  const MainMenuButton(this.tl, this.isNew, this.bl, this.br, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(columnWidths: {
      0: FlexColumnWidth(MediaQuery.of(context).size.width * 0.49),
      1: FlexColumnWidth(MediaQuery.of(context).size.width * 0.07),
      2: FlexColumnWidth(MediaQuery.of(context).size.width * 0.20),
      3: FlexColumnWidth(MediaQuery.of(context).size.width * 0.20)
    }, children: <TableRow>[
      TableRow(children: [
        Column(
          children: [
            Row(
              children: [Text(tl)],
            ),
            Row(
              children: [Text(bl)],
            )
          ],
        ),
        Column(
          children: [Text("N\nE\nW")],
        ),
        Column(
          children: [ElevatedButton(onPressed: null, child: Text("Start"))],
        ),
        Column(
          children: [ElevatedButton(onPressed: null, child: Text("Result"))],
        )
      ])
    ]);
  }
}
