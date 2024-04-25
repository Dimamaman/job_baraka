// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_services_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetAllServicesResponseAdapter
    extends TypeAdapter<GetAllServicesResponse> {
  @override
  final int typeId = 0;

  @override
  GetAllServicesResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetAllServicesResponse(
      data: (fields[0] as List).cast<ServiceData>(),
    );
  }

  @override
  void write(BinaryWriter writer, GetAllServicesResponse obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAllServicesResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceDataAdapter extends TypeAdapter<ServiceData> {
  @override
  final int typeId = 1;

  @override
  ServiceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceData(
      id: fields[0] as int,
      categoryName: fields[1] as Name,
      services: (fields[2] as List).cast<Service>(),
      isOpen: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryName)
      ..writeByte(2)
      ..write(obj.services)
      ..writeByte(3)
      ..write(obj.isOpen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NameAdapter extends TypeAdapter<Name> {
  @override
  final int typeId = 2;

  @override
  Name read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Name(
      kar: fields[0] as String,
      uzKiril: fields[1] as String,
      uzLatin: fields[2] as String,
      ru: fields[3] as String,
      en: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Name obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.kar)
      ..writeByte(1)
      ..write(obj.uzKiril)
      ..writeByte(2)
      ..write(obj.uzLatin)
      ..writeByte(3)
      ..write(obj.ru)
      ..writeByte(4)
      ..write(obj.en);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 3;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      id: fields[0] as int,
      categoryId: fields[1] as String,
      name: fields[2] as Name,
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
