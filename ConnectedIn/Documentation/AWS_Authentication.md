# ConnectedIn AWS Authentication Documentation

## Overview
ConnectedIn uses AWS Amplify for authentication, specifically the Cognito service. The implementation follows a state-based approach using SwiftUI and combines AWS Amplify's authentication features with custom user management.

## Architecture

### Key Components

1. **SessionManager** (`SessionManager.swift`)
   - Singleton instance managing authentication state
   - Handles user session persistence
   - Controls app navigation based on auth state
   ```swift
   enum AuthState {
       case onboarding
       case signUp
       case login
       case forgotPassword
       case resetPassword
       case userDashboard(user: AuthUser)
       case sessionUser(user: AuthUser)
       case sessionChurch(user: AuthUser)
       case confirmCode(username: String)
       case confirmMFACode
   }
   ```

2. **AuthViewModel** (`AuthViewModel.swift`)
   - Handles authentication logic
   - Manages login, signup, and password reset flows
   - Communicates with AWS Amplify
   - Updates SessionManager state

3. **AppInitializer** (`ConnectedInApp.swift`)
   - Initializes AWS Amplify
   - Checks for existing sessions
   - Manages splash screen and initial routing

## Authentication Flow

### 1. App Launch
```swift
// AppInitializer
1. Check if first launch
2. Initialize AWS Amplify
3. Check for existing session
4. Route to appropriate screen
```

### 2. Login Flow
```swift
1. User enters credentials
2. AuthViewModel.login() called
3. Amplify.Auth.signIn() attempted
4. On success:
   - Fetch auth session
   - Get current user
   - Update SessionManager state
   - Navigate to dashboard
5. On failure:
   - Show error message
   - Stay on login screen
```

### 3. Session Management
```swift
// SessionManager.getCurrentAuthUser()
1. Check for active AWS session
2. If active:
   - Get current Cognito user
   - Load saved user data
   - Update app state
3. If inactive:
   - Clear session
   - Route to login/onboarding
```

### 4. Session Persistence
- AWS tokens stored securely by Amplify
- User preferences stored in UserDefaults
- Session checked on each app launch
- Auto-login if valid session exists

## Security Features

1. **Token Management**
   - Handled automatically by AWS Amplify
   - Secure token storage
   - Automatic token refresh

2. **Error Handling**
   - Network errors
   - Invalid credentials
   - Session expiration
   - MFA challenges

3. **State Protection**
   - Protected routes
   - Session validation
   - Automatic logout on token expiration

## Implementation Details

### AWS Configuration
```swift
try Amplify.add(plugin: AWSCognitoAuthPlugin())
try Amplify.configure()
```

### Session Checks
```swift
let session = try await Amplify.Auth.fetchAuthSession()
if session.isSignedIn {
    // Handle active session
} else {
    // Handle no session
}
```

### User Authentication
```swift
let result = try await Amplify.Auth.signIn(username: email, password: password)
switch result.nextStep {
case .confirmSignUp:
    // Handle signup confirmation
case .done:
    // Handle successful login
// ... handle other cases
}
```

## Best Practices Implemented

1. **State Management**
   - Single source of truth (SessionManager)
   - Clear state transitions
   - Predictable navigation flow

2. **Error Handling**
   - Comprehensive error messages
   - User-friendly error display
   - Graceful fallbacks

3. **User Experience**
   - Smooth transitions
   - Loading states
   - Persistent sessions
   - Quick relaunch for returning users

4. **Security**
   - Secure credential handling
   - Token-based authentication
   - Session expiration
   - Protected routes

## Common Scenarios

### 1. First Launch
```
App Launch → Initialize AWS → Show Onboarding → Login/Signup
```

### 2. Returning User (Active Session)
```
App Launch → Initialize AWS → Verify Session → Dashboard
```

### 3. Session Expired
```
App Launch → Initialize AWS → Failed Session Check → Login
```

### 4. Password Reset
```
Login Screen → Forgot Password → Reset Flow → Login
```

## Testing Considerations

1. **Session States**
   - Fresh install
   - Active session
   - Expired session
   - Invalid session

2. **Network Conditions**
   - Offline mode
   - Poor connectivity
   - Request timeouts

3. **User Scenarios**
   - New user signup
   - Returning user login
   - Password reset
   - Session expiration

## Troubleshooting

Common issues and solutions:

1. **Session Not Persisting**
   - Check AWS configuration
   - Verify token storage
   - Check session validation logic

2. **Authentication Failures**
   - Verify credentials
   - Check network connectivity
   - Validate AWS configuration

3. **State Management Issues**
   - Check SessionManager state
   - Verify navigation logic
   - Debug state transitions

## Future Considerations

1. **Potential Improvements**
   - Biometric authentication
   - Enhanced session management
   - Offline capabilities
   - Social login integration

2. **Security Enhancements**
   - Additional MFA options
   - Enhanced error logging
   - Security event tracking

3. **User Experience**
   - Smoother transitions
   - Better error messaging
   - Enhanced session recovery
