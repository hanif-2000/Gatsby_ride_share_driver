class NotificationEntity {
  String? notificationTypeId;
  String? badge;
  String? sound;
  String? body;
  String? title;
  String? message;
  String? image;
  String? order_id;

  NotificationEntity(
      {this.notificationTypeId,
      this.badge,
      this.sound,
      this.body,
      this.title,
      this.message,
      this.image,this.order_id});

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    notificationTypeId = json['notificationTypeId'];
    badge = json['badge'];
    sound = json['sound'];
    body = json['body'];
    title = json['title'];
    message = json['message'];
    image = json['image'];
    order_id = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationTypeId'] = notificationTypeId;
    data['badge'] = badge;
    data['sound'] = sound;
    data['image'] = image;
    data['body'] = body;
    data['title'] = title;
    data['message'] = message;
    data['order_id'] = order_id;
    return data;
  }
}
