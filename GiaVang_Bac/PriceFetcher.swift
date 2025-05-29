//
//  PriceFetcher.swift
//  GiaVang_Bac
//
//  Created by Ho Dang Khoa on 18/5/25.
//
import Foundation
import SwiftSoup // Đảm bảo bạn đã import thư viện

class GoldService {
    func fetchLatestGoldRate(completion: @escaping ([EximbankGoldRate]) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateStr = formatter.string(from: Date())

        var latestRates: [EximbankGoldRate] = []
        var currentCNT = 1

        func fetchNextQuoteCNT() {
            let urlStr = "https://eximbank.com.vn/api/front/v1/gold-rate?strNoticeday=\(dateStr)&strBRCD=1000&strQuoteCNT=\(currentCNT)"
            guard let url = URL(string: urlStr) else { return }

            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(latestRates) // Nếu lỗi => trả về cái trước đó
                    }
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode([EximbankGoldRate].self, from: data)
                    if decoded.isEmpty {
                        // Không còn bảng mới => trả về bảng cuối có dữ liệu
                        DispatchQueue.main.async {
                            completion(latestRates)
                        }
                    } else {
                        latestRates = decoded
                        currentCNT += 1
                        fetchNextQuoteCNT() // Thử bảng kế tiếp
                    }
                } catch {
                    // Nếu lỗi decode => dùng dữ liệu gần nhất
                    DispatchQueue.main.async {
                        completion(latestRates)
                    }
                }
            }.resume()
        }

        fetchNextQuoteCNT()
    }
}

class SilverService {
    func fetchSilverPrices(completion: @escaping ([SilverProduct]) -> Void) {
        guard let url = URL(string: "https://giabac.phuquygroup.vn") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let html = String(data: data, encoding: .utf8),
                  error == nil else {
                completion([])
                return
            }

            do {
                let doc = try SwiftSoup.parse(html)

                // 🔹 Lấy ngày và giờ cập nhật
                let date = try doc.select("#update-datetime .date").first()?.text() ?? "??/??/????"
                let time = try doc.select("#update-datetime .time").first()?.text()

                // 🔹 Parse từng dòng giá bạc
                let rows = try doc.select("#priceListContainer table tbody tr")
                var products: [SilverProduct] = []

                for row in rows {
                    let cols = try row.select("td")

                    // Chỉ xử lý dòng có đủ 4 cột (sản phẩm thực)
                    if cols.count == 4 {
                        let name = try cols[0].text().trimmingCharacters(in: .whitespacesAndNewlines)
                        let unit = try cols[1].text()
                        let buy = try cols[2].text()
                        let sell = try cols[3].text()

                        let product = SilverProduct(
                            name: name,
                            unit: unit,
                            buyPrice: buy,
                            sellPrice: sell,
                            lastDate: date,
                            lastTime: time
                        )

                        products.append(product)
                    }
                }

                DispatchQueue.main.async {
                    completion(products)
                }
            } catch {
                print("HTML parse error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}
