/// Model statistik di dashboard
class DashboardStats {
  final String title;
  final String value;
  final String sub;
  final double percent;
  final bool isUp;

  DashboardStats({
    required this.title,
    required this.value,
    required this.sub,
    required this.percent,
    required this.isUp,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      title: json['title'] ?? '',
      value: json['value'] ?? '0',
      sub: json['subtitle'] ?? '',
      percent: (json['percentage'] ?? 0).toDouble(),
      isUp: json['isIncrease'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'subtitle': sub,
      'percentage': percent,
      'isIncrease': isUp,
    };
  }
}

/// Model data dashboard
class DashboardData {
  final List<DashboardStats> stats;
  final String userName;
  final DateTime lastUpdate;

  DashboardData({
    required this.stats,
    required this.userName,
    required this.lastUpdate,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats: (json['stats'] as List?)
              ?.map((e) => DashboardStats.fromJson(e))
              .toList() ??
          [],
      userName: json['userName'] ?? 'User',
      lastUpdate: DateTime.parse(
        json['lastUpdate'] ?? DateTime.now().toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.map((e) => e.toJson()).toList(),
      'userName': userName,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  DashboardData copyWith({
    List<DashboardStats>? stats,
    String? userName,
    DateTime? lastUpdate,
  }) {
    return DashboardData(
      stats: stats ?? this.stats,
      userName: userName ?? this.userName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}