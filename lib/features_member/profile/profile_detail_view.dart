import 'package:ecommerce_flutter/common/widgets/text_button_widget.dart';
import 'package:ecommerce_flutter/common/widgets/text_form_field.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

    final isLoading = useState(false);
    final userService = useMemoized(() => UserService());

    useEffect(() {
      _fetchUserData(userService, userId, nameController, phoneController,
          emailController, dobController, addressController, isLoading);
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
          role: 'member',
          address: addressController.text,
        );

        try {
          await userService.updateUser(updatedUser);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Profile'),
        backgroundColor: ColorUtils.primaryBackgroundColor,
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
                    TextFormFieldCustomWidget(
                      label: 'Name',
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      label: 'Phone',
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      isEnable: false,
                      label: 'Email',
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      label: 'Date of Birth',
                      controller: dobController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustomWidget(
                      label: 'Address',
                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    TextButtonWidget(
                      label: 'Update',
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
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}