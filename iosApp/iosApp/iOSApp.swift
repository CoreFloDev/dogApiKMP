import SwiftUI
import Common

class IosNavigation: Navigation {
    func startDetailsActivity(id: String) {
        print("coucou opening details screens")
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
    static let shared = IOSAppComponent()
    static let app: AppComponent = InjectAppComponent(nav: { IosNavigation()})
}
