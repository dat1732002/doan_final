import 'package:ecommerce_flutter/features_member/profile/change_pass.dart';
import 'package:ecommerce_flutter/features_member/profile/profile_detail_view.dart';
import 'package:ecommerce_flutter/features_member/profile/widgets/button_settings_widget.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          await _loadUserData(userService, user, isLoading);
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Trang cá nhân',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : user.value != null
          ? Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.only(bottom: 40.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                margin: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  gradient: LinearGradient(
                    colors: [
                      ColorUtils.blueColor,
                      ColorUtils.blueMiddleColor,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: ColorUtils.whiteColor,
                      backgroundImage: user.value?.profilePictureUrl != null && user.value!.profilePictureUrl!.isNotEmpty
                          ? NetworkImage(user.value!.profilePictureUrl!)
                          : null,
                      child: user.value?.profilePictureUrl == null || user.value!.profilePictureUrl!.isEmpty
                          ? Icon(Icons.person, size: 40.h, color: ColorUtils.primaryColor)
                          : null,
                    ),
                    SizedBox(width: 20.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.value!.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorUtils.whiteColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          user.value!.email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorUtils.whiteColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ButtonSettingsWidget(
                icon: SvgPicture.asset('assets/icons/ic_user_account.svg'),
                title: 'Chỉnh sửa thông tin',
                onPressed: _handleUpdateUser,
              ),
              ButtonSettingsWidget(
                icon: Icon(Icons.password),
                title: 'Đổi mật khẩu',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1.h,
                width: double.infinity,
                color: ColorUtils.textColor,
              ),

              SizedBox(height: 10.h),
              ButtonSettingsWidget(
                icon: Icon(Icons.logout),
                title: 'Đăng xuất',
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
        address: userData['address'],
        profilePictureUrl: userData['profilePictureUrl'],
      );
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
