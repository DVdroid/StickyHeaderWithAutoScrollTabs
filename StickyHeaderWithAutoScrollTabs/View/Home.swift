//
//  Home.swift
//  StickyHeaderWithAutoScrollTabs
//
//  Created by Vikash Anand on 05/12/23.
//

import SwiftUI

enum StickyHeaderImplemaetionType {
    case lazyVStack
    case vStack
}

struct Home: View {
    @State private var activeTab: ProductType = .iPhone
    @Namespace private var animation
    @State private var productsBasedOnTypes: [[Product]] = []
    @State private var animationProgress: CGFloat = 0.0
    @State private var scrollableTabOffset: CGFloat = 0
    @State private var initialTabOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                getBodyView(proxy, type: .vStack)
            }
            .offset("CONTENTVIEW") {
                initialTabOffset = $0.minY
            }
            .safeAreaInset(edge: .top) {
                scrollableTabs(proxy)
                    .offset(y: scrollableTabOffset > 0 ? scrollableTabOffset : 0)
            }
        }
        .coordinateSpace(name: "CONTENTVIEW")
        .navigationTitle("Apple Store")
        .background(
            Rectangle()
                .fill(Color("BG"))
                .ignoresSafeArea()
        )
        .onAppear {
            guard  productsBasedOnTypes.isEmpty else { return }
            for type in ProductType.allCases {
                let products = products.filter { $0.type == type }
                productsBasedOnTypes.append(products)
            }
        }
    }
    
    @ViewBuilder
    private func getBodyView(_ proxy: ScrollViewProxy, type: StickyHeaderImplemaetionType) -> some View {
        Group {
            switch type {
            case .lazyVStack:
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(productsBasedOnTypes, id: \.self) { products in
                            getProductSectionView(products)
                        }
                    } header: {
                        scrollableTabs(proxy)
                    }
                }
            case .vStack:
                VStack(spacing: 15) {
                    ForEach(productsBasedOnTypes, id: \.self) { products in
                        getProductSectionView(products)
                    }
                }
                .offset("CONTENTVIEW") { rect in
                    scrollableTabOffset = rect.minY - initialTabOffset
                }
            }
        }
    }
    
    @ViewBuilder
    private func getProductSectionView(_ products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            if let firstProduct = products.first {
                Text(firstProduct.type.rawValue)
                    .font(.title)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
            }
            
            ForEach(products) { product in
                getProductRowView(product)
            }
        }
        .padding(15)
        .id(products.type)
        .offset("CONTENTVIEW") { rect in
            let minY = rect.minY
            if (minY < 30 && -minY < (rect.midY / 2) && activeTab != products.type) && animationProgress == 0.0 {
                withAnimation(.easeOut(duration: 0.3)) {
                    activeTab = (minY < 30 && -minY < (rect.midY / 2) && activeTab != products.type) 
                    ? products.type
                    : activeTab
                }
            }
        }
    }
    
    @ViewBuilder
    private func getProductRowView(_ product: Product) -> some View {
        HStack(spacing: 15) {
            Image(product.productImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white)
                )
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.title3)
                    .foregroundColor(.black)
                Text (product.subTitle)
                    .font(.callout)
                    .foregroundColor(.gray)
                Text (product.price)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor (Color("Purple"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func scrollableTabs(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ProductType.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .background(alignment: .bottom, content: {
                            if activeTab == type {
                                Capsule()
                                    .fill(.white)
                                    .frame(height: 5)
                                    .padding(.horizontal, -5)
                                    .offset(y: 15)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        })
                        .padding(.horizontal, 15)
                        .contentShape(Rectangle())
                        .id(type.tabId)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                activeTab = type
                                animationProgress = 1.0
                                proxy.scrollTo(type, anchor: .topLeading)
                            }
                        }
                }
            }
            .padding(.vertical, 15)
            .onChange(of: activeTab) { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newValue.tabId, anchor: .center)
                }
            }
            .checkAnimationEnd(for: animationProgress) {
                animationProgress = 0.0
            }
        }
        .background {
            Rectangle()
                .fill(Color("Purple"))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
        }
    }
}

#Preview {
   ContentView()
}

extension View {
    @ViewBuilder
    func checkAnimationEnd<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> ()) -> some View {
        self
            .modifier(AnimationEndCallback(for: value, onEnd: completion))
    }
}
fileprivate struct AnimationEndCallback<Value: VectorArithmetic>: Animatable, ViewModifier {
    
    var animatableData: Value {
        didSet {
            checkIfFinished()
        }
    }
    
    var endValue: Value
    var onEnd: () -> ()
    
    init(for value: Value, onEnd: @escaping () -> Void) {
        self.animatableData = value
        self.endValue = value
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    private func checkIfFinished() {
        if endValue == animatableData {
            DispatchQueue.main.async {
                onEnd()
            }
        }
    }
}
