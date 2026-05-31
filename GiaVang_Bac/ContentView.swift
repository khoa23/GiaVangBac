import SwiftUI

struct ContentView: View {
    @State private var goldRates: [MihongGoldRate] = []
    @State private var silverRates: [SilverProduct] = []

    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Dark Background
                LinearGradient(
                    colors: [Color(red: 0.05, green: 0.05, blue: 0.08), Color(red: 0.1, green: 0.1, blue: 0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Decorative blurred circles for Glassmorphism effect
                Circle()
                    .fill(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: -100, y: -200)
                
                Circle()
                    .fill(Color(red: 0.85, green: 0.85, blue: 0.9).opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: 150, y: 300)

                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Header spacer
                        Spacer().frame(height: 10)
                        
                        // Gold Section
                        if !goldRates.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeaderView(title: "VÀNG MI HỒNG", icon: "crown.fill", color: Color(red: 1.0, green: 0.84, blue: 0.0))
                                
                                ForEach(goldRates) { rate in
                                    ProductCardView(
                                        title: rate.code,
                                        buy: String(rate.buyingPrice),
                                        sell: String(rate.sellingPrice),
                                        updated: rate.dateTime,
                                        source: .mihong,
                                        buyChange: rate.buyChange,
                                        buyChangePercent: rate.buyChangePercent,
                                        sellChange: rate.sellChange,
                                        sellChangePercent: rate.sellChangePercent
                                    )
                                }
                            }
                        }

                        // Silver Section
                        if !silverRates.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeaderView(title: "BẠC PHÚ QUÝ", icon: "sparkles", color: Color(red: 0.85, green: 0.85, blue: 0.9))
                                
                                ForEach(silverRates, id: \.name) { silver in
                                    ProductCardView(
                                        title: silver.name,
                                        buy: silver.buyPrice,
                                        sell: silver.sellPrice,
                                        updated: silver.lastDate,
                                        source: .phuquy(time: silver.lastTime)
                                    )
                                }
                            }
                            .padding(.top, 16)
                        }
                        
                        // Bottom spacer
                        Spacer().frame(height: 30)
                    }
                }
            }
            .navigationTitle("Tỷ Giá Hôm Nay")
            // Apply dark color scheme so default text is white
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        refreshData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .onAppear {
                refreshData()
            }
        }
    }
    
    private func refreshData() {
        // Optional: you can add a print or a loading state here if needed in the future
        GoldService().fetchLatestGoldRate { self.goldRates = $0 }
        SilverService().fetchSilverPrices { self.silverRates = $0 }
    }
}

struct SectionHeaderView: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18, weight: .bold))
            }
            Text(title)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
