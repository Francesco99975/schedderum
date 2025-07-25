import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/database/database.dart';
import 'package:schedderum/extensions/strings.dart';
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/providers/employees.dart';
import 'package:schedderum/util/snackbar_service.dart';

class FirstUseScreen extends ConsumerStatefulWidget {
  const FirstUseScreen({super.key});
  static const routePath = "/setup";

  @override
  ConsumerState<FirstUseScreen> createState() => _FirstUseScreenState();
}

class _FirstUseScreenState extends ConsumerState<FirstUseScreen> {
  final TextEditingController _departmentNameController =
      TextEditingController();
  final TextEditingController _managerFirstnameController =
      TextEditingController();
  final TextEditingController _managerMiddleController =
      TextEditingController();
  final TextEditingController _managerLastnameController =
      TextEditingController();
  final TextEditingController _managerEmailController = TextEditingController();
  final TextEditingController _managerPhoneController = TextEditingController();
  Color _selectedColor = const Color.fromARGB(255, 4, 139, 163);
  bool loading = false;

  @override
  void dispose() {
    _departmentNameController.dispose();
    _managerFirstnameController.dispose();
    _managerMiddleController.dispose();
    _managerLastnameController.dispose();
    _managerEmailController.dispose();
    _managerPhoneController.dispose();
    super.dispose();
  }

  Future<Either<Failure, void>> _setup() async {
    loading = true;

    final departmentName =
        _departmentNameController.text.trim().toLowerCase().capitalize();
    final managerFirstname =
        _managerFirstnameController.text.trim().toLowerCase().capitalize();
    final managerMiddlename =
        _managerMiddleController.text.trim().toLowerCase().capitalize();
    final managerLastname =
        _managerLastnameController.text.trim().toLowerCase().capitalize();
    final managerEmail = _managerEmailController.text.trim().toLowerCase();
    final managerPhoneRaw = _managerPhoneController.text.trim();

    if (departmentName.isEmpty ||
        managerFirstname.isEmpty ||
        managerLastname.isEmpty ||
        managerEmail.isEmpty ||
        managerPhoneRaw.isEmpty) {
      return Left(Failure(message: 'Please fill out all fields'));
    }

    // Validate Email
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final re = RegExp(emailPattern);
    if (!re.hasMatch(managerEmail)) {
      return Left(Failure(message: 'Please enter a valid email'));
    }

    // Validate Phone
    final digitsOnly = managerPhoneRaw.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length != 10) {
      return Left(Failure(message: 'Please enter a valid phone number'));
    }

    final phonePattern = RegExp(r'^\d{10}$');
    if (!phonePattern.hasMatch(digitsOnly)) {
      return Left(Failure(message: 'Please enter a valid phone number'));
    }

    final area = digitsOnly.substring(0, 3);
    final prefix = digitsOnly.substring(3, 6);
    final line = digitsOnly.substring(6, 10);
    final managerPhone = '($area) $prefix-$line';

    final response = await ref
        .read(departmentsProvider.notifier)
        .addDepartment(Department(id: uuid(), name: departmentName));

    return response.match((l) => Left(l), (department) async {
      final manager = Employee(
        id: uuid(),
        firstname: managerFirstname,
        middlename: managerMiddlename,
        lastname: managerLastname,
        email: managerEmail,
        phone: managerPhone,
        priority: 1000,
        isManager: true,
        color: _selectedColor.toARGB32(),
        departmentId: department.id,
      );

      await ref.read(employeesProvider.notifier).addEmployee(manager);

      await ref
          .read(currentDepartmentProvider.notifier)
          .setCurrent(department.id);

      return Right(null);
    });
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => tempColor = color,
              labelTypes: [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() => _selectedColor = tempColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body:
          loading
              ? SafeArea(
                child: const Center(child: CircularProgressIndicator()),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Column(
                        children: [
                          Image.asset(
                            'assets/icon/icon.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Schedderum',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _buildTextField(
                        'Department Name',
                        _departmentNameController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Manager Firstname',
                        _managerFirstnameController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Manager Middlename',
                        _managerMiddleController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Manager Lastname',
                        _managerLastnameController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Manager Email', _managerEmailController),
                      const SizedBox(height: 16),
                      _buildTextField('Manager Phone', _managerPhoneController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Manager Color:',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _pickColor(context),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black26),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await _setup();
                            result.match(
                              (l) => SnackBarService.showNegativeSnackBar(
                                context: context,
                                message: l.message,
                              ),
                              (r) {},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continue'),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
    );
  }
}
