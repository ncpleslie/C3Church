import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../scoped-model/main.dart';
import '../widgets/service_card.dart';
import '../widgets/post_card.dart';
import '../themes/style.dart';
import '../globals/app_data.dart';
import '../widgets/facebook_login_button.dart';
import '../widgets/future_list_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  MainModel _model;
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          _model = model;
          _checkLoggedInState();
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
            onRefresh: _model.updatePosts,
            child: ListView(
              children: <Widget>[
                ServiceCard(_model),
                FutureListView(
                    onLoad: _model.getPosts,
                    onUpdate: _model.updatePosts,
                    listView: _buildListView,
                    type: 'posts'),
              ],
            ),
          )
        : ListView(
            children: <Widget>[ServiceCard(_model), FacebookLoginButton()],
          );
  }

  ListView _buildListView(List<dynamic> posts) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: posts != null ? posts.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return PostCard(
          model: _model,
          id: posts[index].id,
          imgUrl: posts[index].picture,
          fullImgUrl: posts[index].fullPicture,
          message: posts[index].message,
          createdTime: posts[index].createdTime,
          link: posts[index].link,
          story: posts[index].story,
          statusType: posts[index].statusType,
          comments: posts[index].comments,
          video: posts[index].video,
        );
      },
    );
  }

  Widget _buildTitleBar() {
    return Row(
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
    );
  }

  List<Widget> _buildActionButton() {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.settings,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () => Navigator.pushNamed(context, 'settings'),
      )
    ];
  }

  Widget _buildAppBar() {
    return AppBar(
      title: _buildTitleBar(),
      centerTitle: true,
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      actions: _buildActionButton(),
    );
  }

  void _checkLoggedInState() {
    _model.isLoggedIn.listen(
      (data) {
        if (data != _loggedIn && mounted) {
          setState(
            () {
              _loggedIn = data;
            },
          );
        }
      },
    );
  }
}
