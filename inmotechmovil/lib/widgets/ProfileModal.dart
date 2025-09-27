import 'package:flutter/material.dart';

class ProfileModal extends StatelessWidget {
  final Map<String, dynamic> perfil;
  final List<Map<String, dynamic>> inmuebles;
  final Function(Map<String, dynamic>) onInmuebleTap;

  const ProfileModal({
    Key? key,
    required this.perfil,
    required this.inmuebles,
    required this.onInmuebleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF18181B), // Fondo oscuro
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Perfil"),
                  Tab(text: "Inmueble"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Perfil
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(perfil["avatar"]),
                            radius: 40,
                            backgroundColor: theme.primaryColorDark,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            perfil["nombre"],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            perfil["email"],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            perfil["telefono"],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Lista de inmuebles
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: inmuebles.length,
                      separatorBuilder: (_, __) => Divider(color: Colors.grey[700]),
                      itemBuilder: (context, index) {
                        final inmueble = inmuebles[index];
                        return ListTile(
                          tileColor: Colors.transparent,
                          leading: inmueble["imagenes"] != null && inmueble["imagenes"].isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    inmueble["imagenes"][0],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.home, size: 40, color: Colors.white),
                          title: Text(
                            inmueble["titulo"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            inmueble["direccion"],
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          trailing: Text(
                            inmueble["precio"],
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context); // Cierra el modal de la lista
                            onInmuebleTap(inmueble); // Abre el detalle en un nuevo modal
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}