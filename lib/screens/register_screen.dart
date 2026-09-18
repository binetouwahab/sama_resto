import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'client';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0202D),
        title: const Text('Inscription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(hint: 'Prénom', icon: Icons.person_outline, controller: _prenomCtrl),
            CustomTextField(hint: 'Nom', icon: Icons.person_outline, controller: _nomCtrl),
            CustomTextField(hint: 'Email', icon: Icons.email_outlined, controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
            CustomTextField(hint: 'Téléphone', icon: Icons.phone_outlined, controller: _telCtrl, keyboardType: TextInputType.phone),
            CustomTextField(hint: 'Mot de passe', icon: Icons.lock_outline, controller: _passCtrl, obscure: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Radio<String>(value: 'client', groupValue: _role, onChanged: (v) => setState(() => _role = v!)),
                const Text('Client'),
                const SizedBox(width: 16),
                Radio<String>(value: 'vendeur', groupValue: _role, onChanged: (v) => setState(() => _role = v!)),
                const Text('Vendeur'),
              ],
            ),
            const SizedBox(height: 12),
            if (auth.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(auth.errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            CustomButton(
              text: "S'inscrire",
              loading: auth.isLoading,
              onPressed: () async {
                final ok = await auth.register(
                  prenom: _prenomCtrl.text.trim(),
                  nom: _nomCtrl.text.trim(),
                  email: _emailCtrl.text.trim(),
                  telephone: _telCtrl.text.trim(),
                  password: _passCtrl.text.trim(),
                  role: _role,
                );
                if (ok && context.mounted) {
                  Navigator.pushReplacementNamed(context, '/catalog');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}