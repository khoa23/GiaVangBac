import Foundation
import SwiftSoup
import SwiftUI

struct ProductCardView: View {
    let title: String
    let buy: String
    let sell: String
    let updated: String
    let source: SourceType
    
    var buyChange: Int? = nil
    var buyChangePercent: Double? = nil
    var sellChange: Int? = nil
    var sellChangePercent: Double? = nil

    enum SourceType {
        case mihong
        case phuquy(time: String?)
    }

    var formattedTime: String {
        switch source {
        case .mihong:
            return updated
        case .phuquy(let time):
            return formatPhuQuyDateTime(date: updated, time: time)
        }
    }

    var themeColor: Color {
        switch source {
        case .mihong:
            return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold color
        case .phuquy:
            return Color(red: 0.85, green: 0.85, blue: 0.9) // Silver color
        }
    }

    var themeIcon: String {
        switch source {
        case .mihong:
            return "crown.fill"
        case .phuquy:
            return "sparkles"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header: Title and Icon
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: themeIcon)
                    .foregroundColor(themeColor)
                    .font(.system(size: 22))
                    .shadow(color: themeColor.opacity(0.6), radius: 5, x: 0, y: 0)
            }
            
            // Prices Layout
            HStack(spacing: 16) {
                // Buy Price
                VStack(alignment: .leading, spacing: 6) {
                    Text("MUA VÀO")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(formatPrice(buy))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .shadow(color: .green.opacity(0.3), radius: 4, x: 0, y: 0)
                        
                    if let buyP = buyChangePercent, let buyC = buyChange {
                        ChangeView(change: buyC, percent: buyP)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Vertical divider
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 1, height: 60)
                
                // Sell Price
                VStack(alignment: .trailing, spacing: 6) {
                    Text("BÁN RA")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(formatPrice(sell))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                        .shadow(color: .red.opacity(0.3), radius: 4, x: 0, y: 0)
                        
                    if let sellP = sellChangePercent, let sellC = sellChange {
                        ChangeView(change: sellC, percent: sellP)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Footer: Timestamp
            HStack {
                Image(systemName: "clock.fill")
                    .font(.system(size: 10))
                Text("Cập nhật: \(formattedTime)")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(.white.opacity(0.5))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
        // Glassmorphism background
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        // Subtle gradient border
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [themeColor.opacity(0.6), themeColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        // Shadow for elevation
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
        .padding(.horizontal)
    }
}

struct ChangeView: View {
    let change: Int
    let percent: Double
    
    var isPositive: Bool { change >= 0 }
    var color: Color { isPositive ? .green : .red }
    var icon: String { isPositive ? "arrow.up.right" : "arrow.down.right" }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
            
            // Avoid double negative sign for text
            let changeText = isPositive ? "+\(formatPrice(String(change)))" : formatPrice(String(change))
            Text("\(changeText) (\(String(format: "%.2f", percent))%)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .cornerRadius(6)
        .foregroundColor(color)
    }
}

// Phú Quý: Chỉ có ngày (dd/MM/yyyy) + giờ có thể hard-code hoặc kèm theo
func formatPhuQuyDateTime(date: String, time: String?) -> String {
    let finalTime = time ?? "--:--"
    return "\(finalTime) - \(date)"
}


func formatPrice(_ priceString: String) -> String {
    let cleanString = priceString.replacingOccurrences(of: "-", with: "")
    guard let doubleValue = Double(cleanString) else { return priceString }

    let intValue = Int(doubleValue)
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.maximumFractionDigits = 0

    let sign = priceString.hasPrefix("-") ? "-" : ""
    return sign + (formatter.string(from: NSNumber(value: intValue)) ?? "\(intValue)")
}
