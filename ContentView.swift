//
//  ContentView.swift
//   GameRecorder
//
//  Created by ovidio morisano on 16/02/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        ZStack {
            FlowView(viewModel: FlowViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

