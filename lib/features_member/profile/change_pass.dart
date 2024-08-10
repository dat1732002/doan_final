import 'package:ecommerce_flutter/common/widgets/text_form_field.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final isLoading = useState<bool>(false);
    final userService = useMemoized(() => UserService());

    void _changePassword() async {
      if (emailController.text.isEmpty ||
          currentPasswordController.text.isEmpty ||
          newPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      isLoading.value = true;
      try {
        await userService.changeUserPassword(
          emailController.text,
          currentPasswordController.text,
          newPasswordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password: $e')),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: ColorUtils.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: ColorUtils.primaryColor,
        centerTitle: true,
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormFieldCustomWidget(
                label: 'Email',
                controller: emailController,
                validator: (value) => value == null || value.isEmpty ? 'Nhập email' : null,
              ),
              SizedBox(height: 20),
              TextFormFieldCustomWidget(
                label: 'Mật khẩu hiện tại',
                controller: currentPasswordController,
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Nhập mật khẩu hiện tại' : null,
              ),
              SizedBox(height: 20),
              TextFormFieldCustomWidget(
                label: 'Mật khẩu mới',
                controller: newPasswordController,
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Nhập mật khẩu mới' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtils.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: isLoading.value
                    ? CircularProgressIndicator(
                )
                    : Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
