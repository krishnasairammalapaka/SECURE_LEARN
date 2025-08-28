# SecureLearn - Mobile App Security Learning Platform

A comprehensive Flutter mobile application designed to demonstrate and teach mobile app security concepts, focusing on OWASP Mobile Top 10 vulnerabilities and secure development practices.

## 🎯 Project Overview

SecureLearn is an educational platform that provides hands-on experience with mobile app security vulnerabilities and their prevention. The app serves as both a learning tool and a demonstration of secure coding practices for students, developers, and security testers.

## 🔐 Security Features

### Authentication & Authorization
- **Secure Login System**: Password hashing with SHA-256
- **Role-based Access Control**: Different user roles (Admin, Developer, Tester, Student)
- **Session Management**: Secure token generation and storage
- **Encrypted Storage**: Sensitive data stored using Flutter Secure Storage

### Security Implementations
- **Password Hashing**: SHA-256 cryptographic hashing
- **Secure Token Generation**: Time-based secure tokens
- **Encrypted Local Storage**: All sensitive data encrypted at rest
- **Input Validation**: Comprehensive form validation and sanitization
- **Session Persistence**: Secure session management across app restarts

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd secure_learn_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 👥 Demo Credentials

Use any of these credentials to login and explore different user roles:

| Role | Username | Password |
|------|----------|----------|
| Administrator | `admin` | `admin123` |
| Student | `student` | `student123` |
| Developer | `developer` | `dev123` |
| Tester | `tester` | `test123` |

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication logic
│   └── security_provider.dart # Security features
├── screens/                 # UI screens
│   ├── login_screen.dart    # Login interface
│   └── home_screen.dart     # Main dashboard
└── utils/                   # Utilities
    └── theme.dart          # App theming
```

## 🎨 Features

### Current Features
- **Secure Login System**: Modern, responsive login interface
- **Dashboard**: User-specific dashboard with security metrics
- **Role-based UI**: Different interfaces based on user role
- **Security Status**: Real-time security scoring and recommendations
- **Modern UI**: Material Design 3 with security-focused theming

### Planned Features
- **OWASP Mobile Top 10 Modules**: Interactive learning modules
- **Vulnerability Demonstrations**: Hands-on security testing
- **Security Quizzes**: Knowledge assessment tools
- **Progress Tracking**: Learning progress and achievements
- **Security Scanning**: Built-in security analysis tools

## 🔧 Dependencies

### Core Dependencies
- `flutter_secure_storage`: Encrypted local storage
- `shared_preferences`: Local data persistence
- `crypto`: Cryptographic operations
- `http`: Network requests
- `provider`: State management
- `local_auth`: Biometric authentication
- `dio`: HTTP client for network operations

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code quality and style enforcement

## 🛡️ Security Best Practices Implemented

1. **Password Security**
   - SHA-256 hashing for password storage
   - Minimum password length requirements
   - Secure password validation

2. **Data Protection**
   - Encrypted local storage for sensitive data
   - Secure token generation and management
   - Input sanitization and validation

3. **Session Management**
   - Secure session persistence
   - Automatic logout capabilities
   - Role-based access control

4. **UI Security**
   - Password visibility toggle
   - Form validation with user feedback
   - Secure credential display

## 📱 Platform Support

- **Android**: Full support with native security features
- **iOS**: Compatible (requires additional setup for biometric auth)
- **Web**: Basic support (limited security features)
- **Desktop**: Compatible (Windows, macOS, Linux)

## 🔍 Security Testing

The app is designed to be used with security testing tools like:
- **MobSF**: Mobile Security Framework
- **Burp Suite**: Web application security testing
- **OWASP ZAP**: Security vulnerability scanner

## 📚 Learning Objectives

1. **Understand Mobile Security**: Learn about common mobile app vulnerabilities
2. **Secure Development**: Practice implementing security best practices
3. **Testing & Analysis**: Use security tools to identify vulnerabilities
4. **Risk Assessment**: Evaluate security risks and mitigation strategies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This application is designed for educational purposes only. The security vulnerabilities demonstrated are intentional and should not be used in production applications. Always follow security best practices when developing real-world applications.

## 📞 Support

For questions, issues, or contributions, please:
- Open an issue on GitHub
- Contact the development team
- Review the documentation

---

**Built with ❤️ for mobile app security education**
