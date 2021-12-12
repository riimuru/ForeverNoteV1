import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import '../models/light_dark.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings>{
  var testtog = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: context.watch<LightDark>().opiton ? const Color.fromRGBO(255, 253, 237, 1.0) : const Color.fromRGBO(41, 39, 33, 1.0),
      body: SafeArea(
        child: ColoredBox(
          color: context.watch<LightDark>().opiton ? const Color.fromRGBO(255, 253, 237, 1.0) : const Color.fromRGBO(41, 39, 33, 1.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text("Appearance", style: TextStyle(color: context.watch<LightDark>().opiton ? Colors.black : Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: FlutterSwitch(
                  value: context.watch<LightDark>().opiton, 
                  onToggle: (value) { 
                    setState(() => Provider.of<LightDark>(context, listen: false).toggle());
                  },
                  activeIcon: const Icon(Icons.wb_sunny, color: Colors.yellow, size: 60.0),
                  activeToggleColor: Colors.blue[900],
                  inactiveIcon: const Icon(Icons.nightlight, color: Colors.amber, size: 60.0),
                  inactiveToggleColor: Colors.purple[900],
                  activeSwitchBorder: Border.all(width: 2.5, color: Colors.black),
                  inactiveSwitchBorder: Border.all(width: 2.5, color: Colors.grey),
                  inactiveColor: Colors.white,
                  inactiveToggleBorder: Border.all(width: 2.0, color: Colors.blue),
                  activeToggleBorder: Border.all(width: 2.0, color: Colors.white),
                  height: 40.0,
                  width: 90.0,
                  toggleSize: 30.0,
                )
                )
              ],
            ),
            Container(padding: const EdgeInsets.fromLTRB(0, 15, 0, 15), child: Divider(thickness: 2.0, indent: 10.0, endIndent: 10.0, color: context.watch<LightDark>().opiton ? Colors.black : Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text("Delete Everything", style: TextStyle(color: context.watch<LightDark>().opiton ? Colors.black : Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Icon(Icons.delete, color: Colors.black),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                    )
                  )
                )
              ],
            )
          ],
        )
        )
      )
    );
  }
}
