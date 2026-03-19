import 'package:flutter/material.dart';
import 'package:riverpod_modul3/core/constants/constants.dart';
import '../../data/models/dosen_model.dart';

class DosenListView extends StatelessWidget {
  final List<DosenModel> dosenList;
  final VoidCallback? onRefresh;
  final bool useModernCard;

  const DosenListView({
    super.key,
    required this.dosenList,
    this.onRefresh,
    this.useModernCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: dosenList.length,
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          final gradientColors = AppConstants.dashboardGradients[
              index % AppConstants.dashboardGradients.length];
          return ModernDosenCard(
            dosen: dosen,
            gradientColors: gradientColors,
          );
        },
      ),
    );
  }
}

class ModernDosenCard extends StatelessWidget {
  final DosenModel dosen;
  final List<Color> gradientColors;

  const ModernDosenCard({
    super.key,
    required this.dosen,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: gradientColors[0].withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  dosen.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dosen.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.account_circle_outlined, '@${dosen.username}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.email_outlined, dosen.email),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.location_on_outlined,
                      '${dosen.address.street}, ${dosen.address.city}'),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: gradientColors[0],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}