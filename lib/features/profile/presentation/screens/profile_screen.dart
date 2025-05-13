import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/user.dart';
import '../../../auth/Presentation/provider/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isDoctor;
  const ProfileScreen({Key? key, required this.isDoctor}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Controllers for common fields.
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;
  late final TextEditingController _addressController;
  // Controllers for doctor-specific fields.
  late final TextEditingController _specialtyController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _biographyController;

  // For gender selection.
  String _gender = "Male";
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
    _addressController = TextEditingController();
    _specialtyController = TextEditingController();
    _qualificationController = TextEditingController();
    _biographyController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _specialtyController.dispose();
    _qualificationController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  /// Initialize controllers with data from the fetched user.
  /// This method is called only once when the data is ready.
  void _initializeControllers(User user) {
    if (!_controllersInitialized) {
      _nameController.text = "${user.firstName} ${user.lastName}";
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      final age = DateTime.now().year - user.dateOfBirth.year;
      _ageController.text = '$age';
      _addressController.text = user.address;
      _gender = user.gender.toString().split('.').last; // e.g., "Male" or "Female"
      if (widget.isDoctor) {
        // For demonstration purposes; adjust these as needed,
        // possibly fetching from an associated Doctor model.
        _specialtyController.text = "Pediatrics";
        _qualificationController.text = "5 Years";
        _biographyController.text = "ABC Hospital";
      }
      _controllersInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile Screen"),
            ),
            body: const Center(
              child: Text("User not found"),
            ),
          );
        }
        // Populate text controllers with user data.
        _initializeControllers(user);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile Screen"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture with Edit Icon.
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.profilePicture != null &&
                            user.profilePicture!.isNotEmpty
                            ? NetworkImage(user.profilePicture!)
                            : const AssetImage("assets/images/profile_placeholder.png")
                        as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            // TODO: Add image picker functionality.
                          },
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: Icon(
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
                // Name Field.
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field.
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                // Additional Info Section.
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
                // Gender Selection using Radio Buttons.
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
                // Doctor Specific Section.
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
                    controller: _qualificationController,
                    decoration: const InputDecoration(
                      labelText: "Qualification",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _biographyController,
                    decoration: const InputDecoration(
                      labelText: "Bio",
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
                // Save Changes Button.
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
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text("Error: ${error.toString()}")),
      ),
    );
  }
}
