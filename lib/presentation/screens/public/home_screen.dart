import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_bottom_nav.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    final destinations = <_DestinationItem>[
      _DestinationItem(
        ciudad: 'Quito',
        precio: '\$120',
        imagePath: 'assets/imagenes/Quito.jpg',
      ),
      _DestinationItem(
        ciudad: 'Guayaquil',
        precio: '\$95',
        imagePath: 'assets/imagenes/Guayaquil.jpg',
      ),
      _DestinationItem(
        ciudad: 'Cuenca',
        precio: '\$110',
        imagePath: 'assets/imagenes/cuenca.jpg',
      ),
      _DestinationItem(
        ciudad: 'Esmeraldas',
        precio: '\$80',
        imagePath: 'assets/imagenes/esmeraldas.jpg',
      ),
      _DestinationItem(
        ciudad: 'Lago Agrio',
        precio: '\$100',
        imagePath: 'assets/imagenes/lago.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              color: AppColors.accent,
            ),
            SizedBox(width: 10),
            Text(
              'Cotopaxi Airlines',
              style: TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          if (auth.isAuthenticated)
            IconButton(
              icon: const Icon(
                Icons.dashboard_rounded,
                color: AppColors.accent,
              ),
              onPressed: () => context.go('/dashboard'),
            )
          else
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Ingresar'),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner principal
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/imagenes/lateral.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: Colors.blueGrey,
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.black.withOpacity(0.30),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 35,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Text(
                            'Bienvenido',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 320,
                            child: Text(
                              'Viaja por Ecuador con seguridad, puntualidad y tecnología.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Destinos destacados

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Destinos destacados',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: destinations.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final destination = destinations[index];

                    return _DestinationCard(
                      ciudad: destination.ciudad,
                      precio: destination.precio,
                      imagePath: destination.imagePath,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 0,
      ),
    );
  }
}

class _DestinationItem {
  const _DestinationItem({
    required this.ciudad,
    required this.precio,
    required this.imagePath,
  });

  final String ciudad;
  final String precio;
  final String imagePath;
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.ciudad,
    required this.precio,
    required this.imagePath,
  });

  final String ciudad;
  final String precio;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Vuelos desde',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  precio,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ciudad,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
