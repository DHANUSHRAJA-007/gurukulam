import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gurukulam/core/utils/config.dart';
import 'package:gurukulam/models/master_model.dart';
import 'package:gurukulam/services/master_service.dart';
import 'package:gurukulam/viewModels/job_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class JobCreationPage extends StatefulWidget {
  const JobCreationPage({super.key});

  @override
  State<JobCreationPage> createState() => _JobCreationPageState();
}

class _JobCreationPageState extends State<JobCreationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _salaryMinController = TextEditingController();

  final TextEditingController _salaryMaxController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _experienceController = TextEditingController();

  final TextEditingController _shiftController = TextEditingController();

  final TextEditingController _vacancyController = TextEditingController(
    text: '1',
  );

  final TextEditingController _benefitsController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _tagMessageController = TextEditingController();

  final TextEditingController _skillController = TextEditingController();

  int? jobRoleId;
  int? industryId;
  int? qualificationId;
  int? employmentTypeId;

  String jobStatus = 'Draft';
  String workMode = 'On-site';
  String gender = 'Any';

  final List<int> selectedLanguages = [];

  final List<String> skills = [];

  List<MasterModel> _jobRoles = [];
  List<MasterModel> _industries = [];
  List<MasterModel> _degrees = [];
  List<MasterModel> _employmentTypes = [];
  List<MasterModel> _languages = [];

  bool _mastersLoading = true;

  final List<TextEditingController> _screeningControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // final List<String> screeningQuestions = [
  //   'Can you give me a brief overview of your background and your current role?',
  //   'What drew you to this position in particular, and why are you looking to leave your current role?',
  //   'What are your salary expectations for this role?',
  //   'When would you be ready to start if an offer were made?',
  //   'Are you comfortable with the on-site location/hybrid schedule and the daily working hours?',
  // ];

  @override
  void dispose() {
    _locationController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _ageController.dispose();
    _experienceController.dispose();
    _shiftController.dispose();
    _vacancyController.dispose();
    _benefitsController.dispose();
    _descriptionController.dispose();
    _tagMessageController.dispose();
    _skillController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMasters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1036),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildHeader(),

                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('BASIC INFORMATION'),

                            _buildBasicInformation(),

                            const SizedBox(height: 30),

                            _sectionTitle('JOB REQUIREMENTS'),

                            _buildJobRequirements(),

                            const SizedBox(height: 30),

                            _sectionTitle('ADDITIONAL INFORMATION'),

                            _buildAdditionalInformation(),

                            const SizedBox(height: 30),

                            _sectionTitle('SCREENING QUESTIONS'),

                            _buildScreeningQuestions(),
                            const SizedBox(height: 30),

                            _buildButtons(),
                          ],
                        ),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D9488),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(width: 12),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Creation Form',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Complete all fields to create a comprehensive job listing',
                style: TextStyle(color: Color(0xFFF4C20D), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF112C69),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInformation() {
    return Column(
      children: [
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _masterDropdown(
                label: 'JOB ROLE / TITLE',
                value: jobRoleId,
                onChanged: (value) {
                  setState(() {
                    jobRoleId = value;
                  });
                },
                masterType: 'job_role',
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: _masterDropdown(
                label: 'INDUSTRY',
                value: industryId,
                onChanged: (value) {
                  setState(() {
                    industryId = value;
                  });
                },
                masterType: 'industry',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildStatusDropdown(),
      ],
    );
  }

  Widget _buildWorkMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('WORK MODE'),

        const SizedBox(height: 8),

        Wrap(
          spacing: 10,
          children: [
            _choiceButton('On-site', workMode == 'On-site', () {
              setState(() {
                workMode = 'On-site';
              });
            }),

            _choiceButton('Remote', workMode == 'Remote', () {
              setState(() {
                workMode = 'Remote';
              });
            }),

            _choiceButton('Hybrid', workMode == 'Hybrid', () {
              setState(() {
                workMode = 'Hybrid';
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,

          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }

                  return null;
                }
              : null,

          style: const TextStyle(fontSize: 13, color: Color(0xFF112C69)),

          decoration: InputDecoration(
            hint: Text(hint),
            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> createJob(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/job_insert.php'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    debugPrint('JOB INSERT STATUS: ${response.statusCode}');

    debugPrint('JOB INSERT RESPONSE: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message'] ?? 'Failed to create job');
    }

    debugPrint('JOB INSERT SUCCESS: ${result['message']}');
  }

  Widget _buildButtons() {
    return Consumer<JobViewModel>(
      builder: (context, vm, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: vm.isLoading ? null : _clearForm,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(96, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),

            const SizedBox(width: 12),

            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      print('11');
                      debugPrint('CREATE BUTTON CLICKED');

                      await _createJob();
                    },
              child: vm.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Job'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF832BD9),
                foregroundColor: Colors.white,
                minimumSize: const Size(181, 44),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     _createJob;
            //     print("Presses");
            //   },

            //   // vm.isLoading ? null :
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFF832BD9),
            //     foregroundColor: Colors.white,
            //     minimumSize: const Size(181, 44),
            //     elevation: 0,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: vm.isLoading
            //       ? const SizedBox(
            //           width: 18,
            //           height: 18,
            //           child: CircularProgressIndicator(
            //             strokeWidth: 2,
            //             color: Colors.white,
            //           ),
            //         )
            //       : const Text('Create Job'),
            // ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      jobRoleId = null;
      industryId = null;
      qualificationId = null;
      employmentTypeId = null;

      jobStatus = 'Draft';
      workMode = 'On-site';
      gender = 'Any';

      selectedLanguages.clear();
      skills.clear();

      _locationController.clear();
      _salaryMinController.clear();
      _salaryMaxController.clear();
      _ageController.clear();
      _experienceController.clear();
      _shiftController.clear();

      _vacancyController.text = '1';

      _benefitsController.clear();
      _descriptionController.clear();
      _tagMessageController.clear();
      _skillController.clear();
    });
    Navigator.pop(context);
  }

  Widget _buildJobRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildWorkMode()),
            const SizedBox(width: 20),
            Expanded(
              child: _field(
                'LOCATION',
                _locationController,
                required: true,
                hint: '',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildSalaryRange()),
            const SizedBox(width: 20),
            Expanded(
              child: _field(
                'AGE LIMIT',
                _ageController,
                keyboardType: TextInputType.number,
                hint: '',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildGenderPreference(),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _masterDropdown(
                label: 'MINIMUM QUALIFICATION',
                value: qualificationId,
                masterType: 'degree',
                onChanged: (value) {
                  setState(() {
                    qualificationId = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _field(
                'EXPERIENCE REQUIRED',
                _experienceController,
                required: true,
                hint: '',
                // hint: 'e.g. 2 - 4 Years',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildLanguages(),

        const SizedBox(height: 20),

        _buildSkills(),
      ],
    );
  }

  Widget _buildAdditionalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _masterDropdown(
                label: 'EMPLOYMENT TYPE',
                value: employmentTypeId,
                masterType: 'employment_type',
                onChanged: (value) {
                  setState(() {
                    employmentTypeId = value;
                  });
                },
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: _field(
                'WORK SHIFT TIMING',
                _shiftController,
                hint: 'e.g. 9:00 AM - 6:00 PM',
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: _field(
                'NUMBER OF VACANCIES',
                _vacancyController,
                keyboardType: TextInputType.number,
                required: true,
                hint: '',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _field(
          'JOB BENEFITS',
          _benefitsController,
          maxLines: 4,
          hint: 'Enter job benefits',
        ),

        const SizedBox(height: 20),

        _field(
          'JOB DESCRIPTION',
          _descriptionController,
          maxLines: 5,
          required: true,
          hint: 'Enter detailed job description',
        ),

        const SizedBox(height: 20),

        _field('TAG MESSAGE', _tagMessageController, hint: 'Enter tag message'),
      ],
    );
  }

  Future<void> _loadMasters() async {
    try {
      setState(() {
        _mastersLoading = true;
      });

      final service = MasterService();

      final results = await Future.wait([
        service.getMasters('job_role'),
        service.getMasters('industry'),
        service.getMasters('degree'),
        service.getMasters('employment_type'),
        service.getMasters('language'),
      ]);

      if (!mounted) return;

      setState(() {
        _jobRoles = results[0];
        _industries = results[1];
        _degrees = results[2];
        _employmentTypes = results[3];
        _languages = results[4];

        _mastersLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _mastersLoading = false;
      });

      _showMessage('Failed to load master data', Colors.red);
    }
  }

  Widget _masterDropdown({
    required String label,
    required int? value,
    required String masterType,
    required ValueChanged<int?> onChanged,
  }) {
    List<MasterModel> items;

    switch (masterType) {
      case 'job_role':
        items = _jobRoles;
        break;

      case 'industry':
        items = _industries;
        break;

      case 'degree':
        items = _degrees;
        break;

      case 'employment_type':
        items = _employmentTypes;
        break;

      default:
        items = [];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: true),

        const SizedBox(height: 8),

        DropdownButtonFormField<int>(
          initialValue: value,
          isExpanded: true,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
          ),

          hint: Text(
            _mastersLoading ? 'Loading...' : 'Select $label',
            style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),

          items: items.map((item) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 13, color: Color(0xFF112C69)),
              ),
            );
          }).toList(),

          onChanged: _mastersLoading ? null : onChanged,

          validator: (value) {
            if (value == null) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Widget _masterDropdown({
  //   required String label,
  //   required int? value,
  //   required String masterType,
  //   required ValueChanged<int?> onChanged,
  // }) {
  //   List<MasterModel> items;

  //   switch (masterType) {
  //     case 'job_role':
  //       items = _jobRoles;
  //       break;

  //     case 'industry':
  //       items = _industries;
  //       break;

  //     case 'degree':
  //       items = _degrees;
  //       break;

  //     case 'employment_type':
  //       items = _employmentTypes;
  //       break;

  //     default:
  //       items = [];
  //   }

  //   return Column(
  //     crossAxisAlignment:
  //         CrossAxisAlignment.start,
  //     children: [
  //       _label(
  //         label,
  //         required: true,
  //       ),

  //       const SizedBox(height: 8),

  //       DropdownButtonFormField<int>(
  //         value: value,
  //         isExpanded: true,

  //         decoration: InputDecoration(
  //           filled: true,
  //           fillColor: Colors.white,

  //           contentPadding:
  //               const EdgeInsets.symmetric(
  //             horizontal: 14,
  //             vertical: 12,
  //           ),

  //           border: OutlineInputBorder(
  //             borderRadius:
  //                 BorderRadius.circular(8),
  //             borderSide: const BorderSide(
  //               color: Color(0xFFD1D5DB),
  //             ),
  //           ),

  //           enabledBorder:
  //               OutlineInputBorder(
  //             borderRadius:
  //                 BorderRadius.circular(8),
  //             borderSide: const BorderSide(
  //               color: Color(0xFFD1D5DB),
  //             ),
  //           ),
  //         ),

  //         hint: Text(
  //           _mastersLoading
  //               ? 'Loading...'
  //               : 'Select $label',
  //           style: const TextStyle(
  //             fontSize: 13,
  //             color: Color(0xFF94A3B8),
  //           ),
  //         ),

  //         items: items.map((item) {
  //           return DropdownMenuItem<int>(
  //             value: item.id,
  //             child: Text(
  //               item.name,
  //               style: const TextStyle(
  //                 fontSize: 13,
  //                 color: Color(0xFF112C69),
  //               ),
  //             ),
  //           );
  //         }).toList(),

  //         onChanged:
  //             _mastersLoading
  //                 ? null
  //                 : onChanged,

  //         validator: (value) {
  //           if (value == null) {
  //             return 'Required';
  //           }
  //           return null;
  //         },
  //       ),
  //     ],
  //   );
  // }
  Widget _label(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF112C69),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _choiceButton(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),

        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE0F2FE) : const Color(0xFFF8FAFC),

          border: Border.all(
            color: selected ? const Color(0xFF3B82F6) : const Color(0xFFD1D5DB),
          ),

          borderRadius: BorderRadius.circular(8),
        ),

        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? const Color(0xFF2563EB) : const Color(0xFF112C69),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 13)),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  Widget _buildSalaryRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('SALARY RANGE (PER ANNUM)'),

        const SizedBox(height: 8),

        Row(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '₹ INR',
                style: TextStyle(fontSize: 13, color: Color(0xFF112C69)),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: TextFormField(
                controller: _salaryMinController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Minimum'),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: TextFormField(
                controller: _salaryMaxController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Maximum'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
    );
  }

  Widget _buildGenderPreference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('GENDER PREFERENCE'),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          children: [
            _choiceButton('Any', gender == 'Any', () {
              setState(() {
                gender = 'Any';
              });
            }),

            _choiceButton('Male', gender == 'Male', () {
              setState(() {
                gender = 'Male';
              });
            }),

            _choiceButton('Female', gender == 'Female', () {
              setState(() {
                gender = 'Female';
              });
            }),

            _choiceButton('Non-binary', gender == 'Non-binary', () {
              setState(() {
                gender = 'Non-binary';
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('LANGUAGES KNOWN'),

        const SizedBox(height: 8),

        InkWell(
          onTap: _showLanguageSelector,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: selectedLanguages.isEmpty
                ? const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Click to add languages',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    ),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: selectedLanguages.map((id) {
                      final language = _languages.firstWhere((e) => e.id == id);

                      return Chip(
                        label: Text(
                          language.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedLanguages.remove(id);
                          });
                        },
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showLanguageSelector() async {
    final tempSelected = List<int>.from(selectedLanguages);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Languages'),
              content: SizedBox(
                width: 400,
                child: ListView(
                  shrinkWrap: true,
                  children: _languages.map((language) {
                    final selected = tempSelected.contains(language.id);

                    return CheckboxListTile(
                      value: selected,
                      title: Text(language.name),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(language.id);
                          } else {
                            tempSelected.remove(language.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguages
                        ..clear()
                        ..addAll(tempSelected);
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('SKILLS REQUIRED'),

        const SizedBox(height: 8),

        TextField(
          controller: _skillController,
          onSubmitted: (_) {
            _addSkill();
          },
          decoration: _inputDecoration('Type a skill and press Enter'),
        ),

        if (skills.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  onDeleted: () {
                    setState(() {
                      skills.remove(skill);
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();

    if (skill.isEmpty) return;

    if (!skills.contains(skill)) {
      setState(() {
        skills.add(skill);
      });
    }

    _skillController.clear();
  }

  Widget _buildStatusDropdown() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('JOB STATUS', required: true),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: jobStatus,

            isExpanded: true,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 1.2,
                ),
              ),
            ),

            hint: const Text(
              'Select Job Status',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),

            items: const [
              DropdownMenuItem<String>(
                value: 'Draft',
                child: Text(
                  'Draft',
                  style: TextStyle(fontSize: 13, color: Color(0xFF112C69)),
                ),
              ),

              DropdownMenuItem<String>(
                value: 'Published',
                child: Text(
                  'Published',
                  style: TextStyle(fontSize: 13, color: Color(0xFF112C69)),
                ),
              ),

              DropdownMenuItem<String>(
                value: 'Closed',
                child: Text(
                  'Closed',
                  style: TextStyle(fontSize: 13, color: Color(0xFF112C69)),
                ),
              ),
            ],

            onChanged: (value) {
              if (value == null) return;

              setState(() {
                jobStatus = value;
              });
            },

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select job status';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ...List.generate(_screeningControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _screeningControllers[index],

                          maxLines: 2,

                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF112C69),
                          ),

                          decoration: InputDecoration(
                            labelText: 'Screening Question ${index + 1}',

                            hintText: 'Enter screening question',

                            labelStyle: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),

                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),

                            filled: true,

                            fillColor: const Color(0xFFF8FAFC),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1D5DB),
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1D5DB),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF3B82F6),
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: IconButton(
                          tooltip: 'Delete question',

                          icon: const Icon(Icons.delete_outline, size: 20),

                          color: const Color(0xFFEF4444),

                          onPressed: _screeningControllers.length > 1
                              ? () {
                                  _deleteScreeningQuestion(index);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 4),

              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _addScreeningQuestion,

                  icon: const Icon(Icons.add, size: 18),

                  label: const Text('Add Question'),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),

                    side: const BorderSide(color: Color(0xFF2563EB)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createJob() async {
    debugPrint('1️⃣ CREATE JOB STARTED');

    try {
      debugPrint('2️⃣ Starting validation');

      final isValid = _formKey.currentState?.validate() ?? false;

      debugPrint('3️⃣ Validation result: $isValid');

      if (!isValid) {
        debugPrint('❌ FORM VALIDATION FAILED');
        return;
      }

      debugPrint('4️⃣ Validation passed');

      // Get screening questions from controllers
      final screeningQuestions = _screeningControllers
          .map((controller) => controller.text.trim())
          .where((question) => question.isNotEmpty)
          .toList();

      debugPrint('5️⃣ Questions: $screeningQuestions');

      final data = {
        'job_status': jobStatus,

        'job_role_id': jobRoleId,

        'industry_id': industryId,

        'work_mode': workMode,

        'location': _locationController.text.trim(),

        'salary_min': _salaryMinController.text.trim(),

        'salary_max': _salaryMaxController.text.trim(),

        'gender_preference': gender,

        'age_limit': _ageController.text.trim(),

        'minimum_qualification_id': qualificationId,

        'experience_required': _experienceController.text.trim(),

        'languages': selectedLanguages,

        'skills': skills,

        'employment_type_id': employmentTypeId,

        'work_shift_timing': _shiftController.text.trim(),

        'number_of_vacancies':
            int.tryParse(_vacancyController.text.trim()) ?? 1,

        'job_benefits': _benefitsController.text.trim(),

        'job_description': _descriptionController.text.trim(),

        'tag_message': _tagMessageController.text.trim(),

        'screening_questions': screeningQuestions,

        'status': 1,
      };

      debugPrint('6️⃣ DATA CREATED');
      debugPrint(data.toString());

      debugPrint('7️⃣ Calling ViewModel');

      await context.read<JobViewModel>().createJob(data);

      debugPrint('8️⃣ CREATE JOB SUCCESS');

      if (!mounted) return;

      _showMessage('Job created successfully', Colors.green);
    } catch (e, stackTrace) {
      debugPrint('❌ CREATE JOB ERROR: $e');

      debugPrint(stackTrace.toString());

      if (!mounted) return;

      _showMessage(e.toString(), Colors.red);
    }
  }

  void _addScreeningQuestion() {
    setState(() {
      _screeningControllers.add(TextEditingController());
    });
  }

  void _deleteScreeningQuestion(int index) {
    if (_screeningControllers.length <= 1) {
      return;
    }

    setState(() {
      final controller = _screeningControllers.removeAt(index);

      controller.dispose();
    });
  }
}
