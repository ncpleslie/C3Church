import 'package:flutter/material.dart';

import '../widgets/nothing_loaded_card.dart';
import '../widgets/error.dart';

class FutureListView extends StatefulWidget {
  final Function onLoad;
  final Function onUpdate;
  final Function listView;
  final String type;
  FutureListView({this.onLoad, this.onUpdate, this.listView, this.type});
  @override
  State<StatefulWidget> createState() {
    return _FutureListView(
        this.onLoad, this.onUpdate, this.listView, this.type);
  }
}

class _FutureListView extends State<FutureListView> {
  final Function onLoad;
  final Function onUpdate;
  final Function listView;
  final String type;
  _FutureListView(this.onLoad, this.onUpdate, this.listView, this.type);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: onLoad(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // If can't find posts then display an error card
          // giving the user the option to refresh
          if (snapshot.data == null || snapshot.data.length == 0) {
            return NothingLoadedCard(
                title: "No $type",
                subtitle: "It seems like there are no $type. Strange...",
                onPressed: onUpdate);
          }
          // Display the Post tiles
          return listView(snapshot.data);
        } else if (snapshot.hasError) {
          // If error, for whatever reason, display an error widget
          // with ability for user to refresh
          return Error(
            onPressed: onUpdate,
            errorStatement: snapshot.error.toString(),
          );
        }
        // Show progress bar by default
        return Center(child: LinearProgressIndicator());
      },
    );
  }
}
