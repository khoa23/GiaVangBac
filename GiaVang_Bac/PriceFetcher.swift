//
//  PriceFetcher.swift
//  GiaVang_Bac
//
//  Created by Ho Dang Khoa on 18/5/25.
//
import Foundation
import SwiftSoup // Đảm bảo bạn đã import thư viện

class GoldService {
    func fetchLatestGoldRate(completion: @escaping ([MihongGoldRate]) -> Void) {
        guard let url = URL(string: "https://api.mihong.vn/v1/gold-prices?market=domestic") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([MihongGoldRate].self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                print("Decode error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
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
