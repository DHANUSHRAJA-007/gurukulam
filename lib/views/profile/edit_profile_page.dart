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
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mobile Field
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
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
                const SizedBox(height: 16),

                // Industry Dropdown
                CustomDropdownSearch(
                  label: 'Industry',
                  selectedItem: _selectedIndustry,
                  items: viewModel.industries.map((industry) {
                    return industry.name;
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustryId = viewModel.industries
                          .firstWhere((industry) => industry.name == value)
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
                      _selectedLocationId = viewModel.locations
                          .firstWhere((location) => location.name == value)
                          .id;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Error Message
                if (viewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.red.shade100,
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
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

      // Add industry_id if selected
      if (_selectedIndustryId != null) {
        updates['industry_id'] = _selectedIndustryId;
      }

      // Add location_id if selected
      if (_selectedLocationId != null) {
        updates['location_id'] = _selectedLocationId;
      }

      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      final success = await viewModel.updateProfile(updates);

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }
}
