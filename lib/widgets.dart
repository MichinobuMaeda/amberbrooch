import 'package:flutter/material.dart';

class LoadingStatus extends Widget {
  final String message;
  final Color? color;
  final List<Widget> subsequents;

  const LoadingStatus({
    Key? key,
    required this.message,
    this.color,
    this.subsequents = const [],
  }) : super(key: key);

  @override
  Element createElement() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 24.0,
                  color: color,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ] +
          subsequents,
    ).createElement();
  }
}
