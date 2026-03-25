# Task Management Application - Project Specification & Requirements

**Course:** Mobile Application Development  
**Instructor:** Muhammad Abrar Saddique  
**Semester:** SPRING 2026  
**Project Title:** Development of a Comprehensive Task Management Application  
**Submission Deadline:** 30 March 2026  
**Total Marks:** 100

> **Important Note:** Copying code from another student will result in **zero marks** for both parties involved due to plagiarism.

---

## 1. Objective

Develop a **fully functional task management application** using **Flutter** and **SQLite**. The app must allow users to manage daily tasks effectively with features including task addition, modification, deletion, categorization, custom notifications, task repetition, progress tracking, and data export options.

The application must provide:
- A user-friendly interface
- Robust data storage (SQLite)
- Customization capabilities
- Advanced functionality (repeating tasks, subtasks, progress bars, export to CSV/PDF/email)

---

## 2. Project Description

Create a complete task management mobile app that goes beyond basic CRUD operations. The app must include:

- Three main views: **Today Tasks**, **Completed Tasks**, and **Repeated Tasks**
- Persistent data storage using SQLite
- Task repetition logic (daily or specific days of the week)
- Subtask support with progress tracking
- Local notifications based on due dates/times
- Theme customization (light/dark mode) and notification sound selection
- Export functionality (CSV, PDF, email)
- Clean, responsive, and aesthetically pleasing UI

---

## 3. Functional Requirements

### 3.1 Setup and Configuration
- Set up a new Flutter project with proper environment configuration.
- Initialize an SQLite database with well-designed schema for tasks (including tables for tasks, subtasks, and settings if needed).

### 3.2 User Interface
Design a simple, intuitive, and responsive interface with the following dedicated views/screens:
- **Today Task**: All tasks due on the current day.
- **Completed Task**: All tasks that have been marked as completed.
- **Repeated Task**: All recurring tasks (with their repeat settings visible).

### 3.3 Task Management (Core CRUD)
- **Add Task**: Title, description, due date & time, optional repeat settings.
- **Edit Task**: Modify any task details.
- **Delete Task**: Remove tasks permanently.
- **Mark as Completed**: Move task automatically to "Completed Task" view.

### 3.4 Advanced Features
- **Customization Options**:
    - Theme switch (Light ↔ Dark mode)
    - Choose custom notification sounds
- **Progress Tracking**:
    - Support for **subtasks**
    - Display progress bar/percentage completion for each task
- **Export Functionality**:
    - Export all tasks (or filtered views) to **CSV**
    - Export to **PDF**
    - Share/export via **email**
- **Repeat Tasks**:
    - Set tasks to repeat **daily** or on **selected days of the week**
    - Automatically reset/recreate the task based on user-defined repeat settings

### 3.5 Notifications
- Implement **local notifications** to alert users of upcoming tasks based on due date and time.

### 3.6 Testing
- Thoroughly test for functionality, usability, responsiveness across different device sizes.
- Identify and fix all bugs.

### 3.7 Documentation & Submission
- Submit the **complete source code** on GitHub.
- Include the **.apk** build file.
- Include any necessary configuration files.
- Provide a **video demonstration** of the full application (features walkthrough).

---

## 4. Recommended Tools & Libraries

| Tool / Library          | Purpose                              |
|-------------------------|--------------------------------------|
| Flutter                 | UI + Application Logic               |
| SQLite (via `sqflite`)  | Local persistent database            |
| `flutter_local_notifications` | Local push notifications       |
| `path_provider`         | File handling (export)               |
| `pdf` / `csv` packages  | PDF & CSV export                     |
| `share_plus` / `url_launcher` | Email sharing                  |
| `provider` / `riverpod` | State management (recommended)       |
| Any other Flutter plugins as needed | —                                |

---

## 5. Estimated Time Commitment

- **Total Time**: Approximately **42 hours**
- **Daily Commitment**: 1.5 – 2 hours per day

---

## 6. Marks Distribution

| # | Component                          | Description                                                                 | Marks |
|---|------------------------------------|-----------------------------------------------------------------------------|-------|
| 1 | Project Setup and Design           | Flutter environment setup + initial UI design                              | 10    |
| 2 | Database Integration               | Correct SQLite setup and schema design                                      | 10    |
| 3 | Task Management Features           | Add, edit, delete, mark as completed                                        | 20    |
| 4 | Advanced Features                  | Customization, progress tracking (subtasks), export (CSV/PDF/email)         | 20    |
| 5 | Repeat Functionality               | Correct implementation of repeating tasks                                   | 10    |
| 6 | Notifications                      | Local notifications for due tasks                                           | 10    |
| 7 | User Interface                     | Usability, aesthetics, and responsiveness                                   | 10    |
| 8 | Documentation & Submission on GitHub | Code documentation, user manual (if any), video demo                      | 10    |
|   | **Total**                          |                                                                             | **100** |

---

## 7. Deliverables (Must Submit)

1. Full Flutter project source code (GitHub repository)
2. Compiled `app-release.apk`
3. Any required configuration files (`pubspec.yaml`, assets, etc.)
4. Video demonstration (features walkthrough – preferably hosted on YouTube/Google Drive with public link)

---
