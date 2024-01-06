import SwiftUI
import Shared

class IosNavigation: Navigation {
    func startDetailsActivity(id: String) {
        print("coucou opening detail screen")
    }
}

@main
struct iOSApp: App {

	var body: some Scene {
		WindowGroup {
			ListView()
		}
	}
}

class IOSAppComponent {
    static let app: AppComponent = InjectAppComponent(nav: { IosNavigation()})
}
