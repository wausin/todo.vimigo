import 'package:hive/hive.dart';

part 'app_setting_model.g.dart';

@HiveType(typeId: 1)
class AppSettingModel extends HiveObject {
  @HiveField(0, defaultValue: false)
  bool? isGuidedList;

  @HiveField(1, defaultValue: false)
  bool? isGuidedAdd;

  @HiveField(2, defaultValue: false)
  bool? addInitialData;

  AppSettingModel(
      {this.isGuidedAdd = false,
      this.isGuidedList = false,
      this.addInitialData = false});
}
