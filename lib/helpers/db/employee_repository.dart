import 'package:employeeapp/helpers/employee_model.dart';

// Repository for insert and fetch data
abstract class EmployeeRepository {
  insert(EmployeeDetailsList employeesList);

  Future<List<EmployeeDetailsList>> getAllRecords();
}
