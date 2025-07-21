// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardModelAdapter extends TypeAdapter<CardModel> {
  @override
  final int typeId = 0;

  @override
  CardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardModel(
      id: fields[0] as int,
      cardNumber: fields[1] as String,
      serialNumber: fields[2] as String?,
      qrCodeImageUrl: fields[3] as String?,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
      goldCardId: fields[6] as int?,
      statistics: fields[7] as CardStatistics,
      recentSales: (fields[8] as List).cast<CardSale>(),
      walletBalance: fields[9] as double?,
      silverCardsCount: fields[10] as int?,
      cardType: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.serialNumber)
      ..writeByte(3)
      ..write(obj.qrCodeImageUrl)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.goldCardId)
      ..writeByte(7)
      ..write(obj.statistics)
      ..writeByte(8)
      ..write(obj.recentSales)
      ..writeByte(9)
      ..write(obj.walletBalance)
      ..writeByte(10)
      ..write(obj.silverCardsCount)
      ..writeByte(11)
      ..write(obj.cardType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserCardResponseAdapter extends TypeAdapter<UserCardResponse> {
  @override
  final int typeId = 1;

  @override
  UserCardResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCardResponse(
      card: fields[0] as CardModel,
    );
  }

  @override
  void write(BinaryWriter writer, UserCardResponse obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.card);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCardResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
