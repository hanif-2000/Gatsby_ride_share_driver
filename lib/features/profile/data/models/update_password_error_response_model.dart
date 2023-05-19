import 'package:equatable/equatable.dart';

import '../../../../core/utility/helper.dart';

class UpdatePasswordErrorResponseModel extends Equatable {
  final String errorMessage;

  const UpdatePasswordErrorResponseModel({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

  factory UpdatePasswordErrorResponseModel.fromJson(Map<String, dynamic> json) {
    late String _errorMessage;

    try {
      final String? passwordMissMatch = json['message'];

      _errorMessage = passwordMissMatch ?? '';
    } catch (e) {
      logMe(e);
      _errorMessage = '';
    }
    return UpdatePasswordErrorResponseModel(
      errorMessage: _errorMessage,
    );
  }
}
