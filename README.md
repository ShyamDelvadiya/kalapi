# My PG - PG Management System

A comprehensive Flutter application for managing Paying Guest (PG) accommodations, designed for PG owners, managers, and staff to efficiently handle all aspects of PG operations.

## 🏠 About My PG

My PG is a modern, feature-rich mobile application that streamlines PG management operations. It provides tools for guest management, staff coordination, payment tracking, expense management, and much more - all in one intuitive platform.

## ✨ Key Features

### 👥 **User Management**
- **Multi-role support**: PG Owner, Manager, Staff
- **Guest management**: Add, manage, and track guests
- **Staff management**: Handle staff members and their roles
- **Profile management**: Update personal information and settings

### 🏢 **PG Operations**
- **Room management**: Track rooms, beds, and occupancy
- **Availability tracking**: Monitor empty beds and due rent members
- **QR code management**: Generate and manage payment QR codes
- **Attendance system**: Track staff and guest attendance

### 💰 **Financial Management**
- **Payment tracking**: Record and monitor payments
- **Expense management**: Track monthly expenses and costs
- **Dashboard analytics**: View financial summaries and statistics
- **Payment categories**: Organize different types of payments

### 📱 **Modern Features**
- **Dark/Light theme**: Customizable app appearance
- **Real-time updates**: Live data synchronization
- **Secure authentication**: Safe user login and data protection
- **Responsive design**: Works seamlessly on all device sizes

### 🔧 **Additional Tools**
- **Meter reading module**: Track utility consumption
- **Menu management**: Handle food menus and meal planning
- **Announcements**: Send important notifications
- **Account management**: Secure profile and data handling

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest stable version)
- Android Studio / VS Code
- Android device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/HarshVihaa/my_pg.git
   cd my_pg
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` file to `android/app/`
   - Update Firebase configuration as needed

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Release

1. **Generate keystore** (first time only)
   ```bash
   cd android/key
   keytool -genkey -v -keystore my_pg_keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my_pg_key
   ```

2. **Update signing credentials**
   - Edit `android/key.properties` with your keystore passwords

3. **Build signed APK**
   ```bash
   flutter build apk --release
   ```

## 🏗️ Project Structure

```
lib/
├── api_service/          # API integration and services
├── bindings/            # GetX dependency injection
├── data/               # Data models and repositories
├── routing/            # App navigation and routes
├── theme_controller/   # Theme management
├── utils/             # Utilities and constants
└── view/              # UI components and screens
    ├── baseWidget/    # Reusable widgets
    └── pages/         # App screens and pages
```

## 🛠️ Built With

- **Flutter** - Cross-platform mobile framework
- **GetX** - State management and dependency injection
- **Firebase** - Backend services and authentication
- **Google Fonts** - Typography
- **Cached Network Image** - Efficient image loading
- **QR Code Scanner** - QR functionality
- **Local Notifications** - Push notifications

## 📱 Supported Platforms

- ✅ Android (API 23+)
- ✅ iOS (iOS 11.0+)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Harsh Vihaa**
- GitHub: [@HarshVihaa](https://github.com/HarshVihaa/my_pg)

## 📞 Support

For support and queries, please create an issue in the GitHub repository or contact the development team.

---

**Made with ❤️ for efficient PG management**
