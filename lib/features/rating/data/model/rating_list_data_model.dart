class RatingListDataModel {
  int success;
  String message;
  double rating;
  List<RatingItem> list;
  int ratingCount;

  RatingListDataModel({
    required this.success,
    required this.message,
    required this.rating,
    required this.list,
    required this.ratingCount,
  });

  factory RatingListDataModel.fromMap(Map<String, dynamic> json) =>
      RatingListDataModel(
        success: json["success"],
        message: json["message"],
        rating: json["rating"] != null
            ? double.parse(json["rating"].toString())
            : 0,
        list: List<RatingItem>.from(
            json["list"].map((x) => RatingItem.fromMap(x))),
        ratingCount: json["ratingCount"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "rating": rating,
        "list": List<dynamic>.from(list.map((x) => x.toMap())),
        "ratingCount": ratingCount,
      };
}

class RatingItem {
  int id;
  String name;
  String image;
  double rating;
  String review;
  DateTime createdAt;

  RatingItem({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory RatingItem.fromMap(Map<String, dynamic> json) => RatingItem(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        rating: json["rating"] != null
            ? double.tryParse(json["rating"].toString())!
            : 0.0,
        review: json["review"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
      };
}
