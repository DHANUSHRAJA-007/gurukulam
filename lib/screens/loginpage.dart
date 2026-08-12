// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dropdown variables
  String? _selectedDepartmentId;
  List<Department> _departments = [];

  bool _isLoading = false;
  bool _isLoadingDepartments = false;
  bool _obscurePassword = true;

  final FocusNode _usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _loadLoginData();
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _loadDepartmentsForUsername();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadDepartmentsForUsername() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Please enter username first', Colors.orange);
      return;
    }

    setState(() {
      _isLoadingDepartments = true;
      // _departments = [];
      // _selectedDepartmentId = null;
      // _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/get_user_department.php?username=${Uri.encodeComponent(username)}',
        ),
      );

      // print('Department API response: ${response.body}');
// 
      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() {
          _departments = (data['departments'] as List)
              .map((dept) => Department.fromJson(dept))
              .toList();
        });

        // print('Departments for $username:');

        for (final dept in _departments) {
          //  print('${dept.id} - ${dept.name} - company ${dept.companyId}');
        }
      } else {
        _showSnackBar(data['message'] ?? 'No departments found', Colors.red);
      }
    } catch (e) {
      // print('Department loading error: $e');

      _showSnackBar('Failed to load departments', Colors.red);
    } finally {
      setState(() {
        _isLoadingDepartments = false;
      });
    }
  }

  // Login function
  Future<void> _login() async {
    // Clear previous errors
    setState(() {
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDepartmentId == null || _selectedDepartmentId!.isEmpty) {
      _showSnackBar('Please select a department', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login1.php'),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'username': _usernameController.text.trim(),
              'password': _passwordController.text.trim(),
              'department': _selectedDepartmentId!,
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print('================ LOGIN DEBUG ================');
        // print('Username: ${_usernameController.text.trim()}');
        // print('Selected Department: $_selectedDepartmentId');
        // print('FULL LOGIN RESPONSE: $data');
        // print('USER DATA: ${data['user']}');
        // print('COMPANY ID FROM API: ${data['user']?['company']}');
        // print('COMPANY NAME FROM API: ${data['user']?['company_name']}');
        // print('=============================================');
        // Check if login was successful
        if (data['success'] == true && data['user'] != null) {
          // Login successful - save user data
          await _saveUserData(data);

          _showSnackBar(data['message'] ?? 'Login successful', Colors.green);

          // Navigate to dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                userId: data['user']['id'].toString(),
                username: data['user']['name'],
                userType: data['user']['user_type'],
                departmentId: data['user']['department'].toString(),
                departmentName: data['user']['department_name'],
                companyId: data['user']['company'].toString(),
                companyName: data['user']['company_name'],
              ),
            ),
            (route) => false,
          );
        } else {
          // Login failed - show user-friendly message
          final errorMsg = _getLoginErrorMessage(data);
          setState(() {
          });
          _showSnackBar(errorMsg, Colors.red);
        }
      } else {
        // Server error
        final errorMsg = 'Invalid Username or Password.';
        setState(() {
        });
        _showSnackBar(errorMsg, Colors.red);
      }
    } catch (e) {
      // Network or connection error
      final errorMsg = _getUserFriendlyError(e.toString());
      setState(() {
      });
      _showSnackBar(errorMsg, Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = data['user'];

      await prefs.setString('user_id', user['id'].toString());
      await prefs.setString('username', user['name']);
      await prefs.setString('user_type', user['user_type']);
      await prefs.setString('department_id', user['department'].toString());
      await prefs.setString('department_name', user['department_name']);
      await prefs.setString('company_id', user['company'].toString());
      await prefs.setString('company_name', user['company_name']);
      await prefs.setBool('dashboard', user['dashboard'] == 1);
      await prefs.setBool('treatment_master', user['treatment_master'] == 1);
      await prefs.setBool('category_master', user['category_master'] == 1);
      await prefs.setBool('sales_entry', user['sales_entry'] == 1);
      await prefs.setBool('expenses_entry', user['expenses_entry'] == 1);
      await prefs.setBool('expenses_category', user['expenses_category'] == 1);
      await prefs.setBool(
        'sales_entry_report',
        user['sales_entry_report'] == 1,
      );
      await prefs.setBool('is_logged_in', true);

      // print('✅ User data saved successfully');
    } catch (e) {
      // print('❌ Error saving user data: $e');
      throw Exception('Failed to save user data');
    }
  }

  // Get user-friendly login error message
  String _getLoginErrorMessage(Map<String, dynamic> data) {
    final message = data['message']?.toString().toLowerCase() ?? '';

    if (message.contains('invalid') ||
        message.contains('incorrect') ||
        message.contains('wrong')) {
      return 'Invalid username or password. Please try again.';
    } else if (message.contains('not found') || message.contains('no user')) {
      return 'User not found. Please check your username.';
    } else if (message.contains('inactive') || message.contains('disabled')) {
      return 'Your account is inactive. Please contact administrator.';
    } else if (message.contains('department')) {
      return 'Invalid department selected. Please try again.';
    } else {
      return data['message'] ?? 'Login failed. Please try again.';
    }
  }

  // Get user-friendly error message for connection errors
  String _getUserFriendlyError(String error) {
    final errorLower = error.toLowerCase();

    if (errorLower.contains('timeout')) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (errorLower.contains('socket') ||
        errorLower.contains('network') ||
        errorLower.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorLower.contains('ssl') ||
        errorLower.contains('certificate')) {
      return 'SSL connection error. Please contact support.';
    } else if (errorLower.contains('failed to fetch')) {
      return 'Cannot connect to server. Please check your internet connection.';
    } else if (errorLower.contains('404') || errorLower.contains('not found')) {
      return 'Server endpoint not found. Please contact support.';
    } else if (errorLower.contains('500') ||
        errorLower.contains('internal server')) {
      return 'Server error. Please try again later.';
    } else {
      // Return a generic error message instead of raw error
      return 'Unable to connect to server. Please check your internet connection and try again.';
    }
  }

  // Show snackbar message
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20.0 : 40.0,
              vertical: 20.0,
            ),
            child: Container(
              width: isMobile ? double.infinity : 441,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 52.91,
                    offset: Offset(3.666, 4.888),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    SizedBox(
                      width: MediaQuery.of(
                        context,
                      ).size.width.clamp(200.0, 280.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          "$baseUrl/img/SR logo.png",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.business,
                                size: 80,
                                color: Colors.blue,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Login Title
                    Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF313131),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Login to access your account',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF313131),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Error Message - Now shows user-friendly messages
                    // if (_errorMessage != null)
                    //   Container(
                    //     width: double.infinity,
                    //     padding: EdgeInsets.all(12),
                    //     margin: EdgeInsets.only(bottom: 16),
                    //     decoration: BoxDecoration(
                    //       color: Colors.red[50],
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(color: Colors.red[200]!),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Icon(
                    //           Icons.error_outline,
                    //           color: Colors.red,
                    //           size: 20,
                    //         ),
                    //         SizedBox(width: 8),
                    //         Expanded(
                    //           child: Text(
                    //             _errorMessage!,
                    //             style: TextStyle(
                    //               color: Colors.red[800],
                    //               fontSize: 13,
                    //               fontFamily: 'Poppins',
                    //             ),
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: () => setState(() => _errorMessage = null),
                    //           child: Icon(
                    //             Icons.close,
                    //             color: Colors.red,
                    //             size: 20,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),

                    // Username Field
                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF313131),
                      ),
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Color(0xFF79747E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Color(0xFF79747E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 19,
                          vertical: 13,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    // SizedBox(
                    //   width: double.infinity,
                    //   child: OutlinedButton.icon(
                    //     onPressed: _isLoadingDepartments
                    //         ? null
                    //         : _loadDepartmentsForUsername,
                    //     icon: _isLoadingDepartments
                    //         ? const SizedBox(
                    //             width: 16,
                    //             height: 16,
                    //             child: CircularProgressIndicator(
                    //               strokeWidth: 2,
                    //             ),
                    //           )
                    //         : const Icon(Icons.business),
                    //     label: Text(
                    //       _isLoadingDepartments
                    //           ? 'Loading Departments...'
                    //           : 'Load Departments',
                    //     ),
                    //   ),
                    // ),

                    // const SizedBox(height: 10),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF313131),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Color(0xFF79747E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Color(0xFF79747E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 19,
                          vertical: 13,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF999999),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    // Department Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _selectedDepartmentId,
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF313131),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Select Department',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Color(0xFF79747E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Color(0xFF79747E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 19,
                          vertical: 13,
                        ),
                        suffixIcon: _isLoadingDepartments
                            ? Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF999999),
                                size: 24,
                              ),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Select Department',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ),
                        ..._departments.map((department) {
                          return DropdownMenuItem<String>(
                            value: department.id,
                            child: Text(
                              department.name,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFF313131),
                              ),
                            ),
                          );
                        }),
                      ],
                      onChanged: (_isLoading || _isLoadingDepartments)
                          ? null
                          : (value) {
                              setState(() {
                                _selectedDepartmentId = value;
                              });
                            },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a department';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: (_isLoading || _isLoadingDepartments)
                            ? null
                            : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                            0xFF3869EB,
                          ).withValues(alpha: 0.82),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Powered by FutureInfoTech',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Version info
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Model Classes
class Company {
  final String id;
  final String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      name: json['companyname'] ?? json['name'] ?? 'Unknown',
    );
  }
}

class Department {
  final String id;
  final String name;
  final String? companyId;

  Department({required this.id, required this.name, this.companyId});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'].toString(),
      name: json['department'] ?? json['name'] ?? 'Unknown',
      companyId: json['companyid']?.toString(),
    );
  }
}
