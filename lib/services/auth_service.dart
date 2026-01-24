import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _dio = DioClient.dio;

  // Fetch account type
  Future<List<Map<String?, dynamic>>?> acountype() async {
    try {
      final response = await _dio.get("account-type");
    } catch (e, st) {
      AppLogger.error("Account type API error: $e\n$st");
      return null;
    }
  }

  Future<bool> selectAccount({required String accountTypeId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      AppLogger.warn("accountTypeId: $accountTypeId");
      final response = await _dio.post(
        "user-account",
        data: {"accountTypeId": accountTypeId},
      );

      AppLogger.debug("selectAccount response: ${response.data}");

      final userId = response.data["userId"]?.toString();
      if (userId != null) {
        await AppPreferences.saveUserId(userId);
        AppLogger.warn("userId saved: $userId");
      }

      return true;
    } catch (e, st) {
      AppLogger.error("Account type API error: $e\n$st");
      return false;
    }
  }

  // Sign Up Basic INFO
  Future<Map<String?, dynamic>> basicInfo({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String password,
    required String gender,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        "user-account/basic-info",
        data: {
          "userId": userId,
          "fullName": fullName,
          "mobileNumber": mobileNumber,
          "email": email,
          "password": password,
          "gender": gender,
        },
      );
      AppLogger.success(response.data.toString());
      return response.data;
    } on DioException catch (e) {
      AppLogger.error("Login ${e.response?.statusCode}");
      AppLogger.error("Login ${e.response?.data}");
      throw e; //  ADD THIS LINE ONLY
    }
  }

  //Selected Block
  Future<List<Map<String, dynamic>>> selectblock() async {
    try {
      final response = await _dio.get("block");

      // Ensure proper typing
      final List<dynamic> rawData = response.data["data"];
      final blockData = rawData
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // Print entire JSON nicely
      final prettyJson = const JsonEncoder.withIndent('  ').convert(blockData);

      print(prettyJson);

      return blockData;
    } catch (e) {
      AppLogger.error("SELECTBLOCK Error: $e");
      return [];
    }
  }

  // Adress Details
  Future<Map<String, dynamic>?> adressdetails({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post("user-account/address", data: body);

      AppLogger.success("ADDRESS RESPONSE  ${response.data}");
      return response.data;
    } on DioException catch (e) {
      AppLogger.error("Login ${e.response?.statusCode}");
      AppLogger.error("Login ${e.response?.data}");
    }
  }

  // Add Family Member
  Future<Map<String, dynamic>?> memberdetails({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(
        "user-account/add-family-member",
        data: body,
      );
      AppLogger.success("ADDRESS RESPONSE  ${response.data}");
      return response.data;
    } on DioException catch (e) {
      AppLogger.error("Login ${e.response?.statusCode}");
      AppLogger.error("Login ${e.response?.data}");
      throw e;
    }
  }
  // Upload ID
  Future<Map<String, dynamic>?> uploadIdProof({
    required File frontImage,
    required File backImage,
    required String userId,
  }) async {
    try {
      final formData = FormData();

      formData.fields.add(MapEntry("userId", userId));

      formData.files.add(
        MapEntry(
          "idProof",
          await MultipartFile.fromFile(
            frontImage.path,
            filename: frontImage.path.split('/').last,
          ),
        ),
      );

      formData.files.add(
        MapEntry(
          "idProof",
          await MultipartFile.fromFile(
            backImage.path,
            filename: backImage.path.split('/').last,
          ),
        ),
      );

      final response = await _dio.post(
        "user-account/upload-id",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      return response.data;
    } on DioException catch (e) {
      ///  BACKEND ERROR MESSAGE
      final message =
          e.response?.data?["message"] ??
          e.response?.data?["error"] ??
          "Upload failed";

      AppLogger.error("Upload idProof DioError: $message");

      /// Pass readable error to UI
      throw Exception(message);
    } catch (e, st) {
      AppLogger.error("Upload idProof error: $e\n$st");
      throw Exception("Something went wrong");
    }
  }

  //Terms & Conditions

  Future<Map<String, dynamic>?> TermsAndSonditions({
    required String userId,
    required String fcmToken,
  }) async {
    try {
      final response = await _dio.post(
        "user-account/terms-verify",
        data: {"userId": userId, "fcmToken": fcmToken},
      );
      return response.data;
    } catch (e) {
      AppLogger.error("Terms & Conditions : $e");
    }
  }

  //  Complete User Account
  Future<Map<String, dynamic>?> CompleteuserAccount({
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        "user-account/complete",
        data: {"userId": userId},
      );

      //  LOG OUTPUT
      AppLogger.success("CompleteuserAccount response: ${response.data}");

      return response.data;
    } catch (e) {
      AppLogger.error("CompleteuserAccount error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> SendOTP({required String userId}) async {
    try {
      final response = await _dio.post(
        "user-account/send-otp",
        data: {"userId": userId},
      );
      return response.data;
    } catch (e) {
      AppLogger.error("SendOTP******** : $e");
    }
  }

  Future<dynamic> Forgetpassword({required String email}) async {
    try {
      final response = await _dio.post(
        "user-account/forgot-password",
        data: {"email": email},
      );

      return response.data;
    } catch (e) {
      if (e is DioException) {
        final msg = e.response?.data?['message'] ?? "Something went wrong";
        throw msg;
      }
      throw "Network error";
    }
  }

  Future<Map<String, dynamic>?> OTPwithphone({
    required String mobileNumber,
    required String fcmToken
  }) async {
    try {
      final response = await _dio.post(
        "user-account/send-signin-otp",
        data: {"mobileNumber": mobileNumber ,"fcmToken":fcmToken},
      );
      return response.data;
    } catch (e) {
      AppLogger.error("OTPwithphone : $e");
    }
  }

  Future<Map<String, dynamic>> OTPphoneverify({
    required String otp,
    required String mobileNumber,
  }) async {
    final response = await _dio.post(
      "user-account/signin-otp",
      data: {"mobileNumber": mobileNumber, "otp": otp},
    );
    // Return backend response as-is
    return response.data;
  }

  //OTP verfiy
  Future<Map<String, dynamic>> OTPverify({
    required String otp,
    required String userId,
  }) async {
    final response = await _dio.post(
      "user-account/verify-otp",
      data: {"userId": userId, "otp": otp},
    );

    // Return backend response as-is
    return response.data;
  }

  //Login
  Future<Map<String, dynamic>?> LoginApi({
    required String email,
    required String password,
    required String fcmToken
  }) async {
    try {
      print(" fcmToken*******77777777777777 $fcmToken");
      final response = await _dio.post(
        "user-account/signin",
        data: {"email": email, "password": password ,fcmToken:"fcmToken"},
      );
      return response.data;
    } on DioException catch (e) {
      AppLogger.error("Login ${e.response?.statusCode}");
      AppLogger.error("Login ${e.response?.data}");
      throw e;
    }
  }
}
