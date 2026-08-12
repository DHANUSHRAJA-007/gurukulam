import 'package:flutter/material.dart';
import 'package:gurukulam/views/login/dashboard.dart';
import 'package:provider/provider.dart';

import 'package:gurukulam/core/utils/config.dart';
import 'package:gurukulam/core/utils/validators.dart';
import 'package:gurukulam/core/constant/app_constant.dart';

import 'package:gurukulam/models/login_model.dart';

import 'package:gurukulam/viewModels/login_viewmodel.dart';

// Change this import according to your dashboard location.
 
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() =>
      _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final FocusNode _usernameFocusNode =
      FocusNode();

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(
      _usernameFocusListener,
    );
  }

  void _usernameFocusListener() {
    if (!_usernameFocusNode.hasFocus) {
      final username =
          _usernameController.text.trim();

      if (username.isNotEmpty) {
        context
            .read<LoginViewModel>()
            .loadDepartments(username);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode
        .removeListener(
      _usernameFocusListener,
    );
    _usernameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginBody(),
    );
  }
}


// ======================================================
// Login Body
// ======================================================

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() =>
      _LoginBodyState();
}

class _LoginBodyState
    extends State<_LoginBody> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (
        context,
        viewModel,
        child,
      ) {
        _listenForErrors(
          context,
          viewModel,
        );

        final screenWidth =
            MediaQuery.of(context).size.width;

        final isMobile =
            screenWidth < 600;

        return Scaffold(
          backgroundColor:
              Colors.white,

          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(
                  horizontal:
                      isMobile ? 20 : 40,
                  vertical: 20,
                ),

                child: Container(
                  width: isMobile
                      ? double.infinity
                      : 441,

                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.12,
                        ),
                        blurRadius: 52.91,
                        offset:
                            const Offset(
                          3.666,
                          4.888,
                        ),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .center,

                      children: [

                        // =================================
                        // LOGO
                        // =================================

                        SizedBox(
                          width:
                              screenWidth
                                  .clamp(
                            200.0,
                            280.0,
                          ),

                          child:
                              AspectRatio(
                            aspectRatio:
                                16 / 9,

                            child:
                                Image.network(
                              '$baseUrl/img/SR logo.png',

                              fit: BoxFit
                                  .contain,

                              errorBuilder:
                                  (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Container(
                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .white
                                        .withValues(
                                      alpha: 0.9,
                                    ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                  ),

                                  child:
                                      const Icon(
                                    Icons.business,
                                    size: 80,
                                    color:
                                        Colors.blue,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 32,
                        ),

                        // =================================
                        // TITLE
                        // =================================

                        const Text(
                          'Login',

                          style:
                              TextStyle(
                            fontFamily:
                                'Poppins',
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 16,
                            color:
                                Color(
                              0xFF313131,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        const Text(
                          'Login to access your account',

                          style:
                              TextStyle(
                            fontFamily:
                                'Poppins',
                            fontWeight:
                                FontWeight.w400,
                            fontSize: 12,
                            color:
                                Color(
                              0xFF313131,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 32,
                        ),

                        // =================================
                        // USERNAME
                        // =================================

                        TextFormField(
                          controller:
                              _usernameController,

                          style:
                              const TextStyle(
                            fontFamily:
                                'Poppins',
                            fontSize: 14,
                            color:
                                Color(
                              0xFF313131,
                            ),
                          ),

                          decoration:
                              _inputDecoration(
                            'User Name',
                          ),

                          validator:
                              Validators
                                  .username,
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        // =================================
                        // PASSWORD
                        // =================================

                        TextFormField(
                          controller:
                              _passwordController,

                          obscureText:
                              viewModel
                                  .obscurePassword,

                          style:
                              const TextStyle(
                            fontFamily:
                                'Poppins',
                            fontSize: 14,
                            color:
                                Color(
                              0xFF313131,
                            ),
                          ),

                          decoration:
                              _inputDecoration(
                            'Password',

                            suffixIcon:
                                IconButton(
                              icon: Icon(
                                viewModel
                                        .obscurePassword
                                    ? Icons
                                        .visibility_off
                                    : Icons
                                        .visibility,

                                color:
                                    const Color(
                                  0xFF999999,
                                ),

                                size: 20,
                              ),

                              onPressed:
                                  viewModel
                                      .togglePasswordVisibility,
                            ),
                          ),

                          validator:
                              Validators
                                  .password,
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        // =================================
                        // DEPARTMENT
                        // =================================

                        DropdownButtonFormField<
                            String>(
                          initialValue:
                              viewModel
                                  .selectedDepartmentId,

                          isExpanded: true,

                          style:
                              const TextStyle(
                            fontFamily:
                                'Poppins',
                            fontSize: 14,
                            color:
                                Color(
                              0xFF313131,
                            ),
                          ),

                          decoration:
                              _inputDecoration(
                            'Select Department',

                            suffixIcon:
                                viewModel
                                        .isLoadingDepartments
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.all(
                                          12,
                                        ),

                                        child:
                                            SizedBox(
                                          width: 14,
                                          height: 14,

                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth:
                                                2,
                                            valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                              Colors.blue,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons
                                            .arrow_drop_down,
                                        color:
                                            Color(
                                          0xFF999999,
                                        ),
                                      ),
                          ),

                          items: viewModel
                              .departments
                              .map(
                            (
                              DepartmentModel
                                  department,
                            ) {
                              return DropdownMenuItem<
                                  String>(
                                value:
                                    department
                                        .id,

                                child: Text(
                                  department
                                      .name,

                                  style:
                                      const TextStyle(
                                    fontFamily:
                                        'Poppins',
                                    fontSize:
                                        14,
                                    color:
                                        Color(
                                      0xFF313131,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),

                          onChanged:
                              viewModel.isLoading ||
                                      viewModel
                                          .isLoadingDepartments
                                  ? null
                                  : viewModel
                                      .selectDepartment,

                          validator:
                              Validators
                                  .department,
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        // =================================
                        // LOGIN BUTTON
                        // =================================

                        SizedBox(
                          width:
                              double.infinity,

                          height: 45,

                          child:
                              ElevatedButton(
                            onPressed:
                                viewModel
                                            .isLoading ||
                                        viewModel
                                            .isLoadingDepartments
                                    ? null
                                    : () =>
                                        _login(
                                      context,
                                      viewModel,
                                    ),

                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFF3869EB,
                              ).withValues(
                                alpha: 0.82,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  4,
                                ),
                              ),

                              elevation: 0,
                            ),

                            child:
                                viewModel
                                        .isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,

                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,

                                          valueColor:
                                              AlwaysStoppedAnimation<
                                                  Color>(
                                            Colors
                                                .white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Login',

                                        style:
                                            TextStyle(
                                          fontFamily:
                                              'Poppins',
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                          fontSize:
                                              14,
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        // =================================
                        // FOOTER
                        // =================================

                        const Text(
                          'Powered by FutureInfoTech',

                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 14,
                            color:
                                Colors.black,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Version ${AppConstants.appVersion}',

                          style:
                              TextStyle(
                            fontFamily:
                                'Poppins',
                            fontSize: 11,
                            color:
                                Colors.grey[400],
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
      },
    );
  }

  // ==============================================
  // LOGIN
  // ==============================================

  Future<void> _login(
    BuildContext context,
    LoginViewModel viewModel,
  ) async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final success =
        await viewModel.login(
      username:
          _usernameController.text,
      password:
          _passwordController.text,
    );

    if (!success || !context.mounted) {
      return;
    }

    final user = viewModel.user;

    if (user == null) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('Login successful'),
        backgroundColor:
            Colors.green,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
            DashboardScreen(
         
        ),
      ),

      (route) => false,
    );
  }

  // ==============================================
  // ERROR MESSAGE
  // ==============================================

  void _listenForErrors(
    BuildContext context,
    LoginViewModel viewModel,
  ) {
    if (viewModel.errorMessage == null) {
      return;
    }

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!context.mounted) {
          return;
        }

        final message =
            viewModel.errorMessage!;

        viewModel.clearError();

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              message,

              style:
                  const TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            backgroundColor:
                Colors.red,

            duration:
                const Duration(
              seconds: 4,
            ),

            behavior:
                SnackBarBehavior
                    .floating,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),

            margin:
                const EdgeInsets.all(
              16,
            ),
          ),
        );
      },
    );
  }

  // ==============================================
  // INPUT DECORATION
  // ==============================================

  InputDecoration _inputDecoration(
    String hintText, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,

      hintStyle:
          const TextStyle(
        fontFamily: 'Poppins',
        fontWeight:
            FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF999999),
      ),

      suffixIcon: suffixIcon,

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(4),

        borderSide:
            const BorderSide(
          color: Color(
            0xFF79747E,
          ),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(4),

        borderSide:
            const BorderSide(
          color: Color(
            0xFF79747E,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(4),

        borderSide:
            const BorderSide(
          color: Color(
            0xFF2563EB,
          ),
          width: 2,
        ),
      ),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 13,
      ),
    );
  }
}