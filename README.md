# Smart Task Manager

A Flutter task management app built with an **offline-first approach**, automatic sync, and a clean modern UI. Built to actually be usable, not just a demo.

## Features

### Core
- Create, update, delete, and view tasks  
- Full offline support using Hive  
- Automatic sync when internet returns  
- Search with debounce  
- Filter by **All / Pending / Completed**  
- Pull-to-refresh  
- Responsive layout (mobile + tablet)

### UI / UX
- Clean, modern design  
- Dark mode support  
- Smooth animations  
- Swipe to delete  
- Sync & connectivity indicators  
- Helpful empty states

### Technical
- MVVM + clean architecture  
- Riverpod for state management  
- Dio for networking  
- Connectivity monitoring  
- Proper error + loading states

---

## Tech Stack
- Flutter (latest stable)
- Riverpod 2.5.1  
- Hive 2.2.3 + hive_flutter 1.1.0  
- Dio 5.4.0  
- connectivity_plus 5.0.2  
- uuid, equatable

---

## Project Structure

```
lib/
├── core/
│   ├── models/
│   ├── providers/
│   ├── services/
│   └── theme/
├── presentation/
│   ├── screens/
│   └── widgets/
└── main.dart
```

---

## Getting Started

### Requirements
- Flutter 3.10.4+
- Dart 3.10.0+
- VS Code / Android Studio (or preferred IDE)

### Installation

Clone the repo
```bash
git clone <repository-url>
cd interview_test_c
```

Install dependencies
```bash
flutter pub get
```

Generate Hive adapters
```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the app
```bash
flutter run
```

---

## Architecture

The app follows **MVVM**:

- **Model** → Task model + Hive adapter  
- **View** → UI inside `presentation/`  
- **ViewModel** → Riverpod providers handle logic  

### Offline-First Flow
- Data is saved to Hive first  
- Unsynced items are flagged  
- When back online, pending tasks sync automatically  
- Server data wins in conflicts

---

## API
Uses JSONPlaceholder for demo purposes:

Base URL: `https://jsonplaceholder.typicode.com`

- `GET /todos`
- `POST /todos`
- `PUT /todos/:id`
- `DELETE /todos/:id`

---

## Error Handling
- Network failures → friendly messages + retry  
- Validation errors → shown inline  
- Works gracefully offline  
- Clear loading indicators

---

## Roadmap
- Background sync  
- Unit + widget tests  
- Categories & tags  
- Priority levels  
- Due dates & reminders  
- Attachments  
- Authentication  
- Multi-device sync  
- Localization support
