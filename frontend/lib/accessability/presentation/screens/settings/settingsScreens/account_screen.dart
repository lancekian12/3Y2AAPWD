import 'dart:io';

import 'package:AccessAbility/accessability/presentation/screens/settings/settingsScreens/change_password_screen.dart';
import 'package:AccessAbility/accessability/presentation/screens/settings/settingsScreens/delete_account.dart';
import 'package:AccessAbility/accessability/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:AccessAbility/accessability/logic/bloc/user/user_bloc.dart';
import 'package:AccessAbility/accessability/logic/bloc/user/user_event.dart';
import 'package:AccessAbility/accessability/logic/bloc/user/user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  XFile? _imageFile;
  bool _isUpdatingProfilePicture =
      false; // Track if profile picture is being updated

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    setState(() {
      _imageFile = pickedFile;
    });

    if (_imageFile != null) {
      if (!mounted) return;

      setState(() {
        _isUpdatingProfilePicture = true; // Show loading indicator
      });

      final userBloc = context.read<UserBloc>();
      final userState = userBloc.state;

      if (userState is UserLoaded) {
        print('Dispatching UploadProfilePictureEvent...');
        userBloc.add(
          UploadProfilePictureEvent(
            uid: userState.user.uid,
            profilePicture: _imageFile!,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          setState(() {
            _isUpdatingProfilePicture = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('profilePictureUpdated'.tr()),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is UserError) {
          setState(() {
            _isUpdatingProfilePicture = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${'error'.tr()}: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            final user = state.user;

            if (_isUpdatingProfilePicture) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: AppBar(
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xFF6750A4),
                    ),
                    title: Text(
                      'accountTitle'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture & Username
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: _imageFile != null
                                    ? FileImage(File(_imageFile!.path))
                                    : user.profilePicture.isNotEmpty
                                        ? NetworkImage(user.profilePicture)
                                        : null,
                                child: _imageFile == null &&
                                        user.profilePicture.isEmpty
                                    ? Text(
                                        user.username[0].toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.username,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 150,
                              height: 1,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Account Details Section
                    Container(
                      width: double.infinity,
                      color: isDarkMode
                          ? Colors.grey[800]
                          : const Color(0xFFF0F0F0),
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'accountDetails'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF919191),
                          ),
                        ),
                      ),
                    ),
                    // Phone Number
                    ListTile(
                      leading: const Icon(Icons.phone_outlined,
                          color: Color(0xFF6750A4)),
                      title: Text(
                        'phoneNumber'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        user.contactNumber.isNotEmpty
                            ? user.contactNumber
                            : 'notProvided'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    // Email Address
                    ListTile(
                      leading: const Icon(Icons.email_outlined,
                          color: Color(0xFF6750A4)),
                      title: Text(
                        'emailAddress'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        obfuscateEmail(user.email),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    // Password (hidden)
                    ListTile(
                      leading: const Icon(Icons.lock_outline,
                          color: Color(0xFF6750A4)),
                      title: Text(
                        'password'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        '***********',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Account Management Section
                    Container(
                      width: double.infinity,
                      color: isDarkMode
                          ? Colors.grey[800]
                          : const Color(0xFFF0F0F0),
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'accountManagement'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF919191),
                          ),
                        ),
                      ),
                    ),
                    // Delete Account
                    ListTile(
                      leading:
                          const Icon(Icons.delete, color: Colors.redAccent),
                      title: Text(
                        'deleteAccount'.tr(),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeleteAccount()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Cancel & Save Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF6750A4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'cancel'.tr(),
                            style: const TextStyle(color: Color(0xFF6750A4)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6750A4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('save'.tr()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('noUserData'.tr()));
          }
        },
      ),
    );
  }

  String obfuscateEmail(String email) {
    final indexOfAt = email.indexOf('@');
    if (indexOfAt <= 0) {
      return email;
    }
    final username = email.substring(0, indexOfAt);
    final domain = email.substring(indexOfAt);
    if (username.length <= 2) {
      return email;
    }
    final firstTwo = username.substring(0, 2);
    final lastTwo = username.substring(username.length - 2);
    final middleAsterisks = '*' * (username.length - 4);
    return '$firstTwo$middleAsterisks$lastTwo$domain';
  }
}
