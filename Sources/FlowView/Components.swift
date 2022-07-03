import Foundation
import SwiftUI

struct FlowLayoutRow {
    let items: [FlowLayoutItem]
    
    var maxX: CGFloat { items.map(\.frame.maxX).max() ?? 0 }
}

struct FlowLayoutItem {
    let view: LayoutSubview
    let frame: CGRect
}

struct RowAdjustment {
    let origin: CGPoint
    let size: CGSize
    let spacing: CGFloat
    
    init(origin: CGPoint = .zero, size: CGSize = .zero, spacing: CGFloat = .zero) {
        self.origin = origin
        self.size = size
        self.spacing = spacing
    }
    
    static var zero: Self {
        RowAdjustment()
    }
}

public enum FlowLayoutAlignment {
    case leading, center, trailing, spaceToFill, stretchToFill
}
