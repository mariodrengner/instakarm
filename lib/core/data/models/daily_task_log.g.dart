// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_task_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyTaskLogAdapter extends TypeAdapter<DailyTaskLog> {
  @override
  final typeId = 1;

  @override
  DailyTaskLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyTaskLog(
      id: fields[0] as String,
      taskName: fields[1] as String,
      categoryName: fields[2] as String,
      categoryColorHex: fields[3] as String,
      date: fields[4] as DateTime,
      isCompleted: fields[5] == null ? false : fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyTaskLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.categoryColorHex)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTaskLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
