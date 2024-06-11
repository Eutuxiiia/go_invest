import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/providers/accountProvider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic> userData;

  AccountScreen({super.key, required this.user, required this.userData});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.userData['username'] ?? '';
    _surnameController.text = widget.userData['surname'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            'Account',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(left: 17.0),
            child: Icon(Icons.abc),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await accountProvider.pickAndUploadImage(widget.user);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile picture updated!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to update profile picture')),
                  );
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade400,
                backgroundImage: widget.userData['image_url'] != null &&
                        widget.userData['image_url'] != ''
                    ? NetworkImage(widget.userData['image_url'])
                    : null,
                child: widget.userData['image_url'] == null ||
                        widget.userData['image_url'] == ''
                    ? Icon(Icons.camera_alt,
                        size: 50, color: Colors.white.withOpacity(0.7))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Surname'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: widget.user.email,
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 241, 236, 236),
                ),
                shadowColor: MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () async {
                try {
                  await accountProvider.updateUserInfo(
                    widget.user,
                    _usernameController.text,
                    _surnameController.text,
                    _newPasswordController.text,
                    _confirmPasswordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update profile')),
                  );
                }
              },
              child: const Text(
                'Confirm Changes',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryMonthController,
                    decoration: const InputDecoration(labelText: 'MM'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _expiryYearController,
                    decoration: const InputDecoration(labelText: 'YY'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _cvcController,
                    decoration: const InputDecoration(labelText: 'CVC'),
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await accountProvider.saveCardInfo(
                    widget.user,
                    _cardNumberController.text,
                    _expiryMonthController.text,
                    _expiryYearController.text,
                    _cvcController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card information saved!')),
                  );
                  _cardNumberController.clear();
                  _expiryMonthController.clear();
                  _expiryYearController.clear();
                  _cvcController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to save card information')),
                  );
                }
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 241, 236, 236),
                ),
                shadowColor: MaterialStatePropertyAll(Colors.black),
              ),
              child: const Text(
                'Save Card',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
