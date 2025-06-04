import 'package:shared_preferences/shared_preferences.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';

class PreferencesService {
  final SharedPreferences _prefs;
  PreferencesService(this._prefs);

  Either<Failure, String> getString(String key) {
    final value = _prefs.getString(key);
    return value == null
        ? Left(Failure(message: 'No string found for "$key"'))
        : Right(value);
  }

  Future<Either<Failure, Unit>> setString(String key, String value) async {
    final success = await _prefs.setString(key, value);
    return success
        ? Right(unit)
        : Left(Failure(message: 'Failed to set string for "$key"'));
  }

  Either<Failure, bool> getBool(String key) {
    final value = _prefs.getBool(key);
    return value == null
        ? Left(Failure(message: 'No bool found for "$key"'))
        : Right(value);
  }

  Future<Either<Failure, Unit>> setBool(String key, bool value) async {
    final success = await _prefs.setBool(key, value);
    return success
        ? Right(unit)
        : Left(Failure(message: 'Failed to set bool for "$key"'));
  }

  Either<Failure, int> getInt(String key) {
    final value = _prefs.getInt(key);
    return value == null
        ? Left(Failure(message: 'No int found for "$key"'))
        : Right(value);
  }

  Future<Either<Failure, Unit>> setInt(String key, int value) async {
    final success = await _prefs.setInt(key, value);
    return success
        ? Right(unit)
        : Left(Failure(message: 'Failed to set int for "$key"'));
  }

  Either<Failure, double> getDouble(String key) {
    final value = _prefs.getDouble(key);
    return value == null
        ? Left(Failure(message: 'No double found for "$key"'))
        : Right(value);
  }

  Future<Either<Failure, Unit>> setDouble(String key, double value) async {
    final success = await _prefs.setDouble(key, value);
    return success
        ? Right(unit)
        : Left(Failure(message: 'Failed to set double for "$key"'));
  }

  Future<Either<Failure, Unit>> remove(String key) async {
    final success = await _prefs.remove(key);
    return success
        ? Right(unit)
        : Left(Failure(message: 'Failed to remove key "$key"'));
  }
}
