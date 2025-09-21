import SwiftUI
import TradeHistoryFeature
import DesignKit

@main
struct TradeHistoryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TradeHistoryInputView(image: HedgeUI.search, stockTitle: "종목명", description: "얼마에 매도하셨나요?")
        }
    }
}
