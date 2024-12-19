import XCTest
@testable import ConnectedIn
import Amplify

@MainActor
final class AuthViewModelTests: XCTestCase {
    var sut: AuthViewModel!
    var mockSessionManager: MockSessionManager!
    var mockAuth: MockAmplifyAuth!
    
    override func setUp() async throws {
        mockSessionManager = MockSessionManager()
        mockAuth = MockAmplifyAuth()
        sut = AuthViewModel(sessionManager: mockSessionManager)
    }
    
    override func tearDown() {
        sut = nil
        mockSessionManager = nil
        mockAuth = nil
    }
    
    // MARK: - Login Tests
    
    func test_login_successful() async {
        // Given
        mockAuth.shouldSucceed = true
        mockAuth.isSignedIn = true
        mockAuth.nextStep = .done
        
        // When
        await sut.login(username: "test@example.com", password: "password123")
        
        // Then
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(mockSessionManager.getCurrentAuthUserCalled)
    }
    
    func test_login_invalidCredentials() async {
        // Given
        mockAuth.shouldSucceed = false
        
        // When
        await sut.login(username: "wrong@example.com", password: "wrongpass")
        
        // Then
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(mockSessionManager.getCurrentAuthUserCalled)
    }
    
    func test_login_requiresConfirmation() async {
        // Given
        mockAuth.shouldSucceed = true
        mockAuth.nextStep = .confirmSignUp
        
        // When
        await sut.login(username: "new@example.com", password: "password123")
        
        // Then
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertEqual(mockSessionManager.authState, .confirmCode(username: "new@example.com"))
    }
    
    func test_login_requiresMFA() async {
        // Given
        mockAuth.shouldSucceed = true
        mockAuth.nextStep = .confirmSignInWithSMSMFACode
        
        // When
        await sut.login(username: "mfa@example.com", password: "password123")
        
        // Then
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertEqual(mockSessionManager.authState, .confirmMFACode)
    }
    
    func test_login_requiresNewPassword() async {
        // Given
        mockAuth.shouldSucceed = true
        mockAuth.nextStep = .confirmSignInWithNewPassword
        
        // When
        await sut.login(username: "temp@example.com", password: "temppass")
        
        // Then
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertEqual(mockSessionManager.authState, .resetPassword)
        XCTAssertEqual(sut.errorMessage, "Please set a new password")
    }
    
    // MARK: - Password Reset Tests
    
    func test_resetPassword_successful() async {
        // Given
        mockAuth.shouldSucceed = true
        
        // When
        await sut.resetPassword(username: "test@example.com")
        
        // Then
        XCTAssertEqual(mockSessionManager.authState, .resetPassword)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_resetPassword_failure() async {
        // Given
        mockAuth.shouldSucceed = false
        mockAuth.error = AuthError.service("Reset failed", "Invalid email", nil)
        
        // When
        await sut.resetPassword(username: "invalid@example.com")
        
        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Reset failed") ?? false)
    }
    
    // MARK: - Navigation Tests
    
    func test_showForgotPassword() {
        // When
        sut.showForgotPassword()
        
        // Then
        XCTAssertEqual(mockSessionManager.authState, .forgotPassword)
    }
    
    func test_showLogin() {
        // When
        sut.showLogin()
        
        // Then
        XCTAssertEqual(mockSessionManager.authState, .login)
    }
    
    // MARK: - Session Tests
    
    func test_handleSuccessfulAuthentication() async {
        // Given
        mockAuth.shouldSucceed = true
        mockAuth.isSignedIn = true
        
        // When
        await sut.handleSuccessfulAuthentication()
        
        // Then
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_handleSuccessfulAuthentication_failure() async {
        // Given
        mockAuth.shouldSucceed = false
        
        // When
        await sut.handleSuccessfulAuthentication()
        
        // Then
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertNotNil(sut.errorMessage)
    }
}
