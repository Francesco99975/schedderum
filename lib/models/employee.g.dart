// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  id: json['id'] as String,
  firstname: json['firstname'] as String,
  middlename: json['middlename'] as String,
  lastname: json['lastname'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  priority: (json['priority'] as num).toInt(),
  isManager: json['isManager'] as bool,
  color: (json['color'] as num).toInt(),
  records:
      (json['records'] as List<dynamic>)
          .map((e) => Record.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'middlename': instance.middlename,
  'lastname': instance.lastname,
  'email': instance.email,
  'phone': instance.phone,
  'priority': instance.priority,
  'isManager': instance.isManager,
  'color': instance.color,
  'records': instance.records,
};
