import 'package:flutter/material.dart';

class UpdateUserInfo extends StatefulWidget {
  final Map<String, dynamic> user;
  final int index;
  final Function(int, Map<String, dynamic>) onUpdate;

  UpdateUserInfo({required this.user, required this.index, required this.onUpdate});

  @override
  _UpdateUserInfoState createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController dateController;
  DateTime? dob;
  String? selectedCity;
  int? age;

  final List<String> cities = ['Rajkot', 'Morbi', 'Vadodara', 'Ahmedabad'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['fullName'] ?? '');
    emailController = TextEditingController(text: widget.user['email'] ?? '');
    mobileController = TextEditingController(text: widget.user['mobileNumber'] ?? '');
    selectedCity = widget.user['city'];

    dob = widget.user['dateOfBirth'] != null
        ? DateTime.tryParse(widget.user['dateOfBirth'])
        : null;

    age = widget.user['age'];

    if (dob != null) {
      dateController = TextEditingController(
        text: "${dob!.year}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
      );
    } else {
      dateController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void updateUser() {
    Map<String, dynamic> updatedUser = {
      'fullName': nameController.text,
      'email': emailController.text,
      'mobileNumber': mobileController.text,
      'city': selectedCity,
      'dateOfBirth': dateController.text,
      'age': age,
    };

    widget.onUpdate(widget.index, updatedUser);
    Navigator.pop(context); // Return to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update User Information")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),

            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),

            // Mobile Number
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),

            // City
            DropdownButtonFormField<String>(
              value: selectedCity,
              hint: Text('Select City'),
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCity = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),

            // Date Of Birth
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Date Of Birth', border: OutlineInputBorder()),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dob ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    dob = pickedDate;
                    dateController.text =
                    "${dob!.year}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}";
                    age = DateTime.now().year - dob!.year;
                  });
                }
              },
            ),
            SizedBox(height: 20),

            // Buttons
            ElevatedButton(
              onPressed: updateUser,
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
