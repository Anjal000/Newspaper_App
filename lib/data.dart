class NewsData{
  late String newsHead;
  late String newsDes;
  late String newsImg;
  late String newsUrl;

  NewsData({this.newsHead="NEWS HEADLINE",this.newsDes="NEWS DESCRIPTION",this.newsImg="NEWS IMAGE",this.newsUrl="NEWS URL"});

  factory NewsData.fromMap(Map news){
    return NewsData(
      newsHead: news["title"],
      newsDes: news["description"],
      newsImg: news["urlToImage"],
      newsUrl: news["url"]
    );
  }
}