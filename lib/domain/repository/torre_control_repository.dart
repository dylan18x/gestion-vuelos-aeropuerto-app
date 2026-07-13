import '../model/torre_control.dart';

abstract class TorreControlRepository {
  Future<List<TorreControl>> getAllTorresControl();
  Future<TorreControl> getTorreControlById(int id);
  Future<void> createTorreControl(TorreControl torre);
  Future<void> updateTorreControl(TorreControl torre);
  Future<void> deleteTorreControl(int id);
}