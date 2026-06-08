# Voltera Mobile Development Rules

## Project Overview

This project is a Flutter mobile application for the Voltera EV Marketplace system.

Backend is already implemented using Spring Boot REST APIs.

Flutter is only responsible for:

* UI
* State Management
* API Integration
* Navigation
* Local Storage

DO NOT generate backend code.

---

# Architecture

Use Feature-First Architecture.

Folder structure:

lib/
├── main.dart
├── core/
├── routes/
├── services/
├── models/
├── features/

Never create folders outside this structure.

---

# Core Folder

lib/core/

Contains reusable infrastructure:

core/
├── constants/
├── network/
├── theme/
└── widgets/

Examples:

* api_client.dart
* app_colors.dart
* app_theme.dart
* custom_button.dart
* custom_text_field.dart

---

# Features Structure

Every feature must follow:

features/
└── feature_name/
├── screens/
├── widgets/
├── provider/
└── service/

Example:

features/
└── auth/
├── screens/
├── widgets/
├── provider/
└── auth_service.dart

---

# State Management

Use Provider only.

DO NOT use:

* Bloc
* Cubit
* Riverpod
* Redux
* GetX

Pattern:

Screen
↓
Provider
↓
Service
↓
Spring Boot API

---

# API Calls

Use Dio.

All API calls must go through:

core/network/api_client.dart

Example:

final response = await ApiClient.dio.get(...);

Never create multiple Dio instances.

---

# Models

All DTOs must be placed in:

lib/models/

Examples:

user_model.dart
post_model.dart
contract_model.dart
payment_model.dart
refund_model.dart
notification_model.dart

Use fromJson() and toJson().

---

# Routing

Use GoRouter.

All routes must be registered inside:

routes/app_router.dart

Never use Navigator.push directly unless explicitly requested.

---

# Authentication

Authentication uses JWT.

Requirements:

* Store Access Token using Flutter Secure Storage
* Attach token automatically using Dio Interceptor
* Redirect to Login when token expires

---

# UI Rules

Use Material 3.

Requirements:

* Responsive layouts
* Reusable widgets
* No hardcoded colors
* Use AppTheme

Common widgets must be placed in:

core/widgets/

---

# Naming Convention

Screens:

login_page.dart
home_page.dart
product_detail_page.dart

Providers:

auth_provider.dart
product_provider.dart

Services:

auth_service.dart
product_service.dart

Models:

user_model.dart
post_model.dart

Widgets:

product_card.dart
notification_tile.dart

---

# Feature List

Implement features in this order:

1. Authentication
2. Home
3. Product Catalog
4. Product Detail
5. Favorites
6. Profile
7. Contract
8. Payment
9. Transaction History
10. Refund
11. Complaint
12. Notification
13. Admin

Do not implement future features unless requested.

---

# Code Quality

Requirements:

* Null safety enabled
* No duplicated code
* Extract reusable widgets
* Keep files under 300 lines when possible
* Follow SOLID principles where practical

Before generating code:

1. Check existing folder structure.
2. Reuse existing widgets.
3. Reuse existing services.
4. Avoid creating duplicate models.
5. Follow the architecture above strictly.
