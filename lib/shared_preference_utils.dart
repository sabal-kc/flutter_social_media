import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {

  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future getInstance() async {
    if(_storageUtil==null){

      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;

    }
    return _storageUtil;
  }
  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }
  // put string
  static Future putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }

  static bool getBool(String key, {bool defValue = true}){
    if(_preferences ==null) return defValue;
    return _preferences.getBool(key);
  }
  static Future setBool(String key, bool value){
    if (_preferences == null) return null;
    return _preferences.setBool(key, value);
  }
}