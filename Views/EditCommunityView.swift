import SwiftUI

struct EditCommunityView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var communityManager: CommunityManager
    let community: Community
    @Binding var isPresented: Bool
    
    @State private var name: String
    @State private var selectedState: USState
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showImageSource = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    init(communityManager: CommunityManager, community: Community, isPresented: Binding<Bool>) {
        self.communityManager = communityManager
        self.community = community
        self._isPresented = isPresented
        self._name = State(initialValue: community.name)
        self._selectedState = State(initialValue: USState.allCases.first { $0.rawValue == community.state } ?? .CA)
        self._selectedImage = State(initialValue: community.image)
    }
    
    private var canEdit: Bool {
        userManager.currentUser?.username == community.creatorUsername
    }
    
    var body: some View {
        NavigationView {
            Group {
                if canEdit {
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
                                    TextField("Community Name", text: $name)
                                        .textFieldStyle(CustomTextFieldStyle())
                                    
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
                            }
                        }
                    }
                    .navigationTitle("Edit Community")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                isPresented = false
                            }
                            .foregroundColor(.white)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                communityManager.updateCommunity(
                                    community,
                                    newName: name,
                                    newState: selectedState.rawValue,
                                    newImage: selectedImage
                                )
                                isPresented = false
                            }
                            .foregroundColor(.white)
                        }
                    }
                } else {
                    VStack {
                        Text("You don't have permission to edit this community")
                            .foregroundColor(.white)
                            .padding()
                        
                        Button("Go Back") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .background(AppSettings.Colors.darkGreen)
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
} 