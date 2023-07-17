







class Movie{

  final String backdriop_path;
  final String title;
  final String poster_path;
  final int id;
  final String overview;
  final String vote_average;


  Movie({
    required this.id,
    required this.backdriop_path,
    required this.overview,
    required this.poster_path,
    required this.title,
    required this.vote_average
});

  factory Movie.fromJson(Map<String, dynamic> json){
     return Movie(
         id: json['id'],
         backdriop_path: json['backdriop_path'],
         overview: json['overview'],
         poster_path: json['poster_path'],
         title: json['title'],
         vote_average: json['vote_average']
     );
  }


}