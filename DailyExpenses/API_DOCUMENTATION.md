# User Registration API Documentation

This document describes the REST API endpoints for user registration and management in the Daily Expenses application.

## Base URL
```
http://localhost:9080/api/users
```

## Authentication
Currently, the API does not require authentication tokens. Session-based authentication is used for web pages.

## API Endpoints

### 1. Register New User

**POST** `/api/users/register`

Register a new user in the system.

**Request Body:**
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "1234567890"
}
```

**Response (Success - 201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "1234567890",
    "createdAt": "2024-01-15T10:30:00",
    "updatedAt": "2024-01-15T10:30:00",
    "active": true
  }
}
```

**Response (Error - 400):**
```json
{
  "success": false,
  "message": "Username already exists"
}
```

### 2. User Login

**POST** `/api/users/login`

Authenticate a user with username/email and password.

**Request Body:**
```json
{
  "username": "johndoe",
  "password": "password123"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "active": true
  }
}
```

**Response (Error - 401):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

### 3. Get All Users

**GET** `/api/users/`

Retrieve a list of all active users.

**Response (200):**
```json
[
  {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "1234567890",
    "createdAt": "2024-01-15T10:30:00",
    "active": true
  },
  {
    "id": 2,
    "username": "janedoe",
    "email": "jane@example.com",
    "firstName": "Jane",
    "lastName": "Doe",
    "active": true
  }
]
```

### 4. Get User by ID

**GET** `/api/users/{id}`

Retrieve a specific user by their ID.

**Path Parameters:**
- `id` (number): User ID

**Response (Success - 200):**
```json
{
  "success": true,
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "1234567890",
    "createdAt": "2024-01-15T10:30:00",
    "active": true
  }
}
```

**Response (Error - 404):**
```json
{
  "success": false,
  "message": "User not found"
}
```

### 5. Update User

**PUT** `/api/users/{id}`

Update user information (only firstName, lastName, and phoneNumber can be updated).

**Path Parameters:**
- `id` (number): User ID

**Request Body:**
```json
{
  "firstName": "John Updated",
  "lastName": "Doe Updated",
  "phoneNumber": "9876543210"
}
```

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "User updated successfully",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John Updated",
    "lastName": "Doe Updated",
    "phoneNumber": "9876543210",
    "updatedAt": "2024-01-15T15:45:00",
    "active": true
  }
}
```

### 6. Deactivate User

**DELETE** `/api/users/{id}`

Deactivate a user (soft delete).

**Path Parameters:**
- `id` (number): User ID

**Response (Success - 200):**
```json
{
  "success": true,
  "message": "User deactivated successfully"
}
```

### 7. Check Username Availability

**GET** `/api/users/check-username/{username}`

Check if a username is available for registration.

**Path Parameters:**
- `username` (string): Username to check

**Response (200):**
```json
{
  "available": true,
  "message": "Username is available"
}
```

### 8. Check Email Availability

**GET** `/api/users/check-email/{email}`

Check if an email is available for registration.

**Path Parameters:**
- `email` (string): Email to check

**Response (200):**
```json
{
  "available": false,
  "message": "Email is already registered"
}
```

### 9. Search Users

**GET** `/api/users/search?name={searchTerm}`

Search users by name or username.

**Query Parameters:**
- `name` (string): Search term

**Response (200):**
```json
[
  {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "active": true
  }
]
```

### 10. Get User Statistics

**GET** `/api/users/stats`

Get user statistics.

**Response (200):**
```json
{
  "totalActiveUsers": 5,
  "allUsers": 5
}
```

## Web Pages

The following web pages are available for user interaction:

### User Registration
- **URL:** `/user/register`
- **Method:** GET (show form), POST (submit form)
- **Description:** User registration form with validation

### User Login
- **URL:** `/user/login`
- **Method:** GET (show form), POST (submit form)
- **Description:** User login form with remember me option

### User Dashboard
- **URL:** `/user/dashboard`
- **Method:** GET
- **Description:** User dashboard with statistics and quick actions
- **Requires:** User session

### User Profile
- **URL:** `/user/profile`
- **Method:** GET (show form), POST (update profile)
- **Description:** User profile management page
- **Requires:** User session

### User List
- **URL:** `/user/list`
- **Method:** GET
- **Description:** List of all registered users with search functionality
- **Requires:** User session

### User Logout
- **URL:** `/user/logout`
- **Method:** GET
- **Description:** Logout user and destroy session

## Example Usage with cURL

### Register a new user:
```bash
curl -X POST http://localhost:9080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "User"
  }'
```

### Login:
```bash
curl -X POST http://localhost:9080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

### Get all users:
```bash
curl -X GET http://localhost:9080/api/users/
```

## Error Codes

- **200 OK:** Request successful
- **201 Created:** Resource created successfully
- **400 Bad Request:** Invalid request data
- **401 Unauthorized:** Authentication failed
- **404 Not Found:** Resource not found
- **500 Internal Server Error:** Server error

## Notes

1. All passwords are stored in plain text (for development purposes only - implement proper hashing in production)
2. Email and username must be unique across the system
3. Phone number is optional
4. Users are soft-deleted (marked as inactive) rather than permanently removed
5. The application uses H2 database which stores data in a file
6. Session management is handled by Spring Security (basic implementation)

## Database Schema

The User entity has the following fields:

- `id` (Long): Primary key, auto-generated
- `username` (String): Unique username, max 50 characters
- `email` (String): Unique email address, max 100 characters
- `password` (String): User password, max 255 characters
- `firstName` (String): User's first name, max 100 characters
- `lastName` (String): User's last name, max 100 characters
- `phoneNumber` (String): User's phone number, max 15 characters
- `createdAt` (LocalDateTime): Account creation timestamp
- `updatedAt` (LocalDateTime): Last update timestamp
- `isActive` (boolean): Account status flag