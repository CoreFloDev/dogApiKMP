import SwiftUI
import Shared
import Combine

struct ListView: View {

    init(app: AppComponent) {
        self.vm = ListViewModel(app: app)
    }
    @ObservedObject private var vm: ListViewModel
    
    var body: some View {
        VStack {
            if let content = vm.content {
                switch onEnum(of: content) {
                case .loading:
                    ProgressView()
                case .retry:
                    Button(action: { vm.input(inp: ListInput.RetryClicked()) }) {
                        Text("retry")
                    }
                case .display(let res):
                    List {
                        ForEach(res.list, id: \.id) { item in
                                VStack {
                                    AsyncImage(
                                        url: URL(string: item.image)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: 300, maxHeight: 100)
                                            case .failure:
                                                Image(systemName: "photo")
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(maxWidth: 300, maxHeight: 100)
                                    Text(item.name)
                                }.onTapGesture {
                                    vm.input(inp: ListInput.PictureClicked(id: item.id))
                                }
                        }
                    }
                }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisappear() }
    }
}

#Preview {
    ListView(app: InjectAppComponent(nav: { IosNavigation() }))
}

class ListViewModel: ObservableObject {
    private let screen : Screen<ListInput, any ListOutput, ListNavigation, Action_, Result_>

    init(app: AppComponent) {
        self.screen = InjectListComponent(appComponent: app).screen
    }
    
    @Published var content: ListOutput? = nil
    
    private var input: ((ListInput) -> Void)? = nil
    
    func onAppear() {
        let attach = screen.attach()
        let nav = attach.navigation
        let output = attach.output
        input = attach.input
        
        Task {
            for await aout in output {
                DispatchQueue.main.async {
                    self.content = aout
                }
            }
        }
        
        Task {
            for await _ in nav {
                // subscribed
            }
        }
    }
    
    func input(inp: ListInput) {
        guard let constant = input else { return }
        constant(inp)
    }
    
    func onDisappear() {
        screen.detach()
    }
    
    deinit {
        screen.terminate()
    }
}
