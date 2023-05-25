class ImageUploadResponse {
  int? success;
  String? message;
  String? fileName;

  ImageUploadResponse({
    this.success,
    this.message,
    this.fileName,
  });

  factory ImageUploadResponse.fromMap(Map<String, dynamic> json) =>
      ImageUploadResponse(
        success: json["success"],
        message: json["message"],
        fileName: json["fileName"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "fileName": fileName,
      };
}
