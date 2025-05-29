//
//  ContentView.swift
//  GiaVang_Bac
//
//  Created by Ho Dang Khoa on 18/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var goldRates: [EximbankGoldRate] = []
    @State private var silverRates: [SilverProduct] = []

    var body: some View {
        ScrollView {
            Text("Giá Vàng Eximbank")
                .font(.title)
                .padding(.top)

            ForEach(goldRates, id: \.QUOTETM) { rate in
                ProductCardView(title: rate.Cur_NameVN.replacingOccurrences(of: "<br />", with: ""),
                                buy: rate.TTBUYRT,
                                sell: rate.TTSELLRT,
                                updated: rate.QUOTETM,
                                source: .eximbank)
            }

            Text("Giá Bạc Phú Quý")
                .font(.title)
                .padding(.top)

            ForEach(silverRates, id: \.name) { silver in
                ProductCardView(
                    title: silver.name,
                    buy: silver.buyPrice,
                    sell: silver.sellPrice,
                    updated: silver.lastDate,               // chỉ truyền ngày
                    source: .phuquy(time: silver.lastTime)  // truyền giờ đúng
                )
            }

        }
        .onAppear {
            GoldService().fetchLatestGoldRate { self.goldRates = $0 }
            SilverService().fetchSilverPrices { self.silverRates = $0 }
        }
    }
}
