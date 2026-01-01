# Quick Start Guide

## Running the App

The app is currently running! You can access it at:
**http://localhost:8080**

## Quick Commands

### Stop the app
```bash
# Press 'q' in the terminal where Flutter is running
```

### Restart the app
```bash
flutter run -d chrome --web-port=8080
```

### Run on iOS Simulator
```bash
flutter run -d iPhone
```

### Run on Android Emulator
```bash
flutter run -d android
```

## Testing the App

### 1. Add a Task
- Click the "Add Task" floating button (bottom right)
- Enter a title (required)
- Enter a description (optional)
- Click "Add Task"

### 2. Complete a Task
- Click the checkbox on any task
- Watch it turn green with a gradient!

### 3. Edit a Task
- Tap on any task card
- Modify the title or description
- Click "Update Task"

### 4. Delete a Task
- Swipe a task card from right to left
- The task will be deleted

### 5. Search Tasks
- Use the search bar at the top
- Type to filter tasks in real-time

### 6. Toggle Theme
- Click the sun/moon icon in the app bar
- Switch between dark and light mode

### 7. Sync with Server
- Click the sync icon in the app bar
- Tasks will be fetched from the API

### 8. Test Offline Mode
- Turn off your internet connection
- Add/edit/delete tasks (they still work!)
- Turn internet back on
- Tasks will auto-sync

## Features to Explore

✨ **Beautiful UI**: Notice the gradients, shadows, and animations
🌓 **Dark Mode**: Toggle between themes
🔄 **Pull to Refresh**: Pull down on the task list
📊 **Tabs**: Switch between All, Pending, and Completed
🔍 **Search**: Find tasks quickly
📱 **Responsive**: Resize the browser window
💫 **Animations**: Smooth transitions everywhere
☁️ **Offline Support**: Works without internet
🔔 **Status Indicators**: See sync status and connectivity

## Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

### Hot reload not working?
Press 'r' in the terminal or save a file in your IDE

### Want to see the code?
Check the `lib/` folder for all source code

## Project Structure

```
lib/
├── core/
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── services/        # Business logic
│   └── theme/          # App theme
└── presentation/
    ├── screens/        # App screens
    └── widgets/        # Reusable widgets
```

Enjoy exploring the Smart Task Manager! 🚀
