# 🛒 MyShop – Flutter E‑Commerce Application

MyShop is a **Flutter-based e-commerce mobile application** integrated with **Firebase**, designed to support both **customer shopping** and **admin management** within a single platform.

The app focuses on real-world e-commerce workflows, combining a smooth customer experience with a **secure, icon-driven Admin Dashboard** for managing products, orders, and users in real time.

---

## 📱 App Overview

MyShop allows customers to browse products and place orders, while administrators can manage the entire store through a dedicated admin dashboard.

The project is built as a **scalable learning and portfolio project**, following clean architecture principles and Firebase best practices.

---

## 🛍️ User Features (Customer Side)

Users can:

* Browse products with images, prices, and descriptions
* View detailed product information
* Place orders securely
* Track order status updates (Pending → Delivered)
* Authenticate using Firebase Authentication

The user interface is optimized for mobile devices, responsive, and easy to navigate.

---

## 🧑‍💼 Admin Dashboard Features

The Admin Dashboard provides full control over the store using a clean, **icon-based UI**.

### 📦 Product Management

* Add new products
* Edit existing product details
* Delete products
* Manage product stock quantities
* View products in real time using Firestore streams

### 🧾 Order Management

* View all customer orders
* See order details (order ID, user, total price)
* Update order status:

  * Pending
  * Processing
  * Shipped
  * Delivered

### 👤 User Management

* View registered users
* Display user details (name, email, registration date)
* Identify admin vs regular users
* Structure ready for role-based access control

### 🔐 Authentication & Security

* Firebase Authentication for login and logout
* Secure admin access
* Firestore-ready for role-based security rules

---

## ⚙️ Tech Stack

* **Frontend:** Flutter (Material Design)
* **Backend:** Firebase

  * Firebase Authentication
  * Cloud Firestore (Real-time database)
* **State Management:** Provider
* **UI Design:** Icon-first layout using Iconly
* **Architecture:** Modular and scalable

---

## 📂 Project Structure

```text
lib/
 ├── models/        # Data models (Product, Order, User)
 ├── providers/     # State management (Provider)
 ├── screens/       # App screens (User & Admin)
 ├── widgets/       # Reusable UI components
 ├── services/      # Firebase services (Auth, Firestore)
 └── main.dart      # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK installed
* Firebase project set up
* Android Studio / VS Code

### Installation

```bash
git clone https://github.com/Mburu45/myshop.git
cd myshop
flutter pub get
```

### Firebase Setup

1. Create a Firebase project
2. Add Android/iOS apps in Firebase console
3. Download configuration files:

   * `google-services.json` (Android)
   * `GoogleService-Info.plist` (iOS)
4. Enable:

   * Firebase Authentication
   * Cloud Firestore

---

## 🔐 Firebase Collections (Example)

* **products**
* **orders**
* **users**

Firestore rules can be extended for admin-only access.

---

## 🎯 Project Goals

This project aims to demonstrate:

* Real-world Flutter + Firebase integration
* Admin dashboard design and logic
* CRUD operations with Firestore
* Clean, scalable Flutter architecture

MyShop can serve as:

* A portfolio project
* A learning reference
* A base for a production-ready e-commerce application

---

## 🧠 Future Improvements

* Product categories management
* Product reviews and ratings
* Push notifications
* Analytics dashboard (sales, users, orders)
* Web & tablet responsive admin layout
* Role-based access control

---

## 📜 License

This project is licensed under the **MIT License**.

---

## 🙌 Author

**Lawrence Mburu (Mburu45)**
Flutter Developer | Firebase | Mobile App Development

---

⭐ If you find this project useful, feel free to star the repository!
