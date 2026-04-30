import 'package:firefly/domain/repositories/local_repository.dart';
import 'package:firefly/domain/entities/track.dart';

class ScanLocalMusicUsecase {
  final LocalRepository repository;

  ScanLocalMusicUsecase(this.repository);

  Future<List<Track>> call(String directoryPath) async {
    return await repository.scanDirectory(directoryPath);
  }
}
