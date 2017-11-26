//
//  ViewController.swift
//  photoBrowserExample
//
//  Created by emppu－cao on 2017/11/25.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

private let collectonCellID = "collectonCellID"
class ViewController: UIViewController {
    
    fileprivate lazy var collectionView : UICollectionView = {

        let layout = waterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.scrollDirection = .vertical
        layout.detaSource = self
    
        let frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
       let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectonCellID)
        collection.backgroundColor = .white
      return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectonCellID, for: indexPath)
        let pictureName = "icon" + "\(indexPath.item + 1)"
        let imageView =  UIImageView(image: UIImage(named: pictureName))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        return cell
    }
}

extension ViewController: waterfallLayoutDataSource{
    
    func colsheightWithIdx(_ waterFall: waterfallLayout, itemIdx: Int) -> CGFloat {
        return  130//CGFloat(arc4random_uniform(120) + 100)
    }
    func numberOfCols(_ waterFall: waterfallLayout) -> Int {
        return 3
    }
}

