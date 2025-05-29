//
//  Models.swift
//  GiaVang_Bac
//
//  Created by Ho Dang Khoa on 18/5/25.
//
import Foundation

struct EximbankGoldRate: Decodable {
    let Cur_NameVN: String
    let TTBUYRT: String
    let TTSELLRT: String
    let QUOTETM: String
}

struct SilverProduct {
    let name: String
    let unit: String
    let buyPrice: String
    let sellPrice: String
    let lastDate: String
    let lastTime: String?
}
