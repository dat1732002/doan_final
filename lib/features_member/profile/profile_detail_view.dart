import 'dart:io';

import 'package:ecommerce_flutter/common/widgets/text_button_widget.dart';
import 'package:ecommerce_flutter/common/widgets/text_form_field.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailView extends HookWidget {
  final String userId;

  const ProfileDetailView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final dobController = useTextEditingController();
    final addressController = useTextEditingController();
    final selectedImage = useState<File?>(null);
    final isLoading = useState<bool>(false);
    final userService = useMemoized(() => UserService());
    final image = useState<String>('');
    useEffect(() {
      _fetchUserData(userService, userId, nameController, phoneController,
          emailController, dobController, addressController,image, isLoading);
      return null;
    }, []);

    void _updateUser() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;

        UserModel updatedUser = UserModel(
          id: userId,
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          dateOfBirth: dobController.text,
          role: emailController.text == "admin@admin.com"?'admin':'member',
          address: addressController.text,
        );

        try {
          await userService.updateUser(updatedUser);
          if (selectedImage.value != null) {
            await userService.updateProfilePicture(userId, selectedImage.value!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context, true);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user: $e')),
          );
        } finally {
          isLoading.value = false;
        }
      }
    }

    Future<void> _pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        title: Text(
          'Thông tin cá nhân',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                        Column(
                          children: [
                            Text(
                              'Ảnh đại diện',
                              style: TextStyle(
                                color: ColorUtils.primaryColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.whiteColor,
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: selectedImage.value == null
                                ? image.value ==''
                                      ? Icon(Icons.person, size: 40.h, color: ColorUtils.primaryColor)
                                      : Image.network(image.value,fit: BoxFit.fill,)
                                      : Image.file(selectedImage.value??File(''),fit: BoxFit.fill,)
                                ),
                                const SizedBox(height: 10,),
                                InkWell(
                                    onTap: _pickImage,
                                    child: Container(
                                     padding: EdgeInsets.all(8), 
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black12)
                                      ),
                                        child: Text('Chọn ảnh',style: TextStyle(
                                          color: Colors.white
                                        ),)),
                                  ),
                          ],
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormFieldCustomWidget(
                label: 'Tên',
                controller: nameController,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),
              TextFormFieldCustomWidget(
                label: 'Số điện thoại',
                controller: phoneController,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 20),
              TextFormFieldCustomWidget(
                isEnable: false,
                label: 'Email',
                controller: emailController,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your email address' : null,
              ),
              const SizedBox(height: 20),
              TextFormFieldCustomWidget(
                label: 'Ngày sinh',
                controller: dobController,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your date of birth' : null,
              ),
              const SizedBox(height: 20),
              TextFormFieldCustomWidget(
                label: 'Địa chỉ',
                controller: addressController,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 20),
              TextButtonWidget(
                label: 'CẬP NHẬT THÔNG TIN',
                onPressed: _updateUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUserData(
      UserService userService,
      String userId,
      TextEditingController nameController,
      TextEditingController phoneController,
      TextEditingController emailController,
      TextEditingController dobController,
      TextEditingController addressController,
      ValueNotifier<String>  selectImage,
      ValueNotifier<bool> isLoading,
      ) async {
    isLoading.value = true;
    try {
      var userData = await userService.fetchUserDetails(userId);
      nameController.text = userData['name'];
      phoneController.text = userData['phone'];
      emailController.text = userData['email'];
      dobController.text = userData['dateOfBirth'];
      addressController.text = userData['address'];
      selectImage.value = userData['profilePictureUrl'];
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
