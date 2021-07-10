import 'dart:convert';
import 'dart:async';
import 'package:employeeapp/helpers/employee_model.dart';
import 'package:http/http.dart' as http;

// Helper class for API call
class ApiHelper {
  final String baseURL = "http://www.mocky.io/v2/5d565297300000680030a986";

  EmployeeDetailsList parseEmployeeDetails(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return EmployeeDetailsList.fromJson(parsed);
  }

  Future<EmployeeDetailsList> fetchEmployeeDetails() async {
    var response = await http.get(Uri.parse(baseURL));
    if (response.statusCode == 200) {
      return parseEmployeeDetails(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Unable to fetch products from the REST API');
    }
  }
}
