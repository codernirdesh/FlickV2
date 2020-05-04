class Detail {
  var moviekey,
      videourl,
      runtime,
      budget,
      revenue,
      voteCount,
      movieid,
      releasedate,
      title,
      plot,
      imdbid,
      tagline,
      homepage,
      adult,
      backdropimg,
      posterimg,
      voteAverage,
      popularity,
      originallanguage;
  List<Genre> genre;
  
  Detail({
    this.adult,
    this.backdropimg,
    this.budget,
    this.movieid,
    this.title,
    this.homepage,
    this.imdbid,
    this.plot,
    this.popularity,
    this.posterimg,
    this.releasedate,
    this.revenue,
    this.runtime,
    this.tagline,
    this.voteAverage,
    this.voteCount,
    this.originallanguage,
    this.genre,
  });

  factory Detail.jsonparse(Map json) {
    return Detail(
      adult: json['adult'],
      backdropimg: json['backdrop_path'],
      budget: json['budget'],
      homepage: json['homepage'],
      movieid: json['id'],
      imdbid: json['imdb_id'],
      title: json['title'],
      plot: json['overview'],
      popularity: json['popularity'],
      posterimg: json['poster_path'],
      releasedate: json['release_date'],
      revenue: json['revenue'],
      runtime: json['runtime'],
      tagline: json['tagline'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      originallanguage: json['original_language'],
      genre: parseGenre(json),
    );
  }

  static List<Genre> parseGenre(json){
    var list = json['genres'] as List;
    List<Genre> genreList = list.map((data)=> Genre.jsonParse(data)).toList();
    return genreList;
  }

  Map toJson() {
    final Map data = Map();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropimg;
    data['budget'] = this.budget;
    data['homepage'] = this.homepage;
    data['id'] = this.movieid;
    data['imdb_id'] = this.imdbid;
    data['title'] = this.title;
    data['overview'] = this.plot;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterimg;
    data['release_date'] = this.releasedate;
    data['revenue'] = this.revenue;
    data['runtime'] = this.runtime;
    data['tagline'] = this.tagline;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['original_language'] = this.originallanguage;
    data['genres'] = this.genre;
    return data;
  }
}

class Genre{
  final String name;
  final dynamic id;

  Genre({this.name, this.id});

  factory Genre.jsonParse(json){
    return Genre(
      id: json['id'],
      name: json['name']
    );
  }

}

class Videos {
  String key;

  Videos({this.key});

  factory Videos.jsonParse(Map json) {
    var videos = json['results'];
    if (videos.isEmpty) {
      return Videos(key: 'null');
    }
    return Videos(key: json['results'][0]['key']);
  }
}




class MovieReviews {
  MovieReviews({this.results, this.reviewList});
  final List results;
  final List<ReviewList> reviewList;

  factory MovieReviews.fromJson(json) {
    return MovieReviews(results: json['results'], reviewList: parseReviewList(json));
  }

  static List<ReviewList> parseReviewList(json) {
    var list = json['results'] as List;
    List<ReviewList> reviewlist =
        list.map((data) => ReviewList.fromList(data)).toList();
    return reviewlist;
  }
}

class ReviewList {
  ReviewList({this.author, this.content, this.userid});
  final String author;
  final String content;
  final String userid;

  factory ReviewList.fromList(json) {
    return ReviewList(
        author: json['author'], content: json['content'], userid: json['id']);
  }
}
