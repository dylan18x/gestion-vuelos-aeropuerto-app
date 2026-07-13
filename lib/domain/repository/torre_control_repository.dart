<<<<<<< HEAD
class TorreControl {
  final int idTorre;
  final String nombre;
  final String ubicacion;

  const TorreControl({
    required this.idTorre,
    required this.nombre,
    required this.ubicacion,
  });

  factory TorreControl.fromJson(Map<String, dynamic> json) => TorreControl(
    idTorre: json['id_torre'],
    nombre: json['nombre'],
    ubicacion: json['ubicacion'],
  );

  Map<String, dynamic> toJson() => {
    'id_torre': idTorre,
    'nombre': nombre,
    'ubicacion': ubicacion,
  };
=======
import '../model/torre_control.dart';

abstract class TorreControlRepository {
  Future<List<TorreControl>> getAllTorresControl();
  Future<TorreControl> getTorreControlById(int id);
  Future<void> createTorreControl(TorreControl torre);
  Future<void> updateTorreControl(TorreControl torre);
  Future<void> deleteTorreControl(int id);
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
}