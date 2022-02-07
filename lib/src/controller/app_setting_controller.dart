import 'package:hive/hive.dart';
import 'package:todo_vimigo/src/model/app_setting_model.dart';

class AppSettingController {
  static Box<AppSettingModel> getApp() =>
      Hive.box<AppSettingModel>('app_setting_model');
}
