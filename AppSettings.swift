import SwiftUI

struct AppSettings {
    // MARK: - Layout Constants
    struct Layout {
        // Minimum touch target size per Apple HIG
        static let minimumTouchTargetSize: CGFloat = 44
        
        // Standard padding values
        static let standardPadding: CGFloat = 16
        static let tightPadding: CGFloat = 8
        static let loosePadding: CGFloat = 24
        
        // Standard corner radius
        static let cornerRadius: CGFloat = 8
    }
    
    // MARK: - Typography
    struct Typography {
        // Minimum text size for legibility
        static let minimumTextSize: CGFloat = 11
        
        // Standard line spacing
        static let standardLineSpacing: CGFloat = 1.2
        
        // Standard letter spacing
        static let standardLetterSpacing: CGFloat = 0.5
    }
    
    // MARK: - Colors
    struct Colors {
        // App theme colors
        static let primary = Color.accentColor
        static let secondary = Color.gray
        
        // Text colors for different backgrounds
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        
        // Background colors
        static let backgroundPrimary = Color(UIColor.systemBackground)
        static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
        
        // Custom colors
        static let darkGreen = Color(hex: "#013220")
        
        // New color for onboarding
        static let beigeBrown = Color(hex: "#D4C19C")
    }
    
    // MARK: - Animation
    struct Animation {
        static let standardDuration: Double = 0.3
        static let standardCurve: SwiftUI.Animation = .easeInOut
    }
    
    // MARK: - Image
    struct Image {
        // Standard image scales for Retina displays
        static let scales: [CGFloat] = [2, 3]
        
        // Maximum image dimensions
        static let maxWidth: CGFloat = UIScreen.main.bounds.width
        static let maxHeight: CGFloat = UIScreen.main.bounds.height
    }
}

// MARK: - View Modifiers
extension View {
    func standardPadding() -> some View {
        self.padding(AppSettings.Layout.standardPadding)
    }
    
    func standardTouchTarget() -> some View {
        self.frame(minWidth: AppSettings.Layout.minimumTouchTargetSize,
                  minHeight: AppSettings.Layout.minimumTouchTargetSize)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
