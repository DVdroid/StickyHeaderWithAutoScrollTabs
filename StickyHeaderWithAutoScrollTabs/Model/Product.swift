//
//  Product.swift
//  StickyHeaderWithAutoScrollTabs
//
//  Created by Vikash Anand on 05/12/23.
//

import Foundation

struct Product: Identifiable, Hashable {
    var id: UUID = .init()
    var type: ProductType
    var title: String
    var subTitle: String
    var price: String
    var productImage: String = ""
}

enum ProductType: String, CaseIterable {
    case iPhone = "iPhone"
    case iPad = "iPad"
    case macbook = "MacBook"
    case desktop = "Mac Desktop"
    case appleWatch = "Apple Watch"
    case airpods = "Airpods"
    
    var tabId: String {
        self.rawValue + self.rawValue.prefix(4)
    }
}

var products: [Product] = [
    //Apple Watch
    .init(type: .appleWatch, title: "Apple Watch", subTitle: "Ultra: Black", price: "$999", productImage: "Apple_Watch_Ultra"),
    .init(type: .appleWatch, title: "Apple Watch", subTitle: "Series 9: Black", price: "$599", productImage: "Apple_Watch_9"),
    .init(type: .appleWatch, title: "Apple Watch", subTitle: "SE: Black", price: "$250", productImage: "Apple_Watch_SE"),
    //iPhone
    .init(type: .iPhone, title: "iPhone 14 Pro Max", subTitle: "A16 - Purple", price: "$1299", productImage: "iphone14_Pro_Max"),
    .init(type: .iPhone, title: "iPhone 13", subTitle: "A15 - Pink", price: "$699", productImage: "iphone_13"),
    .init(type: .iPhone, title: "iPhone 12", subTitle: "A14 - Purple", price: "$599", productImage: "iphone_12"),
    .init(type: .iPhone, title: "iPhone 11", subTitle: "A13 - Purple", price: "$499", productImage: "iphone_11"),
    //MacBook
    .init(type: .macbook, title: "MacBook Pro 16", subTitle: "M2 Max - Silver", price: "$2499", productImage: "MacBook_Pro_16"),
    .init(type: .macbook, title: "MacBook Pro", subTitle: "M1 - Space Grey", price: "$1299", productImage: "MacBook_Pro"),
    .init(type: .macbook, title: "iPhone 12", subTitle: "M1 - Gold", price: "$999", productImage: "MacBook_Air"),
    //iPad
    .init(type: .iPad, title: "iPad Pro", subTitle: "M1 - Silver", price: "$999", productImage: "iPad_Pro"),
    .init(type: .iPad, title: "iPad Air 4", subTitle: "A14 - Pink", price: "$699", productImage: "iPad_Air_4"),
    .init(type: .iPad, title: "ipad Mini", subTitle: "A15 - Grey", price: "$599", productImage: "iPad_Mini"),
    //Desktop
    .init(type: .desktop, title: "Mac Studio", subTitle: "M1 Max - Silver", price: "$1999", productImage: "mac_studio"),
    .init(type: .desktop, title: "Mac Mini", subTitle: "M2 Pro - Space Grey", price: "$999", productImage: "iMac"),
    .init(type: .desktop, title: "iMac", subTitle: "M1 - Purple", price: "$1599", productImage: "mac_mini"),
    //Desktop
    .init(type: .airpods, title: "Airpods", subTitle: "Pro 2nd Gen", price: "$249", productImage: "airpods-pro"),
    .init(type: .airpods, title: "Airpods", subTitle: "3rd Gen", price: "$179", productImage: "airpod3"),
    .init(type: .airpods, title: "Airpods", subTitle: "2nd Gen", price: "$129", productImage: "airpod2")
]
