# Tasky App 📋

A Flutter-based task management application designed to streamline task organization with advanced features like QR scanning, infinite scrolling, and image optimization.

## Features 🚀

### 🌟 Key Features

- **Onboarding Screen**: Welcome users with a smooth onboarding experience.
- **Authentication**:
  - **Login**: Secure login system for existing users.
  - **Register**: Easy-to-use registration system for new users.
- **Profile Management**: View and update your personal details.
- **Task Management**:
  - **Home Screen**:
    - View all tasks.
    - Apply filters to sort tasks.
    - Infinite scrolling for seamless navigation.
  - **Add Tasks**:
    - Use a **QR scanner** to add tasks quickly.
    - Enter task details manually.
    - Upload task images with optimized, low-quality compression for faster uploads.
  - **Task Details**:
    - View detailed information about a task.
    - Generate a **QR code** for the task.
  - **Edit and Delete Tasks**:
    - Modify existing tasks easily.
    - Delete tasks you no longer need.

### 📸 Screenshots

Below are screenshots showcasing the app's key features:

### Onboarding Screen\*\*

  <img src="screenshot/onboardingE.png" alt="Onboarding Screen" width="300"/>

### Login

  <img src="screenshot/loginE.png" alt="Login Screen" width="300"/>

### Register

 <img src="screenshot/signupE.png" alt="Register Screen" width="300"/>    <img src="screenshot/signup2E.png" alt="Register Screen" width="300"/>
  

### Profile

  <img src="screenshot/profileE.png" alt="Profile Screen" width="300"/>

### Home (Tasks & Filters)\*\*

  <img src="screenshot/taskesE.png" alt="Home Screen" width="300"/>

### Add Task with QR Scanner\*\*

  <img src="screenshot/add_taskE.png" alt="Add Task Screen" width="300"/>
  <img src="screenshot/select_imageE.png" alt="Add Task 2 Screen" width="300"/>
  <img src="screenshot/qrE.png" alt="Add Task 2 Screen" width="300"/>

### Task Details with QR Code\*\*

  <img src="screenshot/detailsE.png" alt="Task Details Screen" width="300"/>

### Edit Task\*\*

  <img src="screenshot/edit.png" alt="Edit Task Screen" width="300"/>

### Delete Task\*\*

  <img src="screenshot/delete.png" alt="Delete Task Screen" width="300"/>

---

## Installation & Setup 🛠️

1. **Clone the repository**:

   ```bash
   git clone https://github.com/ahmedyosry433/Tasky-Flutter.git
   cd Tasky-Flutter
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the app**:

   ```bash
   flutter run
   ```

4. **Build APK** (Optional):
   ```bash
   flutter build apk --release
   ```

---

## Technical Highlights ✨

- **Low-Quality Image Generation**: Automatically compresses uploaded images for faster server communication.
- **Infinite Scrolling**: Fetches and loads tasks as you scroll, ensuring optimal performance.
- **QR Code Functionality**: Seamlessly scan and generate QR codes for task management.

---

## Contributing 🤝

Contributions are welcome! Please submit a pull request or open an issue for suggestions or bug reports.

---

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
