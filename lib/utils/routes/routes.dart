import 'package:ecommerce_flutter/features_admin/bottom_navigator_admin/bottom_navigator_admin_view.dart';
import 'package:ecommerce_flutter/features_member/auth/sign_in_view.dart';
import 'package:ecommerce_flutter/features_member/auth/sign_up_view.dart';
import 'package:ecommerce_flutter/features_member/bottom_navigator_member/bottom_navigator_member_view.dart';
import 'package:ecommerce_flutter/get_started.dart';
import 'package:flutter/material.dart';

import 'routes_name.dart';

class Routes {
  static Route<dynamic> routeBuilder(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.getStarted:
        return MaterialPageRoute(
          builder: (BuildContext context) =>  GetStarted(),
        );
      case RoutesName.signIn:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignInView(),
        );
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpView(),
        );
      case RoutesName.bottomNavigatorMember:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavigationMemberView(),
        );
      case RoutesName.bottomNavigatorAdmin:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavigationAdminView(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }

  static void goToSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.signIn, (Route<dynamic> route) => false);
  }

  static void goToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.signUp, (Route<dynamic> route) => false);
  }

  static void goToBottomNavigatorMemberScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.bottomNavigatorMember, (Route<dynamic> route) => false);
  }

  static void goToBottomNavigatorAdminScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.bottomNavigatorAdmin, (Route<dynamic> route) => false);
  }
}
