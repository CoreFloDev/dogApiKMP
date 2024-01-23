import SwiftUI
import Shared


class IosNavigation: Navigation, ObservableObject {
    @Published var nav: [Details] = []
    
    func startDetailsActivity(id: String) {
        DispatchQueue.main.async {
            self.nav.append(Details(id: id))
        }
    }
}

struct Details: Hashable {
    let id: String
}

@main
struct iOSApp: App {

    init() {
        let iosNav = IosNavigation()
        self.nav = iosNav
        self.app = InjectAppComponent(nav: { iosNav })
        
        nav.$nav.sink { content in
            print("coucou data", content.self)
        }
    }

    @State var app: AppComponent
    @ObservedObject var nav: IosNavigation

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $nav.nav) {
                ListView(app: app)
                    .navigationDestination(for: Details.self) { details in
                        DetailsView(id: details.id, app: app)
                    }
            }
        }
    }
}
