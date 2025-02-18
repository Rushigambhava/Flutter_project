// UserListPage.dart
import 'package:flutter/material.dart';
import 'package:mdb/Pages/user_Detail.dart';
import 'add_user.dart';
import 'userData.dart';

final User myUser = User.instance;
dynamic users = myUser.getUserList();

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    users = myUser.getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'User List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, city, gender...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              users = myUser.getUserList();
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    users = myUser.searchDeatail(searchData: value);
                  });
                },
              ),
            ),
          ),

          // User List
          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Text(
                      searchController.text.isNotEmpty
                          ? "No users found!"
                          : "No users added yet!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final firstLetter = user['fullName'][0].toUpperCase();

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedUser(index: index),
                              ),
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  users = myUser.getUserList();
                                });
                              }
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: Text(
                              firstLetter,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user['fullName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['email']),
                              Row(
                                children: [
                                  Icon(Icons.location_on, 
                                      size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(user['city']),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddUserForm(
                                        userData: user,
                                        index: index,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      users = myUser.getUserList();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  user['isLiked'] 
                                      ? Icons.favorite 
                                      : Icons.favorite_border,
                                  color: user['isLiked'] 
                                      ? Colors.red 
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    myUser.toggleFavorite(index);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (dialogContext) =>
                                        AlertDialog(
                                      title: const Text(
                                          'Delete User'),
                                      content: const Text(
                                          'Are you sure you want to delete this user?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                dialogContext);
                                          },
                                          child: const Text(
                                              'Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              myUser.deleteUser(
                                                  index);
                                              Navigator.pop(
                                                  dialogContext);
                                              setState(() {
                                                users = myUser
                                                    .getUserList();
                                              });
                                              if (!context.mounted)
                                                return;
                                              ScaffoldMessenger
                                                      .of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'User deleted successfully'),
                                                  duration:
                                                      Duration(
                                                          seconds:
                                                              2),
                                                ),
                                              );
                                            } catch (e) {
                                              Navigator.pop(
                                                  dialogContext);
                                              ScaffoldMessenger
                                                      .of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error deleting user: $e'),
                                                  backgroundColor:
                                                      Colors.red,
                                                  duration:
                                                      Duration(
                                                          seconds:
                                                              2),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors
                                                      .red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
