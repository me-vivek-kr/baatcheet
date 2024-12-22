import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final String _barTitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final double? fontSize;

  late double deviceHeight;
  late double deviceWidth;

  Topbar(
    this._barTitle, {
    super.key,
    this.primaryAction,
    this.secondaryAction,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI() {
    return Container(
      height: deviceHeight * 0.10,
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          Expanded(
            child: _titleBar(),
          ),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize ?? 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
