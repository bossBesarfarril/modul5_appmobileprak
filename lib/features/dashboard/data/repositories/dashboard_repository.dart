import '../models/dashboard_model.dart';

class DashboardRepository {
  /// Mendapatkan data dashboard
  Future<DashboardData> getDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));

    return DashboardData(
      userName: 'Admin D4TI',
      lastUpdate: DateTime.now(),
      stats: [
        DashboardStats(
          title: 'Total Mahasiswa',
          value: '1,234',
          sub: 'Mahasiswa terdaftar',      // ganti dari subtitle
          percent: 8.5,                    // ganti dari percentage
          isUp: true,                      // ganti dari isIncrease
        ),
        DashboardStats(
          title: 'Mahasiswa Aktif',
          value: '1,180',
          sub: 'Sedang kuliah',
          percent: 5.2,
          isUp: true,
        ),
        DashboardStats(
          title: 'Jumlah Kelas',
          value: '48',
          sub: 'Kelas semester ini',
          percent: 2.1,
          isUp: false,
        ),
        DashboardStats(
          title: 'Tingkat Kelulusan',
          value: '94%',
          sub: 'Tahun ini',
          percent: 3.5,
          isUp: true,
        ),
      ],
    );
  }

  /// Refresh dashboard data
  Future<DashboardData> refreshDashboard() async {
    return getDashboardData();
  }

  /// Get specific stat by title
  Future<DashboardStats?> getStatByTitle(String title) async {
    final data = await getDashboardData();
    try {
      return data.stats.firstWhere((stat) => stat.title == title);
    } catch (e) {
      return null;
    }
  }
}