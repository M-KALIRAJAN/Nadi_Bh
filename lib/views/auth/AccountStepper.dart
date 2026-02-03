import 'package:flutter/material.dart';
import 'package:nadi_user_app/controllers/address_controller.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/views/auth/AccountFormView.dart';
import 'package:nadi_user_app/views/auth/AddMember.dart';
import 'package:nadi_user_app/views/auth/Address.dart';

class AccountStepper extends StatefulWidget {
  final String accountType; // "Individual" or "Family"

  const AccountStepper({super.key, required this.accountType});

  @override
  State<AccountStepper> createState() => _AccountStepperState();
}

class _AccountStepperState extends State<AccountStepper> {
  int _currentStep = 0;

  final _formKeyIndividual = GlobalKey<FormState>();
  final _formKeyAddress = GlobalKey<FormState>();
  final _formKeyAddMember = GlobalKey<FormState>();
  final addressController = AddressController();
  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return AccountFormView(
          key: const ValueKey(0),
          accountType: widget.accountType,
          formKey: _formKeyIndividual,
          onNext: () {
            if (_formKeyIndividual.currentState!.validate()) {
              setState(() => _currentStep = 1);
            }
          },
        );

      case 1:
        return Address(
          key: const ValueKey(1),
          accountType: widget.accountType,
          formKey: _formKeyAddress,
          controller: addressController,
          onNext: () {
            if (_formKeyAddress.currentState!.validate()) {
              setState(() {
                if (widget.accountType == "Family") {
                  _currentStep = 2;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account created successfully"),
                    ),
                  );
                }
              });
            }
          },
        );

      case 2:
        return Addmember(
          key: const ValueKey(2),
          accountType: widget.accountType,
          formKey: _formKeyAddMember,
          onNext: () {
            if (_formKeyAddMember.currentState!.validate()) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Completed!")));
            }
          },
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> stepTitles = widget.accountType == "Family"
        ? ["Family", "Address", " Member"]
        : ["Account", "Address"];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.accountType} Account",style: TextStyle(color: Colors.white),),      
          backgroundColor: AppColors.btn_primery,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,),

      body: Column(
        children: [
          // CUSTOM STEPPER
          Padding(
            padding: const EdgeInsets.only(top: 15,bottom: 5,left: 20,right: 20),
            child: CustomStepper(currentStep: _currentStep, titles: stepTitles),
          ),

          const SizedBox(height: 10),

          // SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),

        
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(1, 0), //  Right to Left
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(position: slide, child: child);
                },
                child: _buildStep(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//   CUSTOM STEPPER UI

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<String> titles;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(titles.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;

          bool isActive = stepIndex == currentStep;
          bool isCompleted = stepIndex < currentStep;

          return Column(
            children: [
              // ---------- CIRCLE ----------
              CircleAvatar(
                radius: 10,
                backgroundColor: isActive || isCompleted
                    ? const Color(0xFF0A7A55)
                    : Colors.grey.shade400,
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                        "${stepIndex + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 5),

              // ---------- LABEL ----------
              Text(
                titles[stepIndex],
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? const Color(0xFF0A7A55)
                      : Colors.grey.shade500,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        } else {
          int leftStep = index ~/ 2;

          bool isLeftCompleted = leftStep < currentStep;

          return Expanded(
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                height: 2,
                // margin: const EdgeInsets.symmetric(horizontal: 4),
                color: isLeftCompleted
                    ? const Color(0xFF0A7A55)
                    : Colors.grey.shade300,
              ),
            ),
          );
        }
      }),
    );
  }
}
