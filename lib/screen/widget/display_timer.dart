import 'package:flutter/material.dart';

class DisplayTimer extends StatelessWidget {
  const DisplayTimer({
    super.key,
    required this.title,
    required this.totalSec,
    required this.backgroundColor,
    required this.textColor,
  });

  final String title;
  final int totalSec;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._decoratedString(_remainHours(totalSec)),
            const Text(
              ' : ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ..._decoratedString(_remainSec(totalSec)),
          ],
        )
      ],
    );
  }

  List<Widget> _decoratedString(String str) {
    List<Widget> singleSplit = [];

    if (str.length == 1) {
      singleSplit.add(_decoratedChar('0'));
      singleSplit.add(_decoratedChar(str[0]));
    } else {
      singleSplit.add(_decoratedChar(str[0]));
      singleSplit.add(_decoratedChar(str[1]));
    }

    return singleSplit;
  }

  Widget _decoratedChar(String c) {
    return Container(
      margin: const EdgeInsets.all(3),
      height: 40,
      width: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Text(
          c,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  String _remainHours(int sec) {
    return (sec ~/ 60).toString();
  }

  String _remainSec(int sec) {
    return (sec % 60).toString();
  }
}
