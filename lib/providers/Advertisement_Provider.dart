 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Advertisement_Model.dart';
import 'package:nadi_user_app/services/Advertisement_Service.dart';

final fetchadvertisementprovider = FutureProvider<Advertisementmodel>((ref) async {
  final result = await AdvertisementService().fetchadvertisementdata();
  return result;
});