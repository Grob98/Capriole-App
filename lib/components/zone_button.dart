import 'package:capriole_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color firstColor = Color(0xff338BE1);
const Color secondColor = Color(0xff539EE8);
const Color markColor = Color(0xff3474B2);

class ZoneButton extends StatefulWidget {
  const ZoneButton({Key? key, required this.zoneName, this.onClick}) : super(key: key);

  final String zoneName;
  final Function(bool)? onClick;

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
        padding: const EdgeInsets.only(left: 18, top: 20, bottom: 20, right: 8),
        height: 100,
        //color: cardGrayColor,
        child: _buildLayout(),

        decoration: _buildCardBackground()
      )
    );
  }

  BoxDecoration _buildCardBackground() {
    return _zoneActive ? const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            firstColor,
            secondColor,
          ],
        ),
        color: cardGrayColor
    ) : const BoxDecoration(
        color: cardGrayColor
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
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: (_zoneActive ? Colors.white : secondaryColor)
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
          activeColor: markColor,
        )
      ]
    );
  }

  void _test(test) {
    setState(() {
      _zoneActive = test;
    });

    if (widget.onClick != null) {
      widget.onClick!(test);
    }
  }
}