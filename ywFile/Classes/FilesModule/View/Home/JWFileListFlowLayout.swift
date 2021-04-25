//
//  JWFileListFlowLayout.swift
//  Joywoker_FilesManager
//
//  Created by new_joywoker on 2021/3/30.
//  Copyright © 2021 new_joywoker. All rights reserved.
//

import UIKit

class JWFileListFlowLayout: UICollectionViewFlowLayout {
    
    enum Element {
        case cell
        case sectionHeader
    }
    
    var sectionHeaderHeight: CGFloat = 75
    weak var flowLayoutDelegate: JWFileListFlowLayoutDelegate?
    
    private var contentMaxY: CGFloat = 0
    private var lineSpacing: CGFloat = 0 //行间距
    private var itemSpacing: CGFloat = 0 //列间距
    private var Inset:UIEdgeInsets = .zero //内边距
    private var cache = [Element:[IndexPath:UICollectionViewLayoutAttributes]]()
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }
    
    private var lastSize:CGSize = .zero //存在上一个item size 进行比较
    
    private var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    init(delegate:JWFileListFlowLayoutDelegate) {
        self.flowLayoutDelegate = delegate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func reSet() {
        prepareCache()
        contentMaxY = 0
        lastSize = .zero
        
    }
    
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.sectionHeader] = [IndexPath:UICollectionViewLayoutAttributes]()
        cache[.cell] = [IndexPath:UICollectionViewLayoutAttributes]()
        
    }
    
    override func prepare() {
        super.prepare()
        reSet()
        guard let collectionView = collectionView else { return }
        guard collectionView.numberOfSections != 0 else { return }
        let sections = collectionView.numberOfSections
        
        guard let delegate = flowLayoutDelegate else {
            print("flowLayoutDelegate is nil")
            return
        }
        for section in 0 ..< sections {
            
            
            //处理section header
            
            let sectionInset = delegate.collectionView(collectionView, layout: self, insetForSectionAt: section)
            itemSpacing = delegate.collectionView(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section)
            lineSpacing = delegate.collectionView(collectionView, layout: self, minimumLineSpacingForSectionAt: section)
            let sectionHeaderIndexPath = IndexPath(item: 0, section: section)
            
            let sectionheaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: sectionHeaderIndexPath)
            let sectionHeaderSize = delegate.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: section)
            let sectionFrame = CGRect(x: 0, y: contentMaxY, width: sectionHeaderSize.width, height: sectionHeaderSize.height)
            sectionheaderAttributes.frame = sectionFrame
            sectionheaderAttributes.zIndex = 1024;
            cache[.sectionHeader]?[sectionHeaderIndexPath] = sectionheaderAttributes
            contentMaxY += sectionHeaderSize.height
            
            
            let rows = collectionView.numberOfItems(inSection: section)
            var frame = CGRect(x: sectionInset.left, y: contentMaxY + sectionInset.top, width: 0, height: 0)
            
            for item in 0 ..< rows {
                let indexPath = IndexPath(item: item, section: section)
                
                let size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: indexPath)
                
                if frame.maxX + size.width + itemSpacing > collectionViewWidth  {
                    frame = CGRect(x: sectionInset.left, y: frame.maxY + lineSpacing, width: size.width, height: size.height)
                } else {
                    
                    if size.height != lastSize.height {
                        //当同行两item 高度不一致  换行
                        if lastSize == .zero {
                            frame = CGRect(x: sectionInset.left, y: frame.maxY, width: size.width, height: size.height)
                        } else {
                            frame = CGRect(x: sectionInset.left, y: frame.maxY + lineSpacing, width: size.width, height: size.height)
                        }
                    } else {
                        
                        frame = CGRect(x: frame.maxX + itemSpacing , y: frame.origin.y, width: size.width, height: size.height)
                    }
                }
                
                //                if section == 1 {
                //                }
                lastSize = size
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache[.cell]?[indexPath] = attributes
                //                print(cache[.cell]?[indexPath])
            }
            contentMaxY = frame.maxY + sectionInset.bottom
        }
        if sectionHeadersPinToVisibleBounds  {
            
            layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1))
        }
        print(#function)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentMaxY)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let superArray = super.layoutAttributesForElements(in: rect)
        print(#function)
        print("layoutAttributesForElements:\(rect), offset:\(collectionView!.contentOffset)")
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        for (type, elementInfos) in cache {
            for (_,  attribute) in elementInfos  where attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("\(#function)==\(indexPath)")
        
        return cache[.cell]?[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(#function)
        
        guard sectionHeadersPinToVisibleBounds else {
            return cache[.sectionHeader]?[indexPath]
        }
        guard let layoutAttributes = cache[.sectionHeader]?[indexPath] else { return nil }
        
        print("layoutAttributesForSupplementaryView:\(indexPath.section) \(layoutAttributes.frame)")
        
        if elementKind != UICollectionView.elementKindSectionHeader {
            return layoutAttributes
        }
        guard let boundaries = boundaries(forSection: indexPath.section, attributes: layoutAttributes) else { return layoutAttributes }
        
        guard let collectionView = collectionView else { return layoutAttributes }
        
        let contentOffsetY = collectionView.contentOffset.y
        
        var frameForSupplementaryView = layoutAttributes.frame
        
        if contentOffsetY < boundaries.minimum {
            frameForSupplementaryView.origin.y = boundaries.minimum
        } else if contentOffsetY > boundaries.maximum {
            frameForSupplementaryView.origin.y = boundaries.maximum
        } else {
            frameForSupplementaryView.origin.y = contentOffsetY
        }
        layoutAttributes.frame = frameForSupplementaryView
        
        cache[.sectionHeader]?[indexPath] = layoutAttributes
        
        return cache[.sectionHeader]?[indexPath]
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    func boundaries(forSection section: Int, attributes:UICollectionViewLayoutAttributes) -> (minimum: CGFloat, maximum: CGFloat)? {
        
        var result = (minimum:CGFloat(0.0), maximum:CGFloat(0.0))
        guard let collectionView = collectionView else { return result }
        let numberOfSection = collectionView.numberOfItems(inSection: section)
        guard numberOfSection > 0 else {
            result.minimum = attributes.frame.minY
            return result
        }
        let first = IndexPath(item: 0, section: section)
        let last = IndexPath(item: numberOfSection - 1, section: section)
        guard let delegate = flowLayoutDelegate else { return result }
        let sectionHeaderSize = delegate.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: section)
        if let firstItem = layoutAttributesForItem(at: first),
            let lastItem = layoutAttributesForItem(at: last) {
            
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY
            
            result.minimum -= sectionHeaderSize.height
            result.maximum -= sectionHeaderSize.height
        }
        return result
    }
}

protocol JWFileListFlowLayoutDelegate: class {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    var collectionHeaderView:UIView? { get }
    
    func collectionViewHeaderSize(_ collectionView: UICollectionView, layout collectionViewLayout: JWFileListFlowLayout) -> CGSize
    /**
     
     */
}
