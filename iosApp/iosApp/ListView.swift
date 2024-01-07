import SwiftUI
import Shared
import Combine

struct ListView: View {
    @ObservedObject private var vm = ListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch onEnum(of: vm.content) {
                case .loading:
                    Text("loading")
                case .retry:
                    Text("Retry")
                case .display(let res):
                    List {
                        ForEach(res.list, id: \.id) { item in
                            VStack {
                                Text(item.name)
                                AsyncImage(url: URL(string: item.image))
                            }
                        }
                    }
                case nil:
                    Text("null")
                }
            }
            .navigationTitle("Dog list")
        }
        .onAppear{
            Task {
                await vm.onAppear()
            }
        }
        .onDisappear(perform: {
            vm.onDisappear()
        })
    }
}

#Preview {
    ListView()
}

class ListViewModel: ObservableObject {
    private let screen = InjectListComponent(appComponent: IOSAppComponent.app).screen

    @Published var content: ListOutput? = nil

    func onAppear() async {
        let attach = screen.attach()
        let nav = attach.navigation
        let output = attach.output
        let input = attach.input

        for await aout in output {
            content = aout
        }
    }

    func onDisappear() {
        screen.detach()
    }

    deinit {
        screen.terminate()
    }
}
