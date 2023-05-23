import 'package:equatable/equatable.dart';

import '../../../../core/utility/helper.dart';

class SignupErrorResponseModel extends Equatable {
  final String errorMessage;

  const SignupErrorResponseModel({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

  factory SignupErrorResponseModel.fromJson(Map<String, dynamic> json) {
    late String _errorMessage;

    try {
      final String? errorMessage =
          json['message'] ?? '';


      _errorMessage = errorMessage!;
    } catch (e) {
      logMe(e);
      _errorMessage = '';
    }
    return SignupErrorResponseModel(
      errorMessage: _errorMessage,
    );
  }
}
