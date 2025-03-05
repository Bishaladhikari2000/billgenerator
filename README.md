# Bill Generator App

A Flutter-based mobile application for generating professional invoices and bills. This app streamlines the billing process by providing an intuitive interface for creating, managing, and sharing digital invoices.

## App Showcase


https://github.com/user-attachments/assets/dca0a581-a591-4bf1-9bf2-3cfdf8620c84




## Features

- **Customer Information Management**: Easily input and manage customer details including name, address, and contact information
- **Dynamic Item Management**: Add multiple items with quantity and price calculations
- **Multiple Payment Methods**: Support for various payment methods including Cash, Credit Card, UPI, and Bank Transfer
- **Professional PDF Generation**: Generate professional-looking PDF invoices with detailed formatting
- **Preview and Share**: Preview generated bills before sharing and easily share them through various platforms
- **Real-time Total Calculation**: Automatic calculation of total amount based on item quantities and prices

## Project Structure and Usage

### Core Files

```
billgenerate/
├── lib/
│   ├── main.dart           # Application entry point and theme configuration
│   ├── models/
│   │   └── bill_model.dart # Data models for bill and items
│   └── screens/
│       ├── bill_form_screen.dart  # Main bill form UI
│       └── payment_screen.dart     # Payment processing UI
```

### Component Usage

1. **main.dart**
   - Entry point of the application
   - Configures the app theme and material design settings
   - Sets up the initial route to BillFormScreen
   ```dart
   void main() {
     runApp(const MyApp());
   }
   ```

2. **models/bill_model.dart**
   - Contains data structures for bills and items
   - Handles bill calculations and JSON serialization
   ```dart
   // Create a new bill item
   final item = BillItem(
     itemName: "Product",
     quantity: 2,
     price: 29.99
   );
   ```

3. **screens/bill_form_screen.dart**
   - Manages customer information input
   - Handles dynamic item addition and total calculation
   - Provides form validation and navigation to payment
   ```dart
   // Add a new item to the bill
   void _addItem() {
     showDialog(
       context: context,
       builder: (context) => AddItemDialog(
         onItemAdded: (item) => setState(() {
           _items.add(item);
         }),
       ),
     );
   }
   ```

4. **screens/payment_screen.dart**
   - Processes payment method selection
   - Generates final PDF bill
   - Handles bill sharing and preview

### Supporting Directories

- **android/**: Android platform-specific configuration and build files
- **ios/**: iOS platform-specific configuration and build files
- **test/**: Unit and widget tests
- **.dart_tool/**: Dart SDK tools and configuration
- **build/**: Compiled assets and build outputs

## Technologies Used

- **Flutter**: Cross-platform UI framework for building natively compiled applications
- **Dart**: Programming language optimized for building mobile, desktop, server, and web applications
- **PDF**: PDF generation and manipulation using the pdf package
- **Material Design**: Modern and responsive UI following Material Design principles

## Learning Outcomes

Developing this bill generator app provided valuable experience in:

1. **State Management**: Implementing efficient state management using Flutter's StatefulWidget
2. **PDF Generation**: Learning to create and manipulate PDF documents programmatically
3. **Form Handling**: Managing complex forms with validation and dynamic content
4. **UI/UX Design**: Creating an intuitive and responsive user interface
5. **Data Models**: Designing and implementing structured data models for bill information
6. **File Operations**: Handling file generation and sharing capabilities

## How It Works

1. **Bill Information Entry**:
   - Users start by entering customer details (name, address, phone number)
   - Add items to the bill with quantity and price information
   - The app automatically calculates the total amount

2. **Payment Processing**:
   - Select from available payment methods
   - Review the total amount and payment details

3. **Bill Generation**:
   - Generate a professional PDF invoice
   - Preview the generated bill
   - Option to share or print the bill

This project demonstrates the practical implementation of a real-world business application using modern mobile development technologies and best practices.
# billgenerator
