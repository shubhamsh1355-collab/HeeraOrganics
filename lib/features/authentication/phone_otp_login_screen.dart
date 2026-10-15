import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/repositories/profile_repository.dart';

class PhoneOtpLoginScreen extends ConsumerStatefulWidget {
  const PhoneOtpLoginScreen({super.key});

  @override
  ConsumerState<PhoneOtpLoginScreen> createState() =>
      _PhoneOtpLoginScreenState();
}

class _PhoneOtpLoginScreenState extends ConsumerState<PhoneOtpLoginScreen> {
  final TextEditingController _phoneController = TextEditingController(
    text: '9876543210',
  );
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _otpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
        _otpSent = true;
      });
      // Fill demo OTP "123456" for convenience
      _otpControllers[0].text = '1';
      _otpControllers[1].text = '2';
      _otpControllers[2].text = '3';
      _otpControllers[3].text = '4';
      _otpControllers[4].text = '5';
      _otpControllers[5].text = '6';
    });
  }

  void _verifyOtp() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      ref
          .read(profileProvider.notifier)
          .loginWithPhone('+91 ${_phoneController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully authenticated! Welcome to Heera Organics.',
          ),
          backgroundColor: AppColors.primaryContainer,
        ),
      );
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand Icon
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.softGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.spa,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                _otpSent ? 'Verify 6-Digit OTP' : 'Login with Mobile',
                style: AppTypography.headlineLgMobile(
                  color: AppColors.deepText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _otpSent
                    ? 'Enter the 6-digit code sent to +91 ${_phoneController.text}'
                    : 'Enter your phone number to receive a secure login code and manage your doorstep deliveries.',
                style: AppTypography.bodyMd(color: AppColors.mutedText),
              ),
              const SizedBox(height: 28),

              if (!_otpSent) ...[
                // Phone Number Input
                Text(
                  'Mobile Number',
                  style: AppTypography.labelMd(color: AppColors.deepText),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteSurface,
                    borderRadius: AppRadii.radiusMd,
                    border: Border.all(
                      color: AppColors.borderSubtle,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: AppColors.borderSubtle,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          '+91',
                          style: AppTypography.labelLg(
                            color: AppColors.deepText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTypography.bodyLg(
                            color: AppColors.deepText,
                          ),
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Send Verification Code',
                  isLoading: _isLoading,
                  onPressed: _sendOtp,
                  width: double.infinity,
                ),
              ] else ...[
                // 6-digit OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 44,
                      height: 52,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: AppTypography.headlineSm(
                          color: AppColors.deepText,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.whiteSurface,
                          border: OutlineInputBorder(
                            borderRadius: AppRadii.radiusMd,
                            borderSide: const BorderSide(
                              color: AppColors.borderSubtle,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadii.radiusMd,
                            borderSide: const BorderSide(
                              color: AppColors.primaryContainer,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (val.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Resend Timer & Change Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _otpSent = false),
                      child: Text(
                        'Change Number',
                        style: AppTypography.labelMd(
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ),
                    Text(
                      'Resend in 28s',
                      style: AppTypography.labelMd(color: AppColors.mutedText),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                AppButton(
                  text: 'Verify & Continue',
                  isLoading: _isLoading,
                  onPressed: _verifyOtp,
                  width: double.infinity,
                ),
              ],

              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    ref.read(profileProvider.notifier).loginAsGuest();
                    context.go('/home');
                  },
                  child: Text(
                    'Continue as Guest',
                    style: AppTypography.labelMd(color: AppColors.mutedText),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'By continuing, you agree to Heera Organics\'\nTerms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSm(color: AppColors.mutedText)
                      .copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
