import 'package:equatable/equatable.dart';

import '../../../../core/utility/helper.dart';

class CreateProfileErrorResponseModel extends Equatable {
  final String errorMessage;

  const CreateProfileErrorResponseModel({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

  factory CreateProfileErrorResponseModel.fromJson(Map<String, dynamic> json) {
    late String _errorMessage;

    try {
      final String? errorMessage = json['message'] ?? '';

      _errorMessage = errorMessage!;
    } catch (e) {
      logMe(e);
      _errorMessage = '';
    }
    return CreateProfileErrorResponseModel(
      errorMessage: _errorMessage,
    );
  }
}
