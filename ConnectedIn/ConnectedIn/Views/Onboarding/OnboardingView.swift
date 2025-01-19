import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private let onboardingPages = [
        (title: "Connect", subtitle: "Locate churches with a single tap.", image: "contributeBG"),
        (title: "Collaborate", subtitle: "Join ministries, volunteer, and make an impact together.", image: "collaborateBG"),
        (title: "Contribute", subtitle: "Easily contribute to a church's financial needs.", image: "contributeBG")
    ]
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<onboardingPages.count, id: \.self) { index in
                OnboardingPage(
                    title: onboardingPages[index].title,
                    subtitle: onboardingPages[index].subtitle,
                    imageName: onboardingPages[index].image,
                    isLastPage: index == onboardingPages.count - 1,
                    currentPage: currentPage,
                    onNext: {
                        if index == onboardingPages.count - 1 {
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            sessionManager.showLogin()
                        } else {
                            currentPage = index + 1
                        }
                    }
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
