import SwiftUI
import ComposableArchitecture
import PrinciplesFeatureInterface
import PrinciplesFeature
import StockDomainInterface

@main
struct PrinciplesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
            }
        }
    }
}
