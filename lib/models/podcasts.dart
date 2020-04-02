// Podcast is used on the podcast page
// Podcasts are pulling from Podbean

class Podcast {
  Podcast({this.title, this.date, this.summary, this.link});

  final String title;
  final String date;
  final String summary;
  final String link;

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
        title: json['title'] != null ? json['title'] : "Title missing",
        date: json['pubDate'] != null
            ? json['pubDate'].substring(0, json['pubDate'].length - 15)
            : "Date format error",
        summary: json['itunes:summary'] != null
            ? json['itunes:summary'].replaceAll("\\n", "\n")
            : "No summary found",
        link: json['link'] != null ? json['link'] : "");
  }
}
