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
        success: json["status"] == true ? 1 : (json["success"] ?? 0),
        message: json["message"],
        fileName: json["filename"] ?? json["fileName"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "fileName": fileName,
      };
}
