import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/providers/HelpAndSuppord_Provider.dart';
import 'package:nadi_user_app/services/helpandsupport_service.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class HelpSupportView extends ConsumerStatefulWidget {
  const HelpSupportView({super.key});

  @override
  ConsumerState<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends ConsumerState<HelpSupportView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(
    text: "+973",
  ); // default prefix
  final TextEditingController _messageController = TextEditingController();
  HelpandsupportService _helpandsupportService = HelpandsupportService();
  @override
  void initState() {
    super.initState();

    // Smart phone prefix: user cannot remove +973
    _phoneController.addListener(() {
      if (!_phoneController.text.startsWith("+973")) {
        _phoneController.text = "+973";
        _phoneController.selection = const TextSelection.collapsed(
          offset: 4,
        ); // cursor after +973
      }
    });
  }

  void _submitEnquiry() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final message = _messageController.text.trim();

      try {
        // Call your API
        final result = await _helpandsupportService.fetchenquiry({
          "name": name,
          "email": email,
          "phone": phone,
          "message": message,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.enquirySuccess,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.btn_primery,
            // behavior: SnackBarBehavior.floating,
          ),
        );

        // Reset form
        _nameController.clear();
        _emailController.clear();
        _phoneController.text = "+973";
        _messageController.clear();
      } catch (err) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final helpAsync = ref.watch(helpandsupportprovider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.helpSupportTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.btn_primery,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: helpAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (help) {
          final item = help.data.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 32),

                Text(
                  loc.sendEnquiry,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _nameController,
                        label: loc.nameLabel,
                        validator: (value) =>
                            value!.isEmpty ? loc.nameValidation : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _emailController,
                        label: loc.emailLabel,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return loc.emailValidation;
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return loc.emailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _phoneController,
                        label: loc.phoneLabel,
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            (value!.length <= 4) ? loc.phoneValidation : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _messageController,
                        label: loc.messageLabel,
                        minLines: 4,
                        maxLines: 6,
                        validator: (value) =>
                            value!.isEmpty ? loc.messageValidation : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitEnquiry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btn_primery,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            loc.submitButton,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
