import SwiftUI
import ComposableArchitecture
import PrinciplesFeatureInterface

@main
struct PrinciplesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Principles Feature Preview")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Tap the button below to test the principles flow")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Start Principles Flow") {
                        // This will be handled by the coordinator
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Spacer()
                    
                    // Direct preview of the principles view
                    PrinciplesView(store: .init(
                        initialState: PrinciplesFeature.State(),
                        reducer: {
                            PrinciplesFeature(coordinator: DefaultPrinciplesCoordinator(navigationController: UINavigationController()))
                        }
                    ))
                    .frame(maxHeight: 600)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                }
                .navigationTitle("Principles Demo")
            }
        }
    }
}