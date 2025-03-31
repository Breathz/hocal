import SwiftUI

struct AddCommunityView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var communityManager: CommunityManager
    @State private var communityName = ""
    @State private var selectedState = USState.CA  // Default to California
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showImageSource = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationView {
            ZStack {
                AppSettings.Colors.darkGreen.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Image Selection
                        Button(action: {
                            showImageSource = true
                        }) {
                            ZStack {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                } else {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 200, height: 200)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        // Input Fields
                        VStack(spacing: 20) {
                            // Community Name Field
                            HStack {
                                TextField("", text: $communityName)
                                    .placeholder(when: communityName.isEmpty) {
                                        Text("Community Name").foregroundColor(.white.opacity(0.7))
                                    }
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .padding(.leading, 12)
                            }
                            
                            // State Picker
                            Menu {
                                Picker("State", selection: $selectedState) {
                                    ForEach(USState.allCases, id: \.self) { state in
                                        Text(state.rawValue)
                                            .foregroundColor(.white)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedState.rawValue)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Create Button
                        Button(action: {
                            handleCreate()
                        }) {
                            Text("Create Community")
                                .font(.headline)
                                .foregroundColor(AppSettings.Colors.darkGreen)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("New Community")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .confirmationDialog("Choose Photo", isPresented: $showImageSource) {
            Button("Take Photo") {
                sourceType = .camera
                showImagePicker = true
            }
            Button("Choose from Library") {
                sourceType = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: sourceType)
        }
    }
    
    private func handleCreate() {
        guard let username = userManager.currentUser?.username else { return }
        
        if communityManager.addCommunity(
            name: communityName,
            state: selectedState.rawValue,  // Use the state's full name
            creatorUsername: username,
            image: selectedImage
        ) {
            dismiss()
        }
    }
}

// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .multilineTextAlignment(.center)
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .foregroundColor(.white)
    }
}

// Placeholder modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
} 