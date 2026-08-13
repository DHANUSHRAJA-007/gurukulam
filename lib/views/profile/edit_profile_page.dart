import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewModels/profile_viewmodel.dart';
import '../../widgets/custom_dropdown_search.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  int? _selectedIndustryId;
  String? _selectedIndustry;
  int? _selectedLocationId;
  String? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<ProfileViewModel>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _mobileController = TextEditingController(text: user?.mobile ?? '');
    _selectedIndustryId = user?.industryId;
    _selectedIndustry = user?.industryName;
    _selectedLocationId = user?.locationId;
    _selectedLocation = user?.locationName;

    // Load industries and locations if not loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      if (viewModel.industries.isEmpty && viewModel.locations.isEmpty) {
        viewModel.loadIndustryAndLoc();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        elevation: 1,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.black87,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade700,
                      ),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // // Profile Avatar Section
            // _buildProfileAvatar(viewModel),
            // const SizedBox(height: 20),

            // Form Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 20,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Name Field
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mobile Field
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
                            return 'Please enter valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Section Title - Job Details
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.work_outline,
                              size: 20,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Job Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Industry Dropdown
                      CustomDropdownSearch(
                        label: 'Industry',
                        selectedItem: _selectedIndustry,
                        items: viewModel.industries.map((industry) {
                          return industry.name;
                        }).toList(),
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
                      ),
                      const SizedBox(height: 16),

                      // Location Dropdown
                      CustomDropdownSearch(
                        label: 'Location',
                        selectedItem: _selectedLocation,
                        items: viewModel.locations.map((location) {
                          return location.name;
                        }).toList(),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Error Message
            if (viewModel.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
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
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.blue.shade200,
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Saving...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildProfileAvatar(ProfileViewModel viewModel) {
  //   final user = viewModel.user;
  //   return Center(
  //     child: Column(
  //       children: [
  //         Stack(
  //           children: [
  //             Container(
  //               width: 100,
  //               height: 100,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                   colors: [Colors.blue.shade400, Colors.blue.shade700],
  //                 ),
  //                 shape: BoxShape.circle,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.blue.shade100,
  //                     blurRadius: 20,
  //                     spreadRadius: 5,
  //                   ),
  //                 ],
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   user?.name[0].toUpperCase() ?? 'U',
  //                   style: const TextStyle(
  //                     fontSize: 40,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 0,
  //               right: 0,
  //               child: Container(
  //                 padding: const EdgeInsets.all(4),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   shape: BoxShape.circle,
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withValues(alpha: 0.1),
  //                       blurRadius: 4,
  //                     ),
  //                   ],
  //                 ),
  //                 child: Icon(
  //                   Icons.camera_alt,
  //                   size: 20,
  //                   color: Colors.blue.shade700,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Change Photo',
  //           style: TextStyle(
  //             color: Colors.blue.shade700,
  //             fontSize: 13,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updates = <String, dynamic>{
        'name': _nameController.text,
        'mobile': _mobileController.text,
      };

      if (_selectedIndustryId != null) {
        updates['industry_id'] = _selectedIndustryId;
      }

      if (_selectedLocationId != null) {
        updates['location_id'] = _selectedLocationId;
      }

      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      final success = await viewModel.updateProfile(updates);

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
