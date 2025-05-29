//
//  ProductCardView.swift
//  GiaVang_Bac
//
//  Created by Ho Dang Khoa on 29/5/25.
//
import Foundation
import SwiftSoup
import SwiftUI

struct ProductCardView: View {
    let title: String
    let buy: String
    let sell: String
    let updated: String
    let source: SourceType  // 👈 Thêm nguồn

    enum SourceType {
        case eximbank
        case phuquy(time: String?)
    }

    var formattedTime: String {
        switch source {
        case .eximbank:
            return formatEximbankDateTime(updated)
        case .phuquy(let time):
            return formatPhuQuyDateTime(date: updated, time: time)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            HStack {
                Text("Mua: \(formatPrice(buy))")
                    .foregroundColor(.green)
                Spacer()
                Text("Bán: \(formatPrice(sell))")
                    .foregroundColor(.red)
            }
            .font(.subheadline)
            .bold()

            Text("Cập nhật: \(formattedTime)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 4))
        .padding(.horizontal)
    }
}


// Eximbank: ISO 8601 format
func formatEximbankDateTime(_ isoDate: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime]

    guard let date = isoFormatter.date(from: isoDate) else {
        return "Không rõ thời gian"
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm - dd/MM/yyyy"
    return formatter.string(from: date)
}

// Phú Quý: Chỉ có ngày (dd/MM/yyyy) + giờ có thể hard-code hoặc kèm theo
func formatPhuQuyDateTime(date: String, time: String?) -> String {
    let finalTime = time ?? "--:--"
    return "\(finalTime) - \(date)"
}


func formatPrice(_ priceString: String) -> String {
    guard let doubleValue = Double(priceString) else { return priceString }

    let intValue = Int(doubleValue) // Lấy phần nguyên, bỏ phần thập phân
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "," // dùng dấu phẩy
    formatter.maximumFractionDigits = 0

    return formatter.string(from: NSNumber(value: intValue)) ?? "\(intValue)"
}
