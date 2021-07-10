// Class to perform DB operations

import 'package:employeeapp/helpers/db/app_database.dart';
import 'package:employeeapp/helpers/db/employee_repository.dart';
import 'package:employeeapp/helpers/employee_model.dart';
import 'package:sembast/sembast.dart';

class EmployeeDAO extends EmployeeRepository {
  static const String tableName = "EmployeeDetailsList";
  final _employeeDetailsListFactory = stringMapStoreFactory.store(tableName);

  Future<Database> get _db async => await AppDatabase.instance.database;
  @override
  insert(EmployeeDetailsList list) async {
    if (list.employeeDetails != null) {
      Map<String, dynamic> map = list.toJson();
      String key = map['itemKey'];
      await _employeeDetailsListFactory
          .record(key)
          .put(await _db, map, merge: true);
    }
  }

  @override
  Future<List<EmployeeDetailsList>> getAllRecords() async {
    final recordSnapshot = await _employeeDetailsListFactory.find(await _db);
    return recordSnapshot.map(
      (snapshot) {
        final item = EmployeeDetailsList.fromMap(snapshot.value);
        return item;
      },
    ).toList();
  }
}
