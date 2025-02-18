import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'favoritePage.dart';


class AddUserForm extends StatefulWidget {
  final Map<String,dynamic>? userData;
  final int? index;

  AddUserForm({Key? key, this.userData,this.index}) : super(key: key);

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _fromKey = GlobalKey();
  List<String> cities = ['Ahmedabad', 'Surat', 'Rajkot', 'Morbi', 'Jamnagar','Gandhianagar','Vadodra','Amreli','Junagadh'];
  String selectedCity = '';
  int selectedGender = 1;
  List<String> selectedHobbies = [];
  Map<String, bool> hobbies = {
    'Reading': false,
    'Traveling': false,
    'Gaming': false,
    'Cooking': false,
  };
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      // Initialize the text controllers with existing data
      fullNameController.text = widget.userData!['fullName'];
      emailController.text = widget.userData!['email'];
      mobileController.text = widget.userData!['number'];
      dobController.text = widget.userData!['dob'];
      selectedCity = widget.userData!['city'];
      selectedGender = widget.userData!['gender'];
      selectedHobbies = widget.userData!['hobbies'];
      hobbies.forEach((key, _) {
        hobbies[key] = selectedHobbies.contains(key);
      });
      selectedHobbies = [];
      passwordController.text = widget.userData!['password'];
      confirmPasswordController.text = widget.userData!['confirmPassword'];
    } else {
      selectedCity = cities[0];
    }
  }
  DateTime? selectedDate;
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
          widget.userData == null ? 'Add User' : 'Edit User',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _fromKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                icon: Icons.person_outline,
                label: 'Full Name',
                controller: fullNameController,
                hint: 'Enter first and last name (e.g., firstname lastname)',
              ),
              SizedBox(height: 16),
              
              _buildInputField(
                icon: Icons.email_outlined,
                label: 'Email',
                controller: emailController,
                hint: 'Enter a valid email address (e.g., name@gmail.com)',
              ),
              SizedBox(height: 16),
              
              _buildInputField(
                icon: Icons.phone_outlined,
                label: 'Mobile Number',
                controller: mobileController,
                hint: 'Enter 10-digit mobile number',
              ),
              SizedBox(height: 16),
              
              _buildInputField(
                icon: Icons.calendar_today_outlined,
                label: 'DOB (DD/MM/YYYY)',
                controller: dobController,
                hint: 'Enter date of birth',
                suffix: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.blue),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      dobController.text = formattedDate;
                    }
                  },
                ),
              ),
              SizedBox(height: 16),

              // City Dropdown
              Text(
                'City:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCity,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                    items: cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value ?? cities[0];
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Gender Selection
              Text(
                'Gender:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      title: Text('Male'),
                      value: 1,
                      groupValue: selectedGender,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      title: Text('Female'),
                      value: 0,
                      groupValue: selectedGender,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Hobbies
              Text(
                'Hobbies:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Wrap(
                spacing: 16,
                children: hobbies.keys.map((hobby) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: hobbies[hobby],
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              hobbies[hobby] = value!;
                            });
                          },
                        ),
                        Text(hobby),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              _buildInputField(
                icon: Icons.lock_outline,
                label: 'Password',
                controller: passwordController,
                isPassword: true,
              ),
              SizedBox(height: 16),

              _buildInputField(
                icon: Icons.lock_outline,
                label: 'Confirm Password',
                controller: confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(height: 32),

              // Submit Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_fromKey.currentState!.validate()) {
                      Navigator.pop(context,true);
                      hobbies.forEach((key, value) {
                        if (value) {
                          selectedHobbies.add(key);
                        }
                      });
                      if(widget.userData == null){
                        myUser.addUserInList(fullName: fullNameController.text, email: emailController.text, number: mobileController.text, dob: dobController.text, city: selectedCity, gender: selectedGender, hobbies: selectedHobbies, password: passwordController.text, confirmPassword: confirmPasswordController.text);
                      }
                      else {
                        myUser.updateUserData(
                            fullName: fullNameController.text,
                            email: emailController.text,
                            number: mobileController.text,
                            dob: dobController.text,
                            city: selectedCity,
                            gender: selectedGender,
                            hobbies: selectedHobbies,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                            id: widget.index!);
                        _fromKey.currentState?.reset();
                      }
                    }
                  },
                  child: Text(
                    widget.userData == null ? 'Add User' : 'Update User',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isPassword = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.blue),
          suffixIcon: suffix ?? (isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}