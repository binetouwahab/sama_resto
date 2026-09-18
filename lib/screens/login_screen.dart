import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFC0202D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Icon(Icons.restaurant, color: Colors.white, size: 40),
            const Text('SAMA Resto',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Connexion',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextField(
                        hint: 'Mot de passe',
                        icon: Icons.lock_outline,
                        controller: _passCtrl,
                        obscure: true,
                      ),
                      const SizedBox(height: 4),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('Mot de passe oublié ?', style: TextStyle(color: Color(0xFFC0202D))),
                      ),
                      const SizedBox(height: 16),
                      if (auth.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(auth.errorMessage!, style: const TextStyle(color: Colors.red)),
                        ),
                      CustomButton(
                        text: 'Se connecter',
                        loading: auth.isLoading,
                        onPressed: () async {
                          final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
                          if (ok && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/catalog');
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Pas de compte ? "),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/register'),
                            child: const Text('S\'inscrire',
                                style: TextStyle(color: Color(0xFFC0202D), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(children: [
                        Expanded(child: Divider()),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('ou')),
                        Expanded(child: Divider()),
                      ]),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final ok = await auth.loginWithGoogle();
                          if (ok && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/catalog');
                          }
                        },
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text('Se connecter avec Google'),
                        style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}