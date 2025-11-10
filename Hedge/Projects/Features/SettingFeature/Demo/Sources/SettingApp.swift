import SwiftUI

import SettingFeature

@main
struct SettingApp: App {
    var body: some Scene {
        WindowGroup {
            SettingView(viewModel: SettingViewModel())
        }
    }
}
