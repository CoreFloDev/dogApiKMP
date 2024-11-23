import Shared
import Combine
import SwiftUI

class ScreenToIos<I: ScreenInput, O: ScreenOutput, N : ScreenNavigation, A:DomainAction, R: DomainResult>: ObservableObject {
    private let screen : Screen<I, O, N, A, R>

    init(screen : Screen<I, O, N, A, R>) {
        self.screen = screen
    }
    
    @Published var content: O? = nil
    
    private var input: ((I) -> Void)? = nil
    
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
    
    func input(inp: I) {
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
