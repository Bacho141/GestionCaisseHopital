import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/models/agent/agent.dart';

class Addagent extends StatefulWidget {
  const Addagent({Key? key}) : super(key: key);

  @override
  State<Addagent> createState() => _AddagentState();
}

class _AddagentState extends State<Addagent> {
  final _nomCtrl      = TextEditingController();
  final _prenomCtrl   = TextEditingController();
  final _adresseCtrl  = TextEditingController();
  final _teleCtrl     = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  // Injection du controller
  final AgentController _agentCtrl = Get.put(AgentController());

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _adresseCtrl.dispose();
    _teleCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
  if (_formKey.currentState!.validate()) {
    final agent = Agent(
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      adresse: _adresseCtrl.text.trim(),
      telephone: _teleCtrl.text.trim(),
    );

    // 1) Appelle addAgent et récupère le booléen "success"
    final success = await _agentCtrl.addAgent(agent);

    // 2) Si la création a réussi, on rafraîchit la liste complète
    if (success) {
      // Optionnel : si vous préférez recharger depuis le backend
      // await _agentCtrl.fetchAll();

      // 3) On vide tous les champs
      _formKey.currentState!.reset();
      _nomCtrl.clear();
      _prenomCtrl.clear();
      _adresseCtrl.clear();
      _teleCtrl.clear();

      // 4) On affiche un toast de succès
      Get.snackbar(
        'Succès',
        'Agent enregistré',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      // En cas d'échec de création, on affiche un toast d'erreur
      Get.snackbar(
        'Erreur',
        'Impossible d’enregistrer l’agent',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final width = isMobile
        ? MediaQuery.of(context).size.width - 25
        : (MediaQuery.of(context).size.width - 100) / 2.7;
    final height = isMobile ? 520.0 : 500.0;

    return SizedBox(
      width: width,
      height: height,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 10,
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape:
              NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          color: Colors.white,
          shadowLightColor: Colors.grey.shade200,
          shadowDarkColor: Colors.grey.shade600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 4,
                        intensity: 0.8,
                        shape: NeumorphicShape.flat,
                        boxShape:
                            NeumorphicBoxShape.circle(),
                        color: const Color.fromARGB(
                            152, 121, 23, 232),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Ajouter un Agent",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 30),

                // Nom
                _buildNeumorphicField(
                  controller: _nomCtrl,
                  hintText: 'Nom',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Requis' : null,
                ),
                const SizedBox(height: 12),

                // Prénom
                _buildNeumorphicField(
                  controller: _prenomCtrl,
                  hintText: 'Prénom',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Requis' : null,
                ),
                const SizedBox(height: 12),

                // Adresse
                _buildNeumorphicField(
                  controller: _adresseCtrl,
                  hintText: 'Adresse',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Requis' : null,
                ),
                const SizedBox(height: 12),

                // Téléphone
                _buildNeumorphicField(
                  controller: _teleCtrl,
                  hintText: 'Téléphone',
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Requis' : null,
                ),
                const SizedBox(height: 20),

                // Bouton Enregistrer
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(() {
                    return NeumorphicButton(
                      onPressed: _agentCtrl.isLoading.value
                          ? null
                          : _submit,
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.7,
                        boxShape:
                            NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.send),
                          const SizedBox(width: 8),
                          Text(
                            _agentCtrl.isLoading.value
                                ? 'Enregistrement...'
                                : 'Enregistrer',
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -4,
        intensity: 0.6,
        shape: NeumorphicShape.flat,
        boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Color(0xFF7717E8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
