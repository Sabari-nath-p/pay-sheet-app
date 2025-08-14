# Customer Management System

## Overview
A comprehensive customer management system for company owners with features to view, create, and manage customers.

## Features

### 📱 Owner Home Screen
- **Customer Analytics Dashboard**: View all customers with financial summaries
- **Search Functionality**: Search customers by Customer ID
- **Pagination**: Navigate through customer pages with pagination controls
- **Real-time Data**: Refresh capability to get latest customer data

### 🔍 Search & Filter
- Search by Customer ID
- Real-time search with clear option
- Pagination support for large datasets

### ➕ Create Customer
- Bottom sheet modal for creating new customers
- Form validation for required fields
- Professional UI with responsive design
- Password visibility toggle
- Real-time form validation

### 💳 Customer Card Display
- Customer ID and status (Active/Inactive)
- Shop name and contact information
- Financial summary (Total Bills, Total Amount, Paid Amount, Pending Amount)
- Professional card design with proper spacing

## API Endpoints

### Get Customer Analytics
- **Endpoint**: `GET /company-owners/customer-analytics`
- **Auth**: Bearer token required
- **Query Parameters**:
  - `page`: Page number (default: 1)
  - `limit`: Items per page (default: 10)
  - `customerId`: Optional search filter

### Create Customer
- **Endpoint**: `POST /customers`
- **Auth**: Bearer token required
- **Response Codes**:
  - `201`: Customer created successfully
  - `400`: Bad request (validation errors)
  - `409`: Customer ID already exists

## File Structure

```
lib/
├── core/
│   ├── models/
│   │   └── customer_model.dart           # Customer data models
│   ├── services/
│   │   └── api_service.dart              # API service utilities
│   └── utils/
│       └── api_constants.dart            # API endpoint constants
└── Screens/
    └── Owners/
        └── OwnerHomeScreen/
            ├── Controller/
            │   └── CustomerController.dart    # Business logic controller
            ├── Widgets/
            │   ├── customer_card.dart         # Customer display card
            │   └── create_customer_bottom_sheet.dart  # Create customer form
            └── OwnerHomeScreen.dart           # Main screen UI
```

## Key Components

### CustomerController
- Manages customer data and API calls
- Handles form validation and submission
- Implements pagination logic
- Search functionality with debouncing

### Customer Model
- `Customer`: Main customer data model
- `CustomerResponse`: API response wrapper
- `PaginationData`: Pagination information
- `CreateCustomerRequest`: Create customer request model

### UI Components
- **CustomerCard**: Displays customer information in a professional card layout
- **CreateCustomerBottomSheet**: Modal form for creating new customers
- **OwnerHomeScreen**: Main dashboard with search, list, and pagination

## Usage

### Initialize Controller
```dart
final CustomerController controller = Get.put(CustomerController());
```

### Navigation to Owner Home
The controller automatically loads when the screen is initialized and checks for saved authentication.

### Search Customers
Users can search by typing in the search bar and pressing enter or clicking the search button.

### Create New Customer
Tap the floating action button to open the create customer bottom sheet.

### Pagination
Use the pagination controls at the bottom to navigate through customer pages.

## Configuration

### API Base URL
Update the base URL in `lib/core/utils/api_constants.dart`:
```dart
static const String baseUrl = 'https://your-api-url.com';
```

### Company ID
The company ID is currently fixed as 'COMP001' in the create customer request. Update this as needed.

## Localization Support
The implementation supports localization with GetX's translation system. Add appropriate translation keys for:
- Error messages
- Form labels
- Success messages
- UI text

## Dependencies
- `get`: State management and navigation
- `http`: HTTP requests
- `shared_preferences`: Local data storage
- `flutter_screenutil`: Responsive design

## Error Handling
- Network error handling with user-friendly messages
- Form validation with real-time feedback
- API error response parsing
- Loading states for better UX
