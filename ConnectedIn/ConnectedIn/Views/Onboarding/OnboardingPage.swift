import SwiftUI

struct OnboardingPage: View {
    var title: String
    var subtitle: String
    var imageName: String
    var isLastPage: Bool
    var currentPage: Int
    var onNext: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image that covers the entire screen
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                
                // Content
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Text content at the bottom
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 4)
                        
                        Text(subtitle)
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(index == currentPage ? Color.connectedInMain : .white)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Button
                    Button(action: onNext) {
                        Text(isLastPage ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.connectedInMain)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 32)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? geometry.safeAreaInsets.bottom + 24 : 48)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
