# Smart Task Manager

A beautiful, feature-rich Flutter task management application with offline-first architecture, automatic sync, and a stunning modern UI.

## 📱 Features

### Core Features
- ✅ **Task Management**: Create, read, update, and delete tasks
- 🔄 **Offline-First**: Works seamlessly offline with local storage using Hive
- 🌐 **Auto-Sync**: Automatically syncs tasks when internet connection is restored
- 🔍 **Search**: Debounced search functionality to find tasks quickly
- 📊 **Task Filtering**: View all tasks, pending tasks, or completed tasks
- ✨ **Pull-to-Refresh**: Refresh tasks from the server with a simple pull gesture
- 📱 **Responsive Design**: Works beautifully on mobile and tablet devices

### UI/UX Features
- 🎨 **Modern Design**: Beautiful gradients, shadows, and animations
- 🌓 **Dark Mode**: Full dark mode support with theme toggle
- 💫 **Smooth Animations**: Fade-in, slide, and micro-animations throughout
- 🎯 **Swipe to Delete**: Intuitive swipe gesture to delete tasks
- 📍 **Status Indicators**: Visual indicators for sync status and connectivity
- 🎭 **Empty States**: Beautiful empty state designs with helpful messages

### Technical Features
- 🏗️ **Clean Architecture**: MVVM pattern with clear separation of concerns
- 🔧 **State Management**: Riverpod for robust state management
- 💾 **Local Storage**: Hive for fast, efficient local data persistence
- 🌐 **API Integration**: Dio for HTTP requests with proper error handling
- 📡 **Connectivity Monitoring**: Real-time online/offline status tracking
- ⚠️ **Error Handling**: Comprehensive error handling with user-friendly messages
- 🔄 **Loading States**: Loading indicators for better user feedback

## 🛠️ Tech Stack

- **Framework**: Flutter (latest stable version)
- **State Management**: Riverpod 2.5.1
- **Local Storage**: Hive 2.2.3 + Hive Flutter 1.1.0
- **API Handling**: Dio 5.4.0
- **Connectivity**: connectivity_plus 5.0.2
- **Utilities**: uuid 4.3.3, equatable 2.0.5

## 📁 Project Structure

```
lib/
├── core/
│   ├── models/
│   │   ├── task_model.dart          # Task data model with Hive annotations
│   │   └── task_model.g.dart        # Generated Hive adapter
│   ├── providers/
│   │   ├── service_providers.dart   # Service dependency injection
│   │   └── task_provider.dart       # Task state management
│   ├── services/
│   │   ├── api_service.dart         # API communication layer
│   │   ├── connectivity_service.dart # Network connectivity monitoring
│   │   └── local_storage_service.dart # Hive database operations
│   └── theme/
│       └── app_theme.dart           # Theme configuration
├── presentation/
│   ├── screens/
│   │   ├── home_screen.dart         # Main task list screen
│   │   └── add_edit_task_screen.dart # Add/Edit task form
│   └── widgets/
│       ├── task_card.dart           # Task item widget
│       ├── empty_state.dart         # Empty state widget
│       └── loading_overlay.dart     # Loading indicator
└── main.dart                        # App entry point
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Dart SDK (3.10.0 or higher)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd interview_test_c
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architectural pattern:

- **Model**: `Task` model with Hive annotations for persistence
- **View**: Flutter widgets in `presentation/` directory
- **ViewModel**: Riverpod providers managing state and business logic

### Offline-First Approach

1. **Local Storage**: All tasks are stored locally using Hive
2. **Optimistic Updates**: UI updates immediately, sync happens in background
3. **Sync Queue**: Unsynced tasks are tracked and synced when online
4. **Conflict Resolution**: Server data takes precedence during sync



## 🔄 Offline Sync Logic

1. **Task Creation**:
   - Save to local storage immediately
   - Mark as `isSynced: false`
   - Attempt API call if online
   - Update sync status on success

2. **Task Update**:
   - Update local storage first
   - Mark as unsynced
   - Sync with server if online

3. **Task Deletion**:
   - Delete from local storage
   - Delete from server if online
   - Handle gracefully if offline

4. **Auto-Sync**:
   - Monitor connectivity status
   - When connection restored, sync all unsynced tasks
   - Update UI with sync status

## 🎨 Design Decisions

### Color Palette
- **Primary**: Purple gradient (#6C5CE7 → #A29BFE)
- **Accent**: Pink-Yellow gradient (#FF6B9D → #FECA57)
- **Success**: Teal gradient (#00D9A3 → #00B894)
- **Error**: Red (#FF6B6B)
- **Warning**: Yellow (#FECA57)

### Typography
- Clean, modern font hierarchy
- Bold headings for emphasis
- Secondary text for descriptions

### Animations
- Fade-in animations on screen entry
- Slide animations for smooth transitions
- Micro-animations on interactions
- Smooth theme transitions

## 🧪 Testing

The app includes comprehensive error handling for:
- Network failures
- API errors
- Local storage errors
- Validation errors

## 📝 API Integration

The app uses JSONPlaceholder API for demonstration:
- **Base URL**: `https://jsonplaceholder.typicode.com`
- **Endpoints**:
  - `GET /todos` - Fetch tasks
  - `POST /todos` - Create task
  - `PUT /todos/:id` - Update task
  - `DELETE /todos/:id` - Delete task

## 🔐 Error Handling

- **Network Errors**: User-friendly messages with retry options
- **Validation Errors**: Inline form validation
- **API Errors**: Graceful degradation with offline mode
- **Loading States**: Clear loading indicators

## 🎯 Future Enhancements

- [ ] Background sync using connectivity_plus
- [ ] Unit tests for state management
- [ ] Widget tests for UI components
- [ ] Task categories and tags
- [ ] Task priorities
- [ ] Due dates and reminders
- [ ] Task attachments
- [ ] User authentication
- [ ] Multi-device sync
- [ ] Localization support

