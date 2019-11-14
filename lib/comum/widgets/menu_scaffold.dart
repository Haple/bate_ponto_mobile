import 'package:flutter/material.dart';

import 'menu.dart';

class MenuScaffold extends StatelessWidget {
  const MenuScaffold(
      {@required this.body,
      @required this.pageTitle,
      this.floatButton,
      Key key})
      : super(key: key);

  final Widget body;
  final Widget floatButton;
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    return Row(
      children: [
        if (!displayMobileLayout)
          const Menu(
            permanentlyDisplay: true,
          ),
        Expanded(
          child: Scaffold(
            floatingActionButton: floatButton,
            appBar: displayMobileLayout
                ? AppBar(
                    automaticallyImplyLeading: displayMobileLayout,
                    title: Text(pageTitle),
                  )
                : null,
            drawer: displayMobileLayout
                ? const Menu(
                    permanentlyDisplay: false,
                  )
                : null,
            body: body,
          ),
        )
      ],
    );
  }
}
