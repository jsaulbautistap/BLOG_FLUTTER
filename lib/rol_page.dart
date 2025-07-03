import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RolPage extends StatefulWidget {
  final VoidCallback? onRoleAssigned;
  const RolPage({super.key, this.onRoleAssigned});

  @override
  State<RolPage> createState() => _RolPageState();
}

class _RolPageState extends State<RolPage> {
  final supabase = Supabase.instance.client;
  String? selectedRole;

  Future<void> saveRole() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null || selectedRole == null) return;

    try {
      await supabase.from('perfiles').upsert({
        'id': userId,
        'rol': selectedRole,
      });

      // Notificamos a AuthGate que rol fue asignado
      if (widget.onRoleAssigned != null) {
        widget.onRoleAssigned!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar rol: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu rol')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('¿Cómo deseas usar la app?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'visitante', child: Text('Visitante')),
                DropdownMenuItem(value: 'publicador', child: Text('Publicador')),
              ],
              value: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveRole,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
