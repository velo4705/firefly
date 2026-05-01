// Generated file for TrackModel Hive adapter
part of 'track_model.dart';

class TrackModelAdapter extends TypeAdapter<TrackModel> {
  @override
  final int typeId = 0;

  @override
  TrackModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackModel(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      album: fields[3] as String,
      filePath: fields[4] as String,
      duration: fields[5] as int,
      fileSize: fields[6] as int,
      createdAt: fields[7] as DateTime,
      genre: fields[8] as String,
      bitrate: fields[9] as int,
      sampleRate: fields[10] as int,
      channels: fields[11] as int,
      playCount: fields[12] as int? ?? 0,
      lastPlayed: fields[13] as DateTime?,
      isFavorite: fields[14] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, TrackModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.album)
      ..writeByte(4)
      ..write(obj.filePath)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.fileSize)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.genre)
      ..writeByte(9)
      ..write(obj.bitrate)
      ..writeByte(10)
      ..write(obj.sampleRate)
      ..writeByte(11)
      ..write(obj.channels)
      ..writeByte(12)
      ..write(obj.playCount)
      ..writeByte(13)
      ..write(obj.lastPlayed)
      ..writeByte(14)
      ..write(obj.isFavorite);
  }
}

