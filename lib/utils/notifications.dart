import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showBudgetNotification(double totalSpent, double budget) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'budget_channel',
      'Budget Alerts',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'Budget Exceeded',
    'You have spent \$${totalSpent.toStringAsFixed(2)}, exceeding your budget of \$${budget.toStringAsFixed(2)}!',
    notificationDetails,
  );
}

Future<void> showSavingsGoalReminder(int id, String goalName, double goalAmount, double currentAmount) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminder_channel',
      'Savings Goal Reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );
  await flutterLocalNotificationsPlugin.show(
    id,
    'Savings Goal Reminder',
    'Check your progress on $goalName! Goal: \$${goalAmount.toStringAsFixed(2)}, Current: \$${currentAmount.toStringAsFixed(2)}',
    notificationDetails,
  );
}