//
//  AddCoopView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI
import PhotosUI

struct AddCoopView: View {
    @StateObject var vm: CoopsViewModel
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var showImagePreview: UIImage?
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            BackgroundView()
                .onTapGesture {
                        isFocused = false
                }
            VStack(spacing: 20) {
                TextField("Title Coop", text: $vm.simpleTitleCoop)
                    .padding()
                    .background {
                        Color.grayApp.cornerRadius(8)
                    }
                    .focused($isFocused)
                
                PhotosPicker(selection: $selectedImageItem, matching: .images) {
                    if let showImagePreview = showImagePreview {
                        Image(uiImage: showImagePreview)
                            .resizable()
                            //.scaledToFit()
                            .frame(width: 250 , height: 250)
                            .cornerRadius(20)
                    } else {
                        Label("Select Photo", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.grayApp)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                Button {
                    vm.addCoop()
                    dismiss()
                } label: {
                    GreenButtonView(title: "Save")
                        .opacity(vm.simpleTitleCoop.isEmpty ? 0.5 : 1)
                }
                .disabled(vm.simpleTitleCoop.isEmpty)
            }
            .padding()
            .onChange(of: selectedImageItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        vm.selectedImage = uiImage
                        showImagePreview = uiImage
                    }
                }
            }
        }
        .onDisappear(perform: {
            vm.clearData()
        })
        .navigationTitle("New Coop")
    }
}

#Preview {
    NavigationStack {
        AddCoopView(vm: CoopsViewModel())
    }
}
