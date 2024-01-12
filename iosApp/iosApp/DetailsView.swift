import SwiftUI
import Shared

struct DetailsView: View {
    
    @ObservedObject private var vm : DetailsViewModel
    
    init(id: String, app: AppComponent) {
        self.vm = DetailsViewModel(imageId: id, app: app)
    }
    
    var body: some View {
        VStack {
            if let content = vm.content {
                switch onEnum(of: content.uiState) {
                case.loading:
                    ProgressView()
                case .retry:
                    Button(action: { vm.input(inp: DetailsInput.RetryClicked()) }) {
                        Text("retry")
                    }
                case .display(let res):
                    Text(res.name)
                    AsyncImage(
                        url: URL(string: res.image)) { phase in
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
                    Text(res.origin)
                    Text(res.temperament)
                    Text(res.wikiUrl)
                    Spacer()
                }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisappear() }
    }
}

#Preview {
    DetailsView(id: "SkmRJl9VQ", app: InjectAppComponent(nav: { IosNavigation() }))
}

class DetailsViewModel: ObservableObject {
    private let screen: Screen<DetailsInput, DetailsOutput, DetailsNavigation, Action, Result>

    init(imageId: String, app: AppComponent) {
        self.screen = InjectDetailsComponent(appComponent: app, imageId: imageId).screen
    }

    @Published var content: DetailsOutput? = nil
    
    private var input: ((DetailsInput) -> Void)? = nil

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
    
    func input(inp: DetailsInput) {
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
