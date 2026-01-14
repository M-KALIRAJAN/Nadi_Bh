import 'package:flutter/material.dart';
import 'package:nadi_user_app/controllers/address_controller.dart';
import 'package:nadi_user_app/controllers/family_member_controller.dart';

class FamilyMemberForm {
  final FamilyMemberController memberController;
  final AddressController addressController;
  final GlobalKey<FormState> memberFormKey;
  final GlobalKey<FormState> addressFormKey;
  bool showAddress;

  FamilyMemberForm()
      : memberController = FamilyMemberController(),
        addressController = AddressController(),
        memberFormKey = GlobalKey<FormState>(),
        addressFormKey = GlobalKey<FormState>(),
        showAddress = false;
}
