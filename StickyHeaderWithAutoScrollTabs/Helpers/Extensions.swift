//
//  Extensions.swift
//  StickyHeaderWithAutoScrollTabs
//
//  Created by Vikash Anand on 05/12/23.
//

import SwiftUI

extension [Product] {
    var type: ProductType {
        if let firstProduct = self.first {
            return firstProduct.type
        }
        return .iPhone
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offset(_ coordinatedSpace: AnyHashable, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay (
                GeometryReader {
                    let rect = $0.frame(in: .named(coordinatedSpace))
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            )
    }
}
