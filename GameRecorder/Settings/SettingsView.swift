//
//  SettingsView.swift
//   GameRecorder
//
//  Created by ovidio morisano on 25/02/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewModel.saveSettings()
                } label: {
                    Text("Save")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding([.trailing, .top], 60)
            .padding(.top, 20)
            PitchSliderView(pitch: $viewModel.currentPitch )
                .padding([.leading, .trailing], 40)
            SoundEffectListView(viewModel: viewModel)
                .padding(.top, 50)
        }
        
    }
}

struct PitchSliderView: View {
    @State private var isEditing = false
    @Binding var pitch: Float

    var body: some View {
        VStack {
            HStack {
                Text("Pitch")
                    .font(.headline)
                Spacer()
            }
            Slider(
                value: $pitch,
                in: -2400...2400,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            Text(String(pitch.formatted(.number.precision(.fractionLength(1)))))
                .foregroundColor(isEditing ? .red : .blue)
        }
    }
}

struct SoundEffectListView: View {
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            List() {
                ForEach(0..<viewModel.soundEffectList.count) { index in
                    SoundEffectRowView(soundEffect: viewModel.soundEffectList[index]) {
                        viewModel.updateSelectedSoundEffect(atInded: index)
                    }
                }
            }
        }
    }
}

struct SoundEffectRowView: View {
    var soundEffect: SoundEffect
    var onSelected: () -> Void
    var body: some View {
        Button {
            onSelected()
        } label: {
            HStack {
                Text(soundEffect.name)
                    .font(.body)
                    .bold()
                Spacer()
                if soundEffect.isSelected {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                }
            }
            .padding([.leading, .trailing], 10)
            .frame(height: 50)
            .shadow(radius: 20)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
