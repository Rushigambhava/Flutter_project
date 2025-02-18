import '../database/database_helper.dart';

class User {
  static final User _instance = User._internal();
  static User get instance => _instance;
  User._internal();

  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _userList = [];
  List<Map<String, dynamic>> _favoriteUsers = [];

  Future<void> loadUsers() async {
    _userList = await _db.getAllUsers();
    _favoriteUsers = await _db.getFavoriteUsers();
  }

  List<Map<String, dynamic>> getUserList() => _userList;
  List<Map<String, dynamic>> getFavoriteUsers() => _favoriteUsers;

  Future<void> addUserInList({
    required String fullName,
    required String email,
    required String number,
    required String dob,
    required String city,
    required int gender,
    required List<String> hobbies,
    required String password,
    required String confirmPassword,
  }) async {
    final user = {
      'fullName': fullName,
      'email': email,
      'number': number,
      'dob': dob,
      'city': city,
      'gender': gender,
      'hobbies': hobbies,
      'password': password,
      'confirmPassword': confirmPassword,
      'isLiked': false,
    };

    final id = await _db.insertUser(user);
    user['id'] = id;
    _userList.add(user);
  }

  Future<void> updateUserData({
    required String fullName,
    required String email,
    required String number,
    required String dob,
    required String city,
    required int gender,
    required List<String> hobbies,
    required String password,
    required String confirmPassword,
    required int id,
  }) async {
    final user = {
      'id': id,
      'fullName': fullName,
      'email': email,
      'number': number,
      'dob': dob,
      'city': city,
      'gender': gender,
      'hobbies': hobbies,
      'password': password,
      'confirmPassword': confirmPassword,
      'isLiked': _userList[id]['isLiked'],
    };

    await _db.updateUser(user);
    _userList[id] = user;
    
    if (user['isLiked']) {
      final favoriteIndex = _favoriteUsers.indexWhere((u) => u['id'] == id);
      if (favoriteIndex != -1) {
        _favoriteUsers[favoriteIndex] = user;
      }
    }
  }

  Future<void> toggleFavorite(int index) async {
    final user = _userList[index];
    final isLiked = !(user['isLiked'] as bool);
    
    await _db.toggleFavorite(user['id'], isLiked);
    user['isLiked'] = isLiked;

    if (isLiked) {
      _favoriteUsers.add(user);
    } else {
      _favoriteUsers.removeWhere((u) => u['id'] == user['id']);
    }
  }

  Future<void> deleteUser(int index) async {
    final user = _userList[index];
    await _db.deleteUser(user['id']);
    _userList.removeAt(index);
    _favoriteUsers.removeWhere((u) => u['id'] == user['id']);
  }

  Future<List<Map<String, dynamic>>> searchDeatail({String? searchData}) async {
    if (searchData == null || searchData.isEmpty) {
      return _userList;
    }
    return await _db.searchUsers(searchData);
  }
}
