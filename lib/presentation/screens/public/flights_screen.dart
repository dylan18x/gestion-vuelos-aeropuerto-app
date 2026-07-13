import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../theme/app_colors.dart';
import '../../widgets/custom_bottom_nav.dart';

class FlightsScreen extends StatefulWidget {
  const FlightsScreen({super.key});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  static const String baseUrl =
      "http://cotopaxi-airlines-api.uaeftt-ute.site/api";

  bool isLoading = true;

  List<dynamic> aerolineas = [];
  List<dynamic> aeropuertos = [];
  List<dynamic> escalas = [];
  List<dynamic> horarios = [];

  Map<String, dynamic>? aerolineaSeleccionada;
  Map<String, dynamic>? aeropuertoSeleccionado;
  Map<String, dynamic>? escalaSeleccionada;
  Map<String, dynamic>? horarioSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse("$baseUrl/aerolineas/")),
        http.get(Uri.parse("$baseUrl/aeropuertos/")),
        http.get(Uri.parse("$baseUrl/escalas/")),
        http.get(Uri.parse("$baseUrl/horarios/")),
      ]);

      if (responses.every((r) => r.statusCode == 200)) {
        final aerolineasJson = jsonDecode(responses[0].body);
        final aeropuertosJson = jsonDecode(responses[1].body);
        final escalasJson = jsonDecode(responses[2].body);
        final horariosJson = jsonDecode(responses[3].body);

        setState(() {
          aerolineas = aerolineasJson["results"];
          aeropuertos = aeropuertosJson["results"];
          escalas = escalasJson["results"];
          horarios = horariosJson["results"];
          isLoading = false;
        });
      } else {
        throw Exception("Error cargando datos");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error al cargar información: $e"),
          ),
        );
      }
    }
  }

  String obtenerHorario(Map<String, dynamic> horario) {
    final salida = horario["salida_programada"].toString();
    final llegada = horario["llegada_programada"].toString();

    return "${salida.substring(0, 16).replaceAll("T", "  ")}"
        "  →  "
        "${llegada.substring(0, 16).replaceAll("T", "  ")}";
  }

  void buscarVuelo() {
    if (aerolineaSeleccionada == null ||
        aeropuertoSeleccionado == null ||
        horarioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Seleccione Aerolínea, Aeropuerto y Horario.",
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 10),
            Text("Vuelo disponible"),
          ],
        ),
        content: Text(
          "Aerolínea: ${aerolineaSeleccionada!["nombre"]}\n\n"
          "Aeropuerto: ${aeropuertoSeleccionado!["nombre"]}\n\n"
          "Horario:\n${obtenerHorario(horarioSeleccionado!)}\n\n"
          "${escalaSeleccionada != null ? "Escala: ${escalaSeleccionada!["aeropuerto_escala"]["nombre"]}\n\n" : ""}"
          "¿Desea realizar la reserva?",
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            icon: const Icon(Icons.flight_takeoff),
            label: const Text("Reservar"),
            onPressed: () {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    "Reserva simulada correctamente.",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              color: AppColors.accent,
              size: 20,
            ),
            SizedBox(width: 8),
            Text('Buscar Vuelos'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: AppColors.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.flight,
                          color: AppColors.accent,
                          size: 55,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Center(
                        child: Text(
                          "Consulta disponibilidad de vuelos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// ==========================
                      /// AEROLÍNEA
                      /// ==========================
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: aerolineaSeleccionada,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        elevation: 8,
                        decoration: InputDecoration(
                          labelText: "Aerolínea",
                          prefixIcon: const Icon(Icons.flight),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: aerolineas.map((aerolinea) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: aerolinea,
                            child: Text(aerolinea["nombre"]),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            aerolineaSeleccionada = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      /// ==========================
                      /// AEROPUERTO
                      /// ==========================
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: aeropuertoSeleccionado,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        elevation: 8,
                        decoration: InputDecoration(
                          labelText: "Aeropuerto",
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: aeropuertos.map((aeropuerto) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: aeropuerto,
                            child: Text(
                              "${aeropuerto["nombre"]} (${aeropuerto["codigo_iata"]})",
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            aeropuertoSeleccionado = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                                            /// ==========================
                      /// ESCALA (OPCIONAL)
                      /// ==========================
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: escalaSeleccionada,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        elevation: 8,
                        decoration: InputDecoration(
                          labelText: "Escala (Opcional)",
                          prefixIcon: const Icon(Icons.connecting_airports),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<Map<String, dynamic>>(
                            value: null,
                            child: Text("Sin escala"),
                          ),
                          ...escalas.map((escala) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: escala,
                              child: Text(
                                escala["aeropuerto_escala"]["nombre"],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            escalaSeleccionada = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      /// ==========================
                      /// HORARIO
                      /// ==========================
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: horarioSeleccionado,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        elevation: 8,
                        decoration: InputDecoration(
                          labelText: "Horario",
                          prefixIcon: const Icon(Icons.schedule),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: horarios.map((horario) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: horario,
                            child: Text(
                              obtenerHorario(horario),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            horarioSeleccionado = value;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: buscarVuelo,
                          icon: const Icon(Icons.search),
                          label: const Text(
                            "Buscar vuelo",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 1,
      ),
    );
  }
}