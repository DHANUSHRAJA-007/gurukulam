import 'package:gurukulam/models/signup_model.dart';
import 'package:gurukulam/services/signup_service.dart';

class SignUpRepository {
  final SignUpService _service;

  SignUpRepository({SignUpService? service})
      : _service = service ?? SignUpService();

  Future<Map<String, dynamic>> getIndustryAndLoc() async {
    try {
      // Use correct table names from your database
      final industries = await _service.getMasters('industry_master');
      final locations = await _service.getMasters('location_master');

      print('Industries from API: ${industries.length}');
      print('Locations from API: ${locations.length}');

      return {
        'industries': industries,
        'locations': locations,
      };
    } catch (e) {
      print('Error loading data: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<SignUpResponseModel> signUp({
    required String name,
    required String mobile,
    required String email,
    required String password,
    int? industryId,
    int? locationId,
  }) async {
    try {
      final response = await _service.signUp(
        name: name,
        mobile: mobile,
        email: email,
        password: password,
        industryId: industryId,
        locationId: locationId,
      );

      return SignUpResponseModel.fromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}