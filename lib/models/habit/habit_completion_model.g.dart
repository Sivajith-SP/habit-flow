// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_completion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitCompletionModelAdapter extends TypeAdapter<HabitCompletionModel> {
  @override
  final int typeId = 2;

  @override
  HabitCompletionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitCompletionModel(
      id: fields[0] as String,
      habitId: fields[1] as String,
      date: fields[2] as DateTime,
      completed: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HabitCompletionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCompletionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
