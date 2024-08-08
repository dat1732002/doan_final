import 'package:ecommerce_flutter/common/widgets/loading_widget.dart';
import 'package:ecommerce_flutter/common/widgets/text_button_widget.dart';
import 'package:ecommerce_flutter/common/widgets/text_form_field.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:ecommerce_flutter/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isPasswordVisible = false;
  final UserService _userService = UserService();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      UserModel user = UserModel(
        id: "",
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        dateOfBirth: DateTime.now().toString(),
        role: 'member',
        address: _addressController.text,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingWidget();
        },
      );

      try {
        await _userService.registerUser(
          user,
          _passwordController.text,
        );
        Navigator.of(context).pop(); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Routes.goToSignInScreen(context);
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to register user: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 20).r,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nice to know you!',
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Enter your account to continue',
                  style: TextStyle(
                    color: ColorUtils.textColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10.h),
                TextFormFieldCustomWidget(
                  hint: 'Your full name',
                  label: "Full name",
                  controller: _nameController,
                  inputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormFieldCustomWidget(
                  hint: 'Your email address',
                  label: "Email address",
                  inputAction: TextInputAction.next,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormFieldCustomWidget(
                  hint: 'Your phone number',
                  label: "Phone number",
                  inputAction: TextInputAction.next,
                  controller: _phoneController,
                  textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormFieldCustomWidget(
                  hint: 'Your address',
                  label: "Address",
                  inputAction: TextInputAction.next,
                  controller: _addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormFieldCustomWidget(
                  hint: 'Your password',
                  label: "Password",
                  controller: _passwordController,
                  inputAction: TextInputAction.done,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextButtonWidget(
                  label: 'Register',
                  onPressed: _register,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorUtils.textColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "Or register with",
                        style: TextStyle(
                          color: ColorUtils.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorUtils.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: ColorUtils.textColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Routes.goToSignInScreen(context),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: ColorUtils.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}