import SwiftUI

public struct FlowLayout: Layout {
    
    private let alignment: FlowLayoutAlignment
    
    public init(alignment: FlowLayoutAlignment = .leading) {
        self.alignment = alignment
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxSize = proposal.replacingUnspecifiedDimensions()
        let frames = generateItems(for: subviews, maxWidth: maxSize.width)
            .flatMap(\.items)
            .map(\.frame)
        
        let width = frames.max(by: { $0.maxX < $1.maxX })?.maxX ?? maxSize.width
        let height = frames.max(by: { $0.maxY < $1.maxY })?.maxY ?? maxSize.height
        
        return CGSize(width: width, height: height)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = generateItems(for: subviews, maxWidth: bounds.width)
        for row in rows {
            let frameAdjustment = adjustment(for: row, maxWidth: bounds.width)
            var spacing: CGFloat = 0
            for item in row.items{
                let origin = CGPoint(
                    x: bounds.minX + item.frame.minX + frameAdjustment.origin.x + spacing,
                    y: bounds.minY + item.frame.minY + frameAdjustment.origin.y
                )
                let size = CGSize(
                    width: item.frame.width + frameAdjustment.size.width,
                    height: item.frame.height + frameAdjustment.size.height
                )
                item.view.place(at: origin, proposal: ProposedViewSize(size))
                spacing += frameAdjustment.spacing
            }
        }
    }
    
    private func adjustment(for row: FlowLayoutRow, maxWidth: CGFloat) -> RowAdjustment {
        switch alignment {
        case .leading:
            return .zero

        case .center:
            return RowAdjustment(origin: CGPoint(x: (maxWidth - row.maxX) / 2, y: 0))

        case .trailing:
            return RowAdjustment(origin: CGPoint(x: maxWidth - row.maxX, y: 0))

        case .spaceToFill:
            guard row.items.count >= 2 else { return .zero }
            let spacing = (maxWidth - row.maxX) / (CGFloat(row.items.count - 1))
            return RowAdjustment(spacing: spacing)
            
        case .stretchToFill:
            guard !row.items.isEmpty else { return .zero }
            if row.items.count == 1 {
                return RowAdjustment(size: CGSize(width: maxWidth - row.maxX, height: 0))
            }
            let width = (maxWidth - row.maxX) / (CGFloat(row.items.count))
            return RowAdjustment(size: CGSize(width: width, height: 0), spacing: width)
        }
    }
    
    private func generateItems(for subviews: Subviews, maxWidth: CGFloat) -> [FlowLayoutRow] {
        var items: [FlowLayoutItem] = []
        var origin: CGPoint = .zero
        
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)
            
            let viewFitsHorizontally = (origin.x + viewSize.width) > maxWidth
            if viewFitsHorizontally {
                origin.x = 0
                origin.y += viewSize.height
            }
            
            let viewFrame = CGRect(origin: origin, size: viewSize)
            items.append(FlowLayoutItem(view: view, frame: viewFrame))
            origin.x += viewSize.width
        }
        
        let rows = Dictionary(grouping: items, by: \.frame.minY)
            .map { FlowLayoutRow(items: $0.value) }
        
        return rows
    }
}
