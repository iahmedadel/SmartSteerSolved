import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers/dio_helper.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<dynamic> _contacts = []; // List to hold emergency contacts
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmergencyContacts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _showUpdateBottomSheet(
      BuildContext context, Map<String, String> contact, int index) {
    final TextEditingController nameController =
        TextEditingController(text: contact["name"]);
    final TextEditingController phoneController =
        TextEditingController(text: contact["phone"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Contact',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => nameController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: nameController.text.length,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => phoneController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: phoneController.text.length,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateContact(
                    index,
                    nameController.text.trim(),
                    phoneController.text.trim(),
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Update Contact',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchEmergencyContacts() async {
    try {
      var response = await DioHelper.getData(path: 'emergency/list');
      if (response.statusCode == 200) {
        setState(() {
          _contacts = (response.data["contacts"] as List).map((contact) {
            return {
              "id": contact["id"], // Contact ID
              "name": contact["name"] ?? "Unknown", // Use contact name directly
              "phone":
                  contact["phone"] ?? "No phone", // Use contact phone directly
            };
          }).toList();
        });
      } else {
        _showError('Failed to fetch contacts');
      }
    } catch (e) {
      _showError('server : An error occurred: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _updateContact(int contactId, String name, String phone) async {
    try {
      // API call to update contact
      final response = await DioHelper.postData(
        path: 'emergency/update/$contactId', // Adjust the path as per your API
        body: {
          'name': name,
          'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        log('Contact updated successfully: ${response.data}');
        _fetchEmergencyContacts(); //for refreshing
      } else {
        log('Failed to update contact. Status code: ${response.statusCode}');
        // Handle unexpected response
      }
    } catch (e) {
      log('Error updating contact: $e');
      // Handle error (e.g., showing an error message to the user)
    }
  }

  Future<void> _addContact(String name, String mobile) async {
    //   try {
    //     var response = await DioHelper.postData(
    //       path: 'emergency/add',
    //       body: {'name': name, 'phone': mobile},
    //     );
    //     if (response.statusCode == 200) {
    //       _fetchEmergencyContacts(); // Refresh the list after adding
    //     } else {
    //       _showError('Failed to add contact');
    //     }
    //   } catch (e) {
    //     _showError('An error occurred: $e');
    //   }
    // }

    if (name.isNotEmpty && mobile.isNotEmpty) {
      setState(() {
        _contacts.add({'name': name, 'mobile': mobile});
      });
    }
  }

  _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteContact(index);
              Navigator.of(ctx).pop();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _deleteContact(int index) async {
    final contact = _contacts[index];
    try {
      var response = await DioHelper.deleteData(
        path:
            'emergency/delete/${contact["id"]}', // Adjust the endpoint as needed
      );
      if (response.statusCode == 200) {
        setState(() {
          _contacts.removeAt(index); // Remove the contact from the local list
        });
        Get.snackbar(
          'Success',
          'Contact deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        _showError('Failed to delete contact');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              'Add Emergency Contacts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          contact["name"]![0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        contact["name"] ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_mobileController
                          .text), //contact["phone"] ?? "No phone number"),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _showDeleteConfirmation(context, index),
                            ),
                            IconButton(
                                icon: const Icon(Icons.call,
                                    color: Color.fromARGB(255, 150, 201, 207)),
                                onPressed: () => _makePhoneCall(
                                    _mobileController
                                        .text) //contact["phone"]!),
                                ),
                          ],
                        ),
                      ),
                      onTap: () =>
                          _showUpdateBottomSheet(context, contact, index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Emergency Contact',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _addContact(
                          _nameController.text.trim(),
                          _mobileController.text.trim(),
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add Contact',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // TextButton(
                    //   onPressed: () => Navigator.of(context).pop(),
                    //   child: const Text(
                    //     'Cancel',
                    //     style: TextStyle(color: Colors.red),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
