import 'package:flutter/foundation.dart';

const String _defaultAuthenticatedRoute = '/dashboard';

const String _loginRoute = '/login';

@visibleForTesting
String? evaluateRouterRedirect({
  required bool isAuthenticated,
  required String path,
}) {
  final isLoginRoute = path == _loginRoute;

  if (!isAuthenticated && !isLoginRoute) {
    return _loginRoute;
  }

  if (isAuthenticated && isLoginRoute) {
    return _defaultAuthenticatedRoute;
  }

  return null;
}

const String loginRoutePath = _loginRoute;

const String defaultAuthenticatedRoutePath = _defaultAuthenticatedRoute;
