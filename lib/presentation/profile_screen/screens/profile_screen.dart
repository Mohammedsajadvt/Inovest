import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/category/category_state.dart';
import 'package:inovest/business_logics/profile/profile_bloc.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/custom_text_field.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inovest/data/models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        profileImageUrl = pickedImage.path;
      });
      ;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[1],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is GetProfileloaded) {
            if (fullNameController.text.isEmpty) {
              fullNameController.text = state.profileModel.data.fullName;
            }
            if (emailController.text.isEmpty) {
              emailController.text = state.profileModel.data.email;
            }
            if (phoneController.text.isEmpty) {
              phoneController.text = state.profileModel.data.phoneNumber ?? "";
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is GetProfileloaded) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: profileImageUrl != null
                                ? (profileImageUrl!.startsWith("http")
                                    ? NetworkImage(profileImageUrl!)
                                    : FileImage(
                                        File(profileImageUrl!),
                                      ) as ImageProvider)
                                : NetworkImage(state.profileModel.data.imageUrl
                                    .toString()),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18.h,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hintText: 'Full Name',
                  controller: fullNameController,
                ),
                SizedBox(height: 5.h),
                CustomTextField(
                  hintText: 'E.mail',
                  controller: emailController,
                ),
                SizedBox(height: 5.h),
                CustomTextField(
                  hintText: 'Contact number',
                  controller: phoneController,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 250, horizontal: 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is GetProfileloaded &&
                                    state.profileModel.data.role.currentRole ==
                                        "INVESTOR"
                                ? AppArray().colors[0]
                                : AppArray().colors[2],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (state is GetProfileloaded) {
                              final updatedUserData =
                                  state.profileModel.data.copyWith(
                                fullName: fullNameController.text,
                                email: emailController.text,
                                phoneNumber: phoneController.text,
                                imageUrl: profileImageUrl ??
                                    state.profileModel.data.imageUrl,
                              );

                              final updatedProfileModel = ProfileModel(
                                  success: true, data: updatedUserData);

                              context
                                  .read<ProfileBloc>()
                                  .add(UpdateProfile(updatedProfileModel));
                            } else if (state is ProfileError) {
                              print(state.message);
                            }
                          },
                          child: const Text(
                            'Add new',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Log out',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
