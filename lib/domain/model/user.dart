enum UserRole {
  admin,
  controlador,
  tecnico,
  rrhh,
  operadorVuelo,
  sinRol;

  static UserRole fromBackend({required bool isStaff, String? groupName}) {
    if (isStaff) return UserRole.admin;
    switch (groupName) {
      case 'CONTROLADOR':
        return UserRole.controlador;
      case 'TECNICO':
        return UserRole.tecnico;
      case 'RRHH':
        return UserRole.rrhh;
      case 'OPERADOR_VUELO':
        return UserRole.operadorVuelo;
      default:
        return UserRole.sinRol;
    }
  }

  /// Para persistir en secure storage como string plano
  String toStorageString() => name; // admin, controlador, tecnico, rrhh, operadorVuelo, sinRol

  static UserRole fromStorageString(String? raw) {
    return UserRole.values.firstWhere(
      (r) => r.name == raw,
      orElse: () => UserRole.sinRol,
    );
  }
}

class User {
  final int    id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool   isStaff;
  final bool   isActive;
  final String dateJoined;
  final int    numOrders;
  final String? groupName; // 'CONTROLADOR' | 'TECNICO' | 'RRHH' | 'OPERADOR_VUELO' | null
  final UserRole role;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.numOrders,
    this.groupName,
    this.role = UserRole.sinRol,
  });

  factory User.fromJson(Map<String, dynamic> j) {
    final isStaff = j['is_staff'] as bool? ?? false;
    final group   = j['role'] as String?; // el backend llama a este campo 'role'
    return User(
      id:         j['id']          as int? ?? 0,
      username:   j['username']    as String? ?? '',
      email:      j['email']       as String? ?? '',
      firstName:  j['first_name']  as String? ?? '',
      lastName:   j['last_name']   as String? ?? '',
      isStaff:    isStaff,
      isActive:   j['is_active']   as bool? ?? true,
      dateJoined: j['date_joined'] as String? ?? '',
      numOrders:  j['num_orders']  as int? ?? 0,
      groupName:  group,
      role: UserRole.fromBackend(isStaff: isStaff, groupName: group),
    );
  }

  Map<String, dynamic> toJson() => {
    'username':   username,
    'email':      email,
    'first_name': firstName,
    'last_name':  lastName,
    'is_staff':   isStaff,
    'is_active':  isActive,
  };

  User copyWith({bool? isStaff, bool? isActive}) => User(
    id:         id,
    username:   username,
    email:      email,
    firstName:  firstName,
    lastName:   lastName,
    isStaff:    isStaff  ?? this.isStaff,
    isActive:   isActive ?? this.isActive,
    dateJoined: dateJoined,
    numOrders:  numOrders,
    groupName:  groupName,
    role:       role,
  );
}