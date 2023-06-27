class RejectDataModel {
  int success;
  String message;

  RejectDataModel({
    required this.success,
    required this.message,
  });

  factory RejectDataModel.fromMap(Map<String, dynamic> json) => RejectDataModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
  };
}
