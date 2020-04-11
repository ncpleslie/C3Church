import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../scoped-model/main.dart';
import '../widgets/service_card.dart';
import '../widgets/post_card.dart';
import '../themes/style.dart';
import '../globals/app_data.dart';
import '../widgets/nothing_loaded_card.dart';
import '../widgets/facebook_login_button.dart';
import '../widgets/error.dart';

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
    if (_loggedIn) {
      _postFuture = _model.getPosts();
    }
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
              //.then((_) => _autoLoginProcess()),
              )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          _model = model;
          _model.isLoggedIn.listen(
            (data) {
              if (data != _loggedIn && mounted) {
                setState(() {
                  _loggedIn = data;
                });
                if (_loggedIn) {
                  _postFuture = _model.getPosts();
                }
              }
            },
          );
          return _buildLoggedInLoggedOutListView();
        },
      ),
    );
  }

  Widget _buildLoggedInLoggedOutListView() {
    return _loggedIn
        ? LiquidPullToRefresh(
            showChildOpacityTransition: false,
            color: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).accentColor,
            onRefresh: _refresh,
            child: ListView(
              children: <Widget>[
                ServiceCard(_model),
                _loggedIn
                    ? _buildFutureListView(context)
                    : FacebookLoginButton(_initLoginProcess)
              ],
            ),
          )
        : ListView(
            children: <Widget>[
              ServiceCard(_model),
              _loggedIn
                  ? _buildFutureListView(context)
                  : FacebookLoginButton(_initLoginProcess)
            ],
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
          return Error(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: _posts != null ? _posts.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return PostCard(
          model: _model,
          id: _posts[index].id,
          imgUrl: _posts[index].picture,
          fullImgUrl: _posts[index].fullPicture,
          message: _posts[index].message,
          createdTime: _posts[index].createdTime,
          link: _posts[index].link,
          story: _posts[index].story,
          statusType: _posts[index].statusType,
          comments: _posts[index].comments,
          video: _posts[index].video,
        );
      },
    );
  }

  Future _refresh() {
    if (_loggedIn) {
      _postFuture = _model.getPosts();
      return _postFuture;
    }
    return null;
  }

  void _initLoginProcess() {
    _postFuture = null;
    _loggedIn = false;
    _model.login();
  }
}
