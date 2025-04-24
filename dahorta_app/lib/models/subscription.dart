class SubscriptionPlan {
  final String name;
  final String description;
  final double price;

  SubscriptionPlan({
    required this.name,
    required this.description,
    required this.price,
  });
}

class Subscription {
  final String planName;
  final bool active;
  final String plan;
  final String status;
  final DateTime nextBillingDate;

  Subscription({
    required this.planName,
    required this.active,
    required this.plan,
    required this.status,
    required this.nextBillingDate,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      planName: json['plan_name'] ?? 'Desconhecido',
      active: json['active'] ?? false,
      plan: json['plan'],
      status: json['status'],
      nextBillingDate: DateTime.parse(json['next_billing_date']),
    );
  }
}
