//
//  Models.swift
//  GiaVang_Bac
//
//  Created by Ho Dang Khoa on 18/5/25.
//
import Foundation

struct MihongGoldRate: Decodable, Identifiable {
    var id: String { code }
    let buyingPrice: Int
    let sellingPrice: Int
    let code: String
    let sellChange: Int
    let sellChangePercent: Double
    let buyChange: Int
    let buyChangePercent: Double
    let dateTime: String
}

struct SilverProduct {
    let name: String
    let unit: String
    let buyPrice: String
    let sellPrice: String
    let lastDate: String
    let lastTime: String?
}
