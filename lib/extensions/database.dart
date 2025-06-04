import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/models/department.dart' as model;
import 'package:schedderum/models/employee.dart' as model;
import 'package:schedderum/models/record.dart' as model;

extension DepartmentMapper on db.Department {
  model.Department toModel(List<model.Employee> employees) {
    return model.Department(id: id, name: name, employees: employees);
  }
}

extension EmployeeMapper on db.Employee {
  model.Employee toModel(List<model.Record> records) {
    return model.Employee(
      id: id,
      firstname: firstname,
      middlename: middlename,
      lastname: lastname,
      email: email,
      phone: phone,
      priority: priority,
      isManager: isManager,
      color: color,
      records: records,
    );
  }
}

extension RecordMapper on db.Record {
  model.Record toModel() {
    return model.Record(
      id: id,
      start: start,
      end: end,
      type: model.RecordType.values.firstWhere(
        (element) => element.name == type,
      ),
    );
  }
}
