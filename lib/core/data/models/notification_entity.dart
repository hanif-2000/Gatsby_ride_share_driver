class NotificationEntity {
  String? image;
  String? distance;
  String? body;
  String? type;
  String? title;
  String? actualTime;
  String? pendingAmount;
  String? newTotal;
  String? total;
  String? phone;
  String? endCoordinate;
  String? startAddress;
  String? startCoordinate;
  String? customerID;
  String? name;
  String? endAddress;
  String? id;
  String? paymentMethod;
  String? estimatedTime;

  NotificationEntity(
      {this.image,
        this.distance,
        this.body,
        this.type,
        this.title,
        this.actualTime,
        this.pendingAmount,
        this.newTotal,
        this.total,
        this.phone,
        this.endCoordinate,
        this.startAddress,
        this.startCoordinate,
        this.customerID,
        this.name,
        this.endAddress,
        this.id,
        this.paymentMethod,
        this.estimatedTime});

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    distance = json['distance'];
    body = json['body'];
    type = json['type'];
    title = json['title'];
    actualTime = json['actual_time'];
    pendingAmount = json['pending_amount'];
    newTotal = json['new_total'];
    total = json['total'];
    phone = json['phone'];
    endCoordinate = json['end_coordinate'];
    startAddress = json['start_address'];
    startCoordinate = json['start_coordinate'];
    customerID = json['customerID'];
    name = json['name'];
    endAddress = json['end_address'];
    id = json['id'];
    paymentMethod = json['payment_method'];
    estimatedTime = json['estimated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['distance'] = distance;
    data['body'] = body;
    data['type'] = type;
    data['title'] = title;
    data['actual_time'] = actualTime;
    data['pending_amount'] = pendingAmount;
    data['new_total'] = newTotal;
    data['total'] = total;
    data['phone'] = phone;
    data['end_coordinate'] = endCoordinate;
    data['start_address'] = startAddress;
    data['start_coordinate'] = startCoordinate;
    data['customerID'] = customerID;
    data['name'] = name;
    data['end_address'] = endAddress;
    data['id'] = id;
    data['payment_method'] = paymentMethod;
    data['estimated_time'] = estimatedTime;
    return data;
  }
}
