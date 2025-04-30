import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  // Set this flag to true if the logged-in user is a doctor.
  final bool isDoctor;
  const ProfileScreen({Key? key, required this.isDoctor}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for common fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  // Controllers for doctor-specific fields
  late TextEditingController _specialtyController;
  late TextEditingController _experienceController;
  late TextEditingController _clinicController;

  // For gender selection.
  String _gender = "Male";

  @override
  void initState() {
    super.initState();
    // Initialize with dummy/default values.
    _nameController = TextEditingController(text: "John Doe");
    _emailController = TextEditingController(text: "john@mail.com");
    _phoneController = TextEditingController(text: "+2519XXXXXXX");
    _ageController = TextEditingController(text: "21");
    _addressController = TextEditingController(text: "Addis Ababa");

    _specialtyController = TextEditingController(text: "Pediatrics");
    _experienceController = TextEditingController(text: "5 Years");
    _clinicController = TextEditingController(text: "ABC Hospital");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _clinicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture with Edit Icon
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage(
                      "assets/images/profile_placeholder.png",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // TODO: Add image picker functionality.
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Additional Info Section
            const Text(
              "Additional Info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Gender Selection using Radio Buttons
            Row(
              children: [
                const Text("Gender: "),
                Radio<String>(
                  value: "Male",
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const Text("Male"),
                Radio<String>(
                  value: "Female",
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const Text("Female"),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Doctor Specific Section
            if (widget.isDoctor) ...[
              const Text(
                "Doctor Specific",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(
                  labelText: "Specialty",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: "Experience",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clinicController,
                decoration: const InputDecoration(
                  labelText: "Clinic",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement file picker to upload CV.
                },
                child: const Text("Upload CV"),
              ),
              const SizedBox(height: 24),
            ],
            // Save Changes Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save changes functionality.
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
