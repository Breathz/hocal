import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var showImageSource = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Image
                Button(action: {
                    showImageSource = true
                }) {
                    ZStack {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 120, height: 120)
                    }
                }
                .padding(.top, 40)
                
                // User Name
                if let user = userManager.currentUser {
                    Text(user.username)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    // User Age
                    Text("\(Calendar.current.dateComponents([.year], from: user.birthDate, to: Date()).year ?? 0) years old")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Stats
                    HStack(spacing: 40) {
                        VStack {
                            Text("Communities")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(user.communities)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        VStack {
                            Text("Messages")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(user.messages)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 30)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .background(AppSettings.Colors.darkGreen)
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
            ImagePicker(image: $profileImage, sourceType: sourceType)
        }
    }
} 