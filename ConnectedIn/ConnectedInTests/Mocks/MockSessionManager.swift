import Foundation
@testable import ConnectedIn
import Amplify

class MockSessionManager: SessionManager {
    var authStateCalled = false
    var getCurrentAuthUserCalled = false
    
    override var authState: AuthState {
        didSet {
            authStateCalled = true
        }
    }
    
    override func getCurrentAuthUser() async {
        getCurrentAuthUserCalled = true
    }
    
    func reset() {
        authStateCalled = false
        getCurrentAuthUserCalled = false
        authState = .onboarding
    }
}
