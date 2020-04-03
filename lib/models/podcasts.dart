// Podcast is used on the podcast page
// Podcasts are pulling from Podbean

import '../globals/app_data.dart';

class Podcast {
  Podcast({this.title, this.date, this.summary, this.link, this.image});

  final String title;
  final String date;
  final String summary;
  final String link;
  final String image;

  factory Podcast.fromJson(Map<dynamic, dynamic> json) {
    final String title =
        json['title']['\$'] != null ? json['title']['\$'] : "Title missing";
    final String date = json['pubDate']['\$'] != null
        ? json['pubDate']['\$'].substring(0, json['pubDate']['\$'].length - 15)
        : "Date format error";
    final String summary = json['itunes:summary']['\$'] != null
        ? json['itunes:summary']['\$'].replaceAll("\\n", "\n")
        : "No summary found";
    final String link = json['link']['\$'] != null ? json['link']['\$'] : "";
    final String image = json['media:content']['@url'] != null
        ? json['media:content']['@url']
        : PODCAST_IMG_URL;
    return Podcast(
        title: title, date: date, summary: summary, link: link, image: image);
  }
}
