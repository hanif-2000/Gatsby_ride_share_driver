class RatingModel {
  int? success;
  String? message;

  RatingModel({
    this.success,
    this.message,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
