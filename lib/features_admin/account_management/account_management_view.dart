import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:ecommerce_flutter/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountManagementView extends HookWidget {
  const AccountManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final users = useState<List<UserModel>>([]);
    final isLoading = useState<bool>(true);
    final isUpdating = useState<bool>(false);
    Future<void> fetchData() async {
      try {
        List<UserModel> fetchedUsers = await userService.fetchUsers();
        users.value = fetchedUsers;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load users: $e'),
        ));
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchData();
      return null;
    }, []);

    if (isLoading.value) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryBackgroundColor,
          title: Text(
            'Account Management',
            style: TextStyle(
              color: ColorUtils.primaryColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Routes.goToSignInScreen(context);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Account Management',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Routes.goToSignInScreen(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        itemCount: users.value.length,
        itemBuilder: (context, index) {
          final user = users.value[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: ColorUtils.blueLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorUtils.primaryColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorUtils.textColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: ColorUtils.primaryColor),
                    onPressed: () {
                      _showEditUserDialog(
                        context,
                        user,
                        isUpdating,
                        () => fetchData(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user,
      ValueNotifier<bool> isUpdating, Function onUpdate) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email);
    final dateOfBirthController = TextEditingController(text: user.dateOfBirth);
    final addressController = TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  enabled: false, // Không cho phép chỉnh sửa email
                ),
                TextField(
                  controller: dateOfBirthController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                isUpdating.value = true;
                final updatedUser = UserModel(
                  id: user.id,
                  name: nameController.text,
                  phone: phoneController.text,
                  email: user.email, // Giữ nguyên email
                  dateOfBirth: dateOfBirthController.text,
                  role: user.role,
                  address: addressController.text,
                );
                try {
                  await UserService().updateUser(updatedUser);
                  onUpdate();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to update user: $e'),
                  ));
                } finally {
                  isUpdating.value = false;
                }
              },
              child:
                  isUpdating.value ? CircularProgressIndicator() : Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
