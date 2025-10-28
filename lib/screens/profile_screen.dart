import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _passwordController = TextEditingController();
  bool _updating = false;
  bool _showPasswordField = false;
  bool _obscurePassword = true;
  String? _message;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final newPassword = _passwordController.text.trim();
    if (newPassword.isEmpty || newPassword.length < 6) {
      setState(() => _message = "Password must be at least 6 characters");
      return;
    }

    setState(() {
      _updating = true;
      _message = null;
    });

    try {
      await widget.user.updatePassword(newPassword);
      setState(() {
        _message = "Password updated successfully!";
        _passwordController.clear();
        _showPasswordField = false;
      });
    } catch (e) {
      setState(() => _message = "Error: ${e.toString()}");
    } finally {
      setState(() => _updating = false);
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final themeData = _isDarkMode ? darkAppTheme : appTheme;

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: themeData.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: themeData.cardColor,
                child: Icon(Icons.person, size: 50, color: themeData.iconTheme.color),
              ),
              SizedBox(height: 24),
              Text(
                widget.user.email ?? "No Email",
                style: themeData.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),

              /*// Theme toggle
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dark Mode", style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Switch(
                          key: ValueKey(_isDarkMode),
                          value: _isDarkMode,
                          onChanged: _toggleTheme,
                          activeColor: themeData.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/

              SizedBox(height: 24),

              // Password Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change Password", style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(_showPasswordField ? Icons.expand_less : Icons.edit),
                            onPressed: () {
                              setState(() {
                                _showPasswordField = !_showPasswordField;
                              });
                            },
                          ),
                        ],
                      ),
                      if (_showPasswordField) ...[
                        SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _updating ? null : _updatePassword,
                          icon: _updating
                              ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              : Icon(Icons.lock),
                          label: Text("Update Password"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        if (_message != null) ...[
                          SizedBox(height: 12),
                          Text(
                            _message!,
                            style: TextStyle(color: _message!.startsWith("Error") ? Colors.red : Colors.green),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
