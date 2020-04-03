import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../themes/style.dart';

class NotificationCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String message;
  final Function callback;
  NotificationCard({this.context, this.title, this.message, this.callback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: InkWell(
          onTap: () => [callback(), OverlaySupportEntry.of(context).dismiss()],
          child: ListTile(
            leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: appLogo),
            ),
            title: Text(title),
            subtitle: Text(message),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                }),
          ),
        ),
      ),
    );
  }
}
