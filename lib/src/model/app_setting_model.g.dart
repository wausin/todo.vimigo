// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingModelAdapter extends TypeAdapter<AppSettingModel> {
  @override
  final int typeId = 1;

  @override
  AppSettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingModel(
      isGuidedAdd: fields[1] == null ? false : fields[1] as bool?,
      isGuidedList: fields[0] == null ? false : fields[0] as bool?,
      addInitialData: fields[2] == null ? false : fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isGuidedList)
      ..writeByte(1)
      ..write(obj.isGuidedAdd)
      ..writeByte(2)
      ..write(obj.addInitialData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
