abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class LogoutEvent extends AuthEvent {}  // This is the event for logging out
