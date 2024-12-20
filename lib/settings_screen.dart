import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'emergency_screen.dart';
import 'home_screen.dart'; // Import other screens as needed

// Controller for settings
class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var selectedLanguage = 'English'.obs;
  var showPrivacyOptions = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light());
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    // Add localization logic here if needed
  }

  void togglePrivacyOptions() {
    showPrivacyOptions.value = !showPrivacyOptions.value;
  }
}

// Main settings screen
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller =
      Get.put(SettingsController()); // Initialize GetX controller

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      print('Selected image path: ${image.path}');
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/user_icon.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickImage(context),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'user@example.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Edit Profile Tile
                    _buildListTile(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      onTap: () {},
                    ),

                    // Settings & Privacy Tile
                    Obx(
                      () => Column(
                        children: [
                          _buildListTile(
                            icon: Icons.privacy_tip,
                            title: 'Settings & Privacy',
                            trailing: IconButton(
                              icon: Icon(
                                controller.showPrivacyOptions.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                              onPressed: controller.togglePrivacyOptions,
                            ),
                            onTap: () {},
                          ),
                          if (controller.showPrivacyOptions.value)
                            Column(
                              children: [
                                _buildListTile(
                                  icon: Icons.email,
                                  title: 'Account Email',
                                  onTap: () {},
                                ),
                                _buildListTile(
                                  icon: Icons.lock,
                                  title: 'Account Password',
                                  onTap: () {},
                                ),
                                _buildListTile(
                                  icon: Icons.delete,
                                  title: 'Delete Account',
                                  onTap: () {},
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // General Settings Title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'General Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Mode (Dark/Light)
                    _buildListTile(
                      icon: controller.isDarkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      title: 'Mode',
                      trailing: Switch(
                        value: controller.isDarkMode.value,
                        onChanged: (value) => controller.toggleTheme(),
                      ),
                      onTap: () {},
                    ),

                    // Language Selection
                    _buildListTile(
                      icon: Icons.language,
                      title: 'Language',
                      trailing: DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: controller.selectedLanguage.value,
                        items: [
                          DropdownMenuItem(
                            child: Text('English',
                                style: TextStyle(color: Colors.white)),
                            value: 'English',
                          ),
                          DropdownMenuItem(
                            child: Text('Arabic',
                                style: TextStyle(color: Colors.white)),
                            value: 'Arabic',
                          ),
                        ],
                        onChanged: (value) => controller.changeLanguage(value!),
                      ),
                      onTap: () {},
                    ),

                    // About List Tile
                    _buildListTile(
                      icon: Icons.info,
                      title: 'About',
                      onTap: () {
                        // Navigate to About screen using GetX routing
                        Get.to(() => AboutScreen());
                      },
                    ),

                    // Terms and Conditions List Tile
                    _buildListTile(
                      icon: Icons.description,
                      title: 'Terms and Conditions',
                      onTap: () {
                        // Navigate to Terms and Conditions screen using GetX routing
                        // Get.to(() => TermsAndConditionsScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: TextStyle(color: Colors.black)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

// Placeholder screens for About and Terms and Conditions


