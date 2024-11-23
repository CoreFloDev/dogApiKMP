import SwiftUI
import Combine
import Shared

struct BaseView<Content, I: ScreenInput, O: ScreenOutput, N : ScreenNavigation, A:DomainAction, R: DomainResult>: View where Content: View {
    private let content:  (O, @escaping (I) -> Void) -> Content
    
    @ObservedObject private var vm: ScreenToIos<I, O, N, A, R>
    
    public init(vm: ScreenToIos<I, O, N, A, R>, @ViewBuilder content: @escaping (O, @escaping (I) -> Void) -> Content) {
        self.content = content
        self.vm = vm
    }
    
    var body : some View {
        ZStack {
            let output = vm.content
            if (output != nil) {
                content(output!, { input in vm.input(inp: input) })
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear{ vm.onDisappear() }
    }
}
