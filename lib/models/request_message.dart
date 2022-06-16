class RequestMessageModel {
  final String msg;
  // final String userType;

  RequestMessageModel({
    required this.msg,
    // required this.userType,
  });

  factory RequestMessageModel.fromJson(dynamic json) {
    return RequestMessageModel(
      msg: json['message'],
      // userType: json['userType'],
    );
  }
}
