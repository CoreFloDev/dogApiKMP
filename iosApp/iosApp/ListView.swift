import SwiftUI
import Common
import FeatureList

struct ListView: View {
    @State private var showContent = false
    
    // @StateObject
    private static var screen = InjectListComponent(appComponent: IOSAppComponent.app as CommonAppComponent)
    
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
