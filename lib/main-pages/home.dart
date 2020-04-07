import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../widgets/service_card.dart';
import '../widgets/post_card.dart';
import '../themes/style.dart';
import '../globals/app_data.dart';
import '../widgets/nothing_loaded_card.dart';
import '../widgets/facebook_login_button.dart';
import '../widgets/facebook_error.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _posts;
  MainModel _model;
  Future _postFuture;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _model = ScopedModel.of(context);
    _autoLoginProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            appLogo,
            SizedBox(
              width: 10,
            ),
            Text(
              APP_NAME,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.pushNamed(context, 'settings')
                .then((_) => _autoLoginProcess()),
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          _model = model;
          return ListView(
            children: <Widget>[
              ServiceCard(_model),
              _loggedIn
                  ? _buildFutureListView(context)
                  : FacebookLoginButton(_initLoginProcess)
            ],
          );
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: _posts != null ? _posts.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return PostCard(
            model: _model,
            id: _posts[index].id,
            imgUrl: _posts[index].picture,
            message: _posts[index].message,
            createdTime: _posts[index].createdTime);
      },
    );
  }

  Widget _buildFutureListView(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _postFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _posts = snapshot.data;
          if (_posts == null || _posts.length == 0) {
            return NothingLoadedCard(
                title: "No Posts",
                subtitle: "It seems like there are no posts. Strange...",
                callback: _refresh);
          }
          return _buildListView();
        } else if (snapshot.hasError) {
          return FacebookError(snapshot.error);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _refresh() {
    print("Refreshing");
  }

  void _autoLoginProcess() {
    setState(() {
      _postFuture = null;
      _loggedIn = false;
      _model.tryAutoLogin().then((_) {
        _loggedIn = _model.isLoggedIn;
        if (_loggedIn) {
          _postFuture = _model.getPosts();
        }
      });
    });
  }

  void _initLoginProcess() {
    setState(() {
      _postFuture = null;
      _loggedIn = false;
      _model.login().then((_) {
        _loggedIn = _model.isLoggedIn;
        if (_loggedIn) {
          _postFuture = _model.getPosts();
        }
      });
    });
  }
}
