import SwiftUI

struct WelcomeView: View {
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 20)
            
            VStack(spacing: 10) {
                Text("CareerExplore")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                Text("Discover careers. Find your path.")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)
            
            ZStack {
                // Playful animated symbols
                HStack(spacing: 24) {
                    AnimatedSymbol(name: "sparkles", color: .yellow, animate: $animate)
                    AnimatedSymbol(name: "graduationcap.fill", color: .blue, animate: $animate)
                    AnimatedSymbol(name: "pencil.and.ruler.fill", color: .pink, animate: $animate)
                    AnimatedSymbol(name: "lightbulb.fill", color: .orange, animate: $animate)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 80)
            
            VStack(spacing: 12) {
                Text("Ready to explore?")
                    .font(.title3.weight(.semibold))
                NavigationLink {
                    IndustrySelectionView()
                } label: {
                    Label("Get Started", systemImage: "arrow.right.circle.fill")
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .accessibilityLabel("Get Started")
                .accessibilityHint("Opens the list of industries to explore")
                
                Text("No internet needed. Learn at your own pace.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

private struct AnimatedSymbol: View {
    let name: String
    let color: Color
    @Binding var animate: Bool
    
    var body: some View {
        Image(systemName: name)
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(color)
            .scaleEffect(animate ? 1.1 : 0.9)
            .opacity(animate ? 1.0 : 0.7)
            .symbolRenderingMode(.multicolor)
            .accessibilityHidden(true)
    }
}

#Preview {
    NavigationStack { WelcomeView() }
}
