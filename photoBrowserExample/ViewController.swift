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
    
    fileprivate lazy var photos: [HTPhotosModel] = [HTPhotosModel]()
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
        setPhotoModel()
        view.addSubview(collectionView)
    }
    deinit {
        print("viewcontroller 销毁了")
    }

    private func setPhotoModel(){
        for i in 12...21 {
            print(i)
            let photoM = HTPhotosModel()
            photoM.iconName = "icon" + "\(i)"
            photos.append(photoM)
        }
    }
   
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectonCellID, for: indexPath)
        let pictureName = photos[indexPath.item].iconName!
        let imageView =  UIImageView(image: UIImage(named: pictureName))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoBrowserVC = HTPhotoBrowserViewController.init(collectionView, photosModel: photos, index: indexPath)
        photoBrowserVC.showBrowserView(self)
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

