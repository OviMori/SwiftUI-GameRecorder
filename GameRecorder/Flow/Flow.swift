//
//  Flow.swift
//   GameRecorder
//
//  Created by ovidio morisano on 06/03/23.
//

import SwiftUI

struct Flow<Content>: View where Content: View {
    @Binding var next: Bool
    var content: Content
    
    init(next: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._next = next
        self.content = content() //in teoria qua avviene la creazione della view. Chiedere conferma
    }
    var body: some View {
        NavigationLink(destination: VStack {
            content
                .navigationBarBackButtonHidden(true)
        }, isActive: $next) {
            EmptyView()
        }
    }
}
