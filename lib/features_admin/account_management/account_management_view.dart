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
        backgroundColor: ColorUtils.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryBackgroundColor,
          title: Text(
            'Quản lý tài khoản',
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
      backgroundColor: ColorUtils.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Quản lý tài khoản',
          style: TextStyle(
            color: ColorUtils.whiteColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Routes.goToSignInScreen(context);
              },
              icon: Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body: ListView.builder(
        itemCount: users.value.length,
        itemBuilder: (context, index) {
          final user = users.value[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(left:8.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(15),
          actionsPadding: EdgeInsets.all(5),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          backgroundColor: Colors.white,
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: ColorUtils.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Chỉnh sửa tài khoản',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFormField(nameController, 'Name'),
                _buildTextFormField(phoneController, 'Phone'),
                _buildTextFormField(emailController, 'Email', enabled: false),
                _buildTextFormField(dateOfBirthController, 'Date of Birth'),
                _buildTextFormField(addressController, 'Address'),
              ],
            ),
          ),
          actions: [
            _buildActionButton(
              context: context,
              label: 'Hủy',
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            _buildActionButton(
              context: context,
              label: isUpdating.value ? '' : 'Lưu',
              color: Colors.blueAccent,
              onPressed: () async {
                if (isUpdating.value) return; // Prevent multiple submissions
                isUpdating.value = true;
                final updatedUser = UserModel(
                  id: user.id,
                  name: nameController.text,
                  phone: phoneController.text,
                  email: user.email,
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
              child: isUpdating.value
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : Text('Lưu'),
            ),
            _buildActionButton(
              context: context,
              label: isUpdating.value ? '' : 'Xóa',
              color: Colors.redAccent,
              onPressed: () async {
                if (isUpdating.value) return; // Prevent multiple submissions
                isUpdating.value = true;
                try {
                  await UserService().deleteUser(user.id);
                  onUpdate();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to delete user: $e'),
                  ));
                } finally {
                  isUpdating.value = false;
                }
              },
              child: isUpdating.value
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        enabled: enabled,
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    Widget? child,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: child ??
            Text(
              label,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
      ),
    );
  }
}
