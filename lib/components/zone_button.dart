import 'package:capriole_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZoneButton extends StatefulWidget {
  const ZoneButton({Key? key, required this.zoneName}) : super(key: key);

  final String zoneName;

  @override
  State<ZoneButton> createState() => _ZoneButtonState();
}

class _ZoneButtonState extends State<ZoneButton> {

  var _zoneActive = true;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        padding: const EdgeInsets.only(left: 18, top: 20, bottom: 20),
        height: 100,
        color: cardGrayColor,
        child: _buildLayout(),
      )
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Zone",
      style: TextStyle(
        fontSize: 20,
        color: lightGrayColor
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      widget.zoneName,
      style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryColor
      ),
    );
  }

  Widget _buildLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle(),
              _buildSubtitle()
            ]
          )
        ),
        CupertinoSwitch(
          value: _zoneActive,
          onChanged: _test,
          activeColor: Colors.blue,
        )
      ]
    );
  }

  void _test(test) {
    setState(() {
      _zoneActive = test;
    });
  }
}