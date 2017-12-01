//
//  waterfallLayout.swift
//  photoBrowserExample
//
//  Created by 魏小庄 on 2017/11/25.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

protocol waterfallLayoutDataSource: class{
    func numberOfCols(_ waterFall: waterfallLayout) -> Int
    func colsheightWithIdx(_ waterFall: waterfallLayout, itemIdx: Int) -> CGFloat
}


class waterfallLayout: UICollectionViewFlowLayout {
    weak var detaSource: waterfallLayoutDataSource?
    
    fileprivate lazy var cellAttris: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var totalHeights: [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
    fileprivate lazy var cols: Int = {
        return self.detaSource?.numberOfCols(self) ?? 2
    }()
    
    
}

extension waterfallLayout{
    // 重新布局
    override func prepare() {
        super.prepare()
        
        // 获取所有cell的个数
        let cellCount = collectionView!.numberOfItems(inSection: 0)
        
        let itemW: CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        // 给每个cell创建一个layoutAttribes
        for i in cellAttris.count..<cellCount{
            let attribs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            // 设置attribs 的frame
            let minH = totalHeights.min()!
            // 取出当前高度最小的
            let minIdx = totalHeights.index(of: minH)!
            
            let itemX: CGFloat = sectionInset.left + (minimumInteritemSpacing + itemW) * CGFloat(minIdx)
            let itemY: CGFloat = minH
            // 高度需外界传入
            guard let itemH: CGFloat = detaSource?.colsheightWithIdx(self, itemIdx: i) else{
                fatalError("please return Index Of height")
            }
            attribs.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            cellAttris.append(attribs)
            // 添加当前的高度
            totalHeights[minIdx] = minH + minimumLineSpacing + itemH
        }
        
    }
    
}

extension waterfallLayout{
    // 返回计算好的所有布局
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttris
    }
    // 返回contentSize
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom - minimumLineSpacing)
    }
}
