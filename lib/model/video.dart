


class Video{


 final String name;
 final String key;
 final String id;

 Video({
   required this.id,
   required this.key,
   required this.name
});



 factory Video.fromJson(Map<String, dynamic> json){
   return Video(
     id: json['id'],
     key: json['key'],
     name: json['name']
   );
 }



}