import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:win_app_fyp/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  AuthService._privateConstructor();

  static final AuthService _instance = AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  // Future<Map<String, dynamic>> signUp(
  //     String fname, lname, String email, String password) async {
  //   final url = Uri.parse('$baseUrl/api/v1/auth/register');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({
  //     'firstname': fname,
  //     'lastname': lname,
  //     'email': email,
  //     'password': password
  //   });

  //   final response = await http.post(url, headers: headers, body: body);
  //   final Map<String, dynamic> responseData = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     return responseData;
  //   } else {
  //     throw Exception('Failed to signup: ${response.statusCode}');
  //   }
  // }

  Future<void> setUserInformationFromToken(String token) async {
    try {
      // Decode the JWT token
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

      // Extract user information from the decoded token
      String userId = decodedToken['userId'];
      String firstName = decodedToken['firstName'];
      String lastName = decodedToken['lastName'];
      String email = decodedToken['email'];
      String userRole = decodedToken['userRole'];

      // Store user information in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('firstName', firstName);
      await prefs.setString('lastName', lastName);
      await prefs.setString('email', email);
      await prefs.setString('userRole', userRole);
    } catch (e) {
      throw Exception('Failed to set user information from token: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'email': email, 'password': password});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final token = responseData['token'];
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await setUserInformationFromToken(token);
        } catch (e) {
          throw Exception('Error getting shared preferences: $e');
        }

        return responseData;
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> updateWorkStatus(String email, String newWorkStatus) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/update-work-status');
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'email': email,
        'newWorkStatus': newWorkStatus,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Work status updated successfully
      } else {
        throw Exception('Failed to update work status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update work status: $e');
    }
  }

  Future<List<String>> getUserMentalHealth(String email) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/by-email/$email');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final recommendations =
            userData['mentalHealthStatus']['recommendations'].cast<String>();

        return recommendations;
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  Future<String> getMentalStatus(String email) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/by-email/$email');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final prediction = userData['mentalHealthStatus']['prediction'];

        final prefs = await SharedPreferences.getInstance();

        final mentalHealthStatus = userData['mentalHealthStatus'];
        await prefs.setString('healthStatus', mentalHealthStatus['prediction']);
        return prediction;
      } else {
        throw Exception(
            'Failed to fetch healthStatus data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch healthStatus data: $e');
    }
  }

  Future<String> getWorkLoad(String email) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/by-email/$email');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final workLoad = userData['workLoad'];

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('workLoad', workLoad);
        return workLoad;
      } else {
        throw Exception(
            'Failed to fetch workLoad data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch workLoad data: $e');
    }
  }

  Future<String> submitSurvey({
    email,
    workload,
    workLifeBalance,
    jobSatisfaction,
    interpersonalRelationships,
    jobSecurity,
    recognitionAndAppreciation,
    copingMechanisms,
    physicalSymptoms,
    mentalFatigue,
    jobFuture,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/take-survey');

    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "email": email,
      "Workload": workload,
      "Work-life Balance": workLifeBalance,
      "Job Satisfaction": jobSatisfaction,
      "Interpersonal Relationships": interpersonalRelationships,
      "Job Security": jobSecurity,
      "Recognition and Appreciation": recognitionAndAppreciation,
      "Coping Mechanisms": copingMechanisms,
      "Physical Symptoms": physicalSymptoms,
      "Mental Fatigue": mentalFatigue,
      "Job Future": jobFuture,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to submit survey: ${response.statusCode}');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userRole');
      await prefs.remove('firstName');
      await prefs.remove('lastName');
      await prefs.remove('email');
    } catch (e) {
      throw Exception('Error removing shared preferences: $e');
    }

    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<String> getTokenFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      return token ?? ''; // return an empty string if token is null
    } catch (e) {
      throw Exception('Error while getting token: $e');
    }
  }

  Future<String> getUserRoleFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? role = prefs.getString('userRole');
      return role ?? ''; // return an empty string if token is null
    } catch (e) {
      throw Exception('Error while getting user role: $e');
    }
  }

  Future<String> getUserNameFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? name = prefs.getString('firstName');
      return name ?? ''; // return an empty string if token is null
    } catch (e) {
      throw Exception('Error while getting user name: $e');
    }
  }

  Future<String> getUserEmailFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('email');
      return email ?? ''; // return an empty string if token is null
    } catch (e) {
      throw Exception('Error while getting user email: $e');
    }
  }

  Future<String> getUserHealthStatusFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? healthStatus = prefs.getString('healthStatus');
      return healthStatus ?? ''; // return an empty string if token is null
    } catch (e) {
      throw Exception('Error while getting user health status: $e');
    }
  }

  Future<bool> isTokenExpired() async {
    try {
      final token = await getTokenFromPrefs();
      if (token != null && token.isNotEmpty) {
        bool exp = Jwt.isExpired(token);
        return exp;
      }
    } catch (e) {
      throw Exception('Error while checking token expiration: $e');
    }
    return true; // default to true if token is null or empty
  }

  Future<bool> isAdmin() async {
    try {
      final role = await getUserRoleFromPrefs();
      if (role.isNotEmpty) {
        if (role == 'admin') {
          return true;
        }
        return false;
      }
    } catch (e) {
      throw Exception('Error while checking is admin: $e');
    }
    return false;
  }

  Future<String> getUserName() async {
    try {
      final name = await getUserNameFromPrefs();
      if (name != null && name.isNotEmpty) {
        return name;
      }
      return '';
    } catch (e) {
      throw Exception('Error while getting user name: $e');
    }
  }

  Future<String> getUserEmail() async {
    try {
      final email = await getUserEmailFromPrefs();
      if (email != null && email.isNotEmpty) {
        return email;
      }
      return '';
    } catch (e) {
      throw Exception('Error while getting user name: $e');
    }
  }

  Future<String> getUserhealthStatus() async {
    try {
      final healthStatus = await getUserHealthStatusFromPrefs();
      if (healthStatus != null && healthStatus.isNotEmpty) {
        return healthStatus;
      }
      return '';
    } catch (e) {
      throw Exception('Error while getting user health status: $e');
    }
  }
}
