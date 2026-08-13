import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewModels/signup_viewmodel.dart';
import '../../widgets/custom_dropdown_search.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int? _selectedIndustryId;
  String? _selectedIndustry;
  int? _selectedLocationId;
  String? _selectedLocation;

  bool _agreeTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<SignUpViewModel>(context, listen: false);
      viewModel.loadIndustryAndLoc();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Convert List<dynamic> to List<String> - FIXED ✅
    final List<String> industryNames = viewModel.industries
        .map((industry) => industry.name as String)
        .toList();

    final List<String> locationNames = viewModel.locations
        .map((location) => location.name as String)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: 20,
            ),
            child: Container(
              width: isMobile ? double.infinity : 480,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =================================
                    // HEADER
                    // =================================
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'GURUKULAM',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D9488),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create your account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fill in the details below to get started',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // =================================
                    // FULL NAME
                    // =================================
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // =================================
                    // MOBILE NUMBER
                    // =================================
                    _buildTextField(
                      controller: _mobileController,
                      label: 'Mobile Number',
                      hint: 'Enter 10-digit mobile number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.length != 10) {
                          return 'Please enter valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // =================================
                    // EMAIL ID
                    // =================================
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email ID',
                      hint: 'Enter your email address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email address';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // =================================
                    // PASSWORD
                    // =================================
                    TextFormField(
                      controller: _passwordController,
                      obscureText: viewModel.obscurePassword,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Create a strong password',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                          onPressed: viewModel.togglePasswordVisibility,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D9488),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade300,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade300,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 8) {
                          return 'Minimum 8 characters required';
                        }
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)')
                            .hasMatch(value)) {
                          return 'Must contain letters and numbers';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Minimum 8 characters with letters and numbers',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // =================================
                    // INTERESTED ROLE (Industry)
                    // =================================
                    if (viewModel.isLoadingDropdowns)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0D9488),
                              ),
                            ),
                          ),
                        ),
                      )
                    else ...[
                      CustomDropdownSearch(
                        label: 'Industry',
                        selectedItem: _selectedIndustry,
                        items: industryNames,  // ← FIXED ✅
                        onChanged: (value) {
                          setState(() {
                            _selectedIndustry = value;
                            _selectedIndustryId = viewModel.industries
                                .firstWhere(
                                  (industry) => industry.name == value,
                            )
                                .id;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 18),

                    // =================================
                    // INTERESTED LOCATION
                    // =================================
                    if (viewModel.isLoadingDropdowns)
                      const SizedBox.shrink()
                    else ...[
                      CustomDropdownSearch(
                        label: 'Interested Location',
                        selectedItem: _selectedLocation,
                        items: locationNames,  // ← FIXED ✅
                        onChanged: (value) {
                          setState(() {
                            _selectedLocation = value;
                            _selectedLocationId = viewModel.locations
                                .firstWhere(
                                  (location) => location.name == value,
                            )
                                .id;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a location';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 24),

                    // =================================
                    // TERMS & CONDITIONS
                    // =================================
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeTerms = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'I agree to the Terms of Service and Privacy Policy',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // =================================
                    // ERROR MESSAGE
                    // =================================
                    if (viewModel.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // =================================
                    // SIGN UP BUTTON
                    // =================================
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => SignUpViewModel(),
                                child: const SignUpView(),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3869EB),
                          side: const BorderSide(
                            color: Color(0xFF3869EB),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF3869EB),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // =================================
                    // CANCEL BUTTON
                    // =================================
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // =================================
                    // ALREADY HAVE ACCOUNT?
                    // =================================
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade500,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0D9488),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade300,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade300,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        errorStyle: TextStyle(
          color: Colors.red.shade700,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to Terms of Service'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final viewModel = Provider.of<SignUpViewModel>(context, listen: false);

    final success = await viewModel.signUp(
      name: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      password: _passwordController.text,
      industryId: _selectedIndustryId,
      locationId: _selectedLocationId,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign Up Successful!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }
}