import 'dart:convert';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String tl;
  final String tr;
  final String bl;
  final String br;
  const MenuButton(this.tl, this.tr, this.bl, this.br, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                utf8.decode(tl.runes.toList()),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            )), //Alto sinistra,

            Flexible(
                child: Text(utf8.decode(tr.runes.toList()),
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis)), //Alto destra
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Text(utf8.decode(bl.runes.toList()),
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis)), //Basso sinistra,

            Flexible(
                child: Text(
              utf8.decode(br.runes.toList()), //Basso Destra
              style: const TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            )) //Basso destra
          ],
        )
      ],
    ));
  }
}