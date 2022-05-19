import 'dart:convert';

import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  final String persName;
  final String? orgName;
  final String? position;
  final String? timeBehind;
  final int colorSel; //0->even, 1->odd, 2->new
  const ResultBox(this.persName, this.orgName, this.position, this.timeBehind,
      this.colorSel,
      {Key? key})
      : super(key: key);

  Color selectColor(int colorSel) {
    colorSel = this.colorSel;
    if (colorSel == 0) {
      return Colors.grey;
    } else if (colorSel == 1) {
      return const Color.fromARGB(255, 212, 212, 212);
    } else {
      return const Color.fromARGB(255, 251, 244, 118);
    }
  }

  Text org(String? orgName) {
    if (orgName == null) {
      return const Text("NoORg");
    } else {
      return Text(utf8.decode(orgName.runes.toList()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: selectColor(colorSel),
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    utf8.decode(persName.runes.toList()), //Alto sinistra
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Text(position!,
                    style: const TextStyle(fontSize: 20)), //Alto destra
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  //Basso sinistra
                  alignment: Alignment.bottomLeft,
                  child: org(orgName),
                ),
                Text(timeBehind!), //Basso destra
              ],
            )
          ],
        ),
      ),
    );
  }
}
