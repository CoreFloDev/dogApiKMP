import SwiftUI
import Shared

struct ListView: View {
    @State private var showContent = false
    
    // @StateObject
    private static var screen = InjectListComponent(appComponent: IOSAppComponent.app)
    
    var body: some View {
        NavigationView {
            VStack {
            
            }
            .navigationTitle("Dog list")
        }
    }
}

#Preview {
    ListView()
}
