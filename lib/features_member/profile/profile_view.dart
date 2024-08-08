import 'package:ecommerce_flutter/features_member/profile/profile_detail_view.dart';
import 'package:ecommerce_flutter/features_member/profile/widgets/button_settings_widget.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter_svg/svg.dart';

class ProfileView extends HookWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final user = useState<UserModel?>(null);
    final isLoading = useState<bool>(true);

    useEffect(() {
      _loadUserData(userService, user, isLoading);
      return null;
    }, []);

    Future<void> _handleUpdateUser() async {
      if (user.value != null) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDetailView(
              userId: user.value!.id,
            ),
          ),
        );
        if (result == true) {
          await _loadUserData(
              userService, user, isLoading);
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Profile',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : user.value != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                ColorUtils.blueColor,
                                ColorUtils.blueMiddleColor,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.r),
                                width: 55.w,
                                height: 55.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.whiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(Icons.person,
                                    size: 40.h, color: ColorUtils.primaryColor),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    user.value!.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ColorUtils.whiteColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user.value!.email,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ColorUtils.whiteColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ButtonSettingsWidget(
                          icon: SvgPicture.asset(
                            'assets/icons/ic_user_account.svg',
                          ),
                          title: 'Update Profile',
                          onPressed: _handleUpdateUser,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: ColorUtils.textColor,
                        ),
                        ButtonSettingsWidget(
                          icon: Icon(Icons.logout),
                          title: 'Logout',
                          onPressed: () {
                            Routes.goToSignInScreen(context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('User not found')),
    );
  }

  Future<void> _loadUserData(
    UserService userService,
    ValueNotifier<UserModel?> user,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    try {
      String userId = userService.getCurrentUserId();
      var userData = await userService.fetchUserDetails(userId);
      user.value = UserModel(
        id: userId,
        name: userData['name'],
        phone: userData['phone'],
        email: userData['email'],
        dateOfBirth: userData['dateOfBirth'],
        role: userData['role'],
        address: userData['address']
      );
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
