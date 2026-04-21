import 'package:parent_app/features/auth/data/models/login_result.dart';

/// Outcome of setting the initial password after OTP verification.
sealed class ResetPasswordFlowResult {}

/// User must return to the login screen (mock API or no tokens in response).
class ResetPasswordComplete extends ResetPasswordFlowResult {}

/// Session established from `set-initial-password` response (access + refresh).
class ResetPasswordLoggedIn extends ResetPasswordFlowResult {
  final LoginSuccess session;
  ResetPasswordLoggedIn(this.session);
}

/// Request failed; [message] is safe to show.
class ResetPasswordFailed extends ResetPasswordFlowResult {
  final String message;
  ResetPasswordFailed(this.message);
}
