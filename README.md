Smart Expense & Budget Tracker
A Flutter-based mobile application for students to manage expenses, set budgets, track savings goals, and visualize spending habits using SQLite for local storage.
Features

Expense Logging & Categorization: Add expenses with predefined categories.
Budget Setting & Alerts: Set monthly budgets with overspending notifications.
Savings Goals & Reminders: Track goals with scheduled reminders.
Reports & Graphs: Pie chart for spending by category using fl_chart.
Offline Storage: SQLite for local data storage.
Extra Features: Category dropdown, filtering, light/dark theme toggle.
Animations: Fade and size transitions for lists.

Screenshots



Installation

Prerequisites:

Flutter SDK (v3.0+)
Dart SDK
SQLite
Android Studio or VS Code


Flutter App Setup:
flutter create expense_tracker
cd expense_tracker


Update pubspec.yaml with dependencies.
Copy lib/ files from this repository.
Run: flutter run.


APK Generation:
flutter build apk --release


APK located at build/app/outputs/flutter-apk/app-release.apk.



Usage

Home: View budget, recent expenses, and savings goals.
Add Expense: Input expense details with category dropdown.
Budget: Set monthly budget and view history.
Savings Goals: Add goals with reminders.
Reports: Filter and view spending charts.
Toggle theme via AppBar icon.

Project Structure
expense_tracker/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── expense.dart
│   │   ├── budget.dart
│   │   ├── savings_goal.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── offline_storage.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── add_expense_screen.dart
│   │   ├── budget_screen.dart
│   │   ├── savings_goal_screen.dart
│   │   ├── reports_screen.dart
│   ├── widgets/
│   │   ├── expense_tile.dart
│   │   ├── savings_goal_tile.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   ├── utils/
│   │   ├── notifications.dart
├── pubspec.yaml
├── README.md
├── presentation.tex
├── build/app/outputs/flutter-apk/app-release.apk

GitHub Repository

git clone https://github.com/Dujohnson7/Expense_Tracker_Mobile_Final
 
