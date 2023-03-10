//
//  MainMenuView.swift
//   GameRecorder
//
//  Created by ovidio morisano on 25/02/23.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject var viewModel: MainMenuViewModel
    var body: some View {
        ZStack {
            Spacer()
            Text(viewModel.gameCategory.rawValue)
                .font(.largeTitle)
                .foregroundColor(.red)
                .bold()
                .padding(.bottom, 400)
            Spacer()
            VStack {
                HStack {
                    OptionsButton(showSettings: $viewModel.settingsVisible) {
                        viewModel.openSettings()
                    }
                    .transition(.move(edge: .top))
                    Spacer()
                }
                .padding(20)
                Spacer()
            }
            VStack {
                HStack {
                    Spacer()
                    if viewModel.gameCategory == .TimeAttack {
                        TogglesView(viewModel: viewModel)
                    }
                }
                .padding(20)
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    ArrowView(leftSide: true) {
                        viewModel.updateCategory()
                    }
                    Spacer()
                    ArrowView(leftSide: false) {
                        viewModel.updateCategory()
                    }
                }
                .padding([.leading, .trailing], 20)
                Spacer()
                MainMenuButton(menuHudVisibile: $viewModel.menuHudVisibile) {
                    viewModel.playGame()
                }
                .transition(.move(edge: .bottom))
                
            }
        }
    }
}

struct TogglesView: View {
    @ObservedObject var viewModel: MainMenuViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Record screen:")
                Toggle("", isOn: $viewModel.recorderStatusToggle)
                    .labelsHidden()
                    .onChange(of: viewModel.recorderStatusToggle) { newValue in
                        viewModel.recorderStatusToggleUpdate()
                    }
            }
        }
    }
}

struct ArrowView: View {
    var radius: CGFloat = 70
    var leftName = "arrow.left.circle.fill"
    var rightName = "arrow.right.circle.fill"
    var buttonName: String
    var onButtonTap: (() -> Void)?
    
    init(leftSide: Bool, onButtonTap: (() -> Void)?) {
        buttonName = leftSide ? leftName : rightName
        self.onButtonTap = onButtonTap
    }
    var body: some View {
        Button {
            withAnimation(.linear) {
                onButtonTap?()
            }
        } label: {
            Image(systemName: buttonName)
                .resizable()
                .frame(width: radius * 0.8, height: radius * 0.8)
                .foregroundColor(.white)
        }
        .buttonStyle(BlueButtonStyle(radius: radius))
        
    }
}

struct MainMenuButton: View {
    @Binding var menuHudVisibile: Bool
    var playAction: () -> Void
    var radius: CGFloat = 100
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    menuHudVisibile.toggle()
                    playAction()
                }
            }) {
                Image(systemName: "play")
                    .resizable()
                    .frame(width: radius * 0.4, height: radius * 0.4)
                    .padding(.leading, 5)
            }
            .buttonStyle(BlueButtonStyle(radius: radius))
        }
    }
}

struct OptionsButton: View {
    @Binding var showSettings: Bool
    var onButtonTap: (() -> Void)?
    var radius: CGFloat = 50
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showSettings.toggle()
                    onButtonTap?()
                }
            }) {
                Image(systemName: "slider.vertical.3")
                    .resizable()
                    .frame(width: radius * 0.4, height: radius * 0.4)
            }
            .buttonStyle(BlueButtonStyle(radius: radius))
        }
    }
}


struct BlueButtonStyle: ButtonStyle {
    var radius: CGFloat
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: radius, height: radius)
            .foregroundColor(configuration.isPressed ? .blue : .white)
            .background(
                RadialGradient(colors: [.blue, .white], center: .center, startRadius: 0, endRadius: 200)
            )
            .clipShape(Circle())
            .shadow(color: .gray, radius: configuration.isPressed ? 0 : 3, x: 0, y: 2)
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
            )

    }
}


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: MainMenuViewModel())
    }
}
