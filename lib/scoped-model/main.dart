import 'package:scoped_model/scoped_model.dart';

import './connected_model.dart';
import './podcast_model.dart';
import './calendar_model.dart';
import './post_model.dart';

class MainModel extends Model
    with
        ConnectedModel,
        PodcastModel,
        CalendarModel,
        PostModel,
        UrlLauncher,
        Notifications,
        Auth {}
