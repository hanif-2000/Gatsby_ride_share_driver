import 'injection.dart';
import 'session_helper.dart';

Future<bool> checkUserSession() async {
  final session = locator<Session>();
  return session.isLoggedIn;
}
Future<bool> checkProfileSession() async {
  final session = locator<Session>();
  return session.isProfileCompleted;
}
