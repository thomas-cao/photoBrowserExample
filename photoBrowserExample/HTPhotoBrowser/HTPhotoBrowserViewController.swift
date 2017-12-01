//
//  HTPhotoBrowserViewController.swift
//  photoBrowserExample
//
//  Created by emppu－cao on 2017/11/26.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

private let photoBrowserCellID = "photoBrowserCellID"
class HTPhotoBrowserViewController: UIViewController {

    // MARK: - 属性
    fileprivate var photosModel: [HTPhotosModel]
    fileprivate var index: IndexPath
    fileprivate var photoContentView: UICollectionView
    fileprivate var beganScale: CGFloat = 0.0
    fileprivate var closePageValue: CGFloat = 0.0
    fileprivate lazy var photoBrowserAnomations: HTPhotoBrowserAnomations = HTPhotoBrowserAnomations()
    fileprivate lazy var contentView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
       let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.register(HTPhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellID)
        collection.backgroundColor = UIColor.black
        return collection
    }()
    
    
    init(_ photosContent: UICollectionView, photosModel: [HTPhotosModel], index: IndexPath) {
        self.photosModel = photosModel
        self.index = index
        self.photoContentView = photosContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        // 设置之间的margin
        view.frame.size.width += 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 滑动到当前点击的索引
        contentView.scrollToItem(at: index, at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    deinit {
        print("销毁了")
    }

}

extension HTPhotoBrowserViewController{
    
    fileprivate func  setUpUI(){
        view.addSubview(contentView)
        
    }
}

extension HTPhotoBrowserViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return  photosModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCellID, for: indexPath) as! HTPhotoBrowserCell
        cell.photosModel = photosModel[indexPath.item]
        cell.delegate = self
        return cell
    }
}
//MARK: - cellDelegate
extension HTPhotoBrowserViewController: photoBrowserCellDelegate{
    func closePage(photoBrowserCell: HTPhotoBrowserCell) {
        dismiss(animated: true, completion: nil)
    }
    func photoBrowser(pageDidChange: HTPhotoBrowserCell, scale: CGFloat) {
        contentView.backgroundColor = UIColor(white: 0.0, alpha: scale)
    }
    func photoBrowser(endChange: HTPhotoBrowserCell, isClosePage: Bool) {
        if isClosePage {
            dismiss(animated: true, completion: nil)
        }else{
            contentView.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        }
    }
}


extension HTPhotoBrowserViewController{
    
    // 显示浏览器
  public func showBrowserView(_ parentVC: UIViewController) {
        modalPresentationStyle = .custom
        transitioningDelegate = photoBrowserAnomations
    photoBrowserAnomations.presentDelegate = self
    photoBrowserAnomations.dismassDelegate = self
    photoBrowserAnomations.selectedIdx = index
        parentVC.present(self, animated: true, completion: nil)
    }
    
}

//MARK: - 实现 photoBrowserAnomations 消失时的代理
extension HTPhotoBrowserViewController: animationForDismassDelegate{
    func indexPathForDismassView() -> IndexPath {
        // 获取当前显示的cell
        let currentCell = contentView.visibleCells.first!
        return contentView.indexPath(for: currentCell)!
    }
    func indexPathForCurrentImage() -> UIImageView {
        let currentCell = contentView.visibleCells.first as! HTPhotoBrowserCell
        // 创建图片
        let tempImage = UIImageView()
        tempImage.image = currentCell.photoView.image
        tempImage.frame = currentCell.photoView.frame
        tempImage.center = currentCell.photoView.center
        tempImage.contentMode = UIViewContentMode.scaleAspectFill
        tempImage.clipsToBounds = true
        return tempImage
    }
}


//MARK: - photoContentView 遵守 photoBrowserAnomations present动画
extension HTPhotoBrowserViewController: animationForPresentDelegate{
    func startRect(indePath: IndexPath) -> CGRect {
        if indePath.isEmpty {
            return CGRect.zero
        }
        // 获取当前的cell
        let cell = photoContentView.cellForItem(at: indePath)
        // 转换坐标系
        return photoContentView.convert(cell!.frame, to: UIApplication.shared.keyWindow!)
    }
    
    func endRect(indePath: IndexPath) -> CGRect {
        // 获取当前的image
        let imageName = photosModel[indePath.item].iconName
        var image: UIImage?
        if imageName == nil{
            let imagePath = photosModel[indePath.item].iconPath!
            image = UIImage(contentsOfFile: imagePath)
        }else{
            image = UIImage(named: imageName!)
        }
        let width = UIScreen.main.bounds.width
        let hight = (width / image!.size.width) * image!.size.height
        var y: CGFloat = 0
        if hight > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - hight) * 0.5
        }
        // 计算fame
        return CGRect(x: 0, y: y, width: width, height:hight)
    }
    
    func placeholderImage(indePath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        let imageName = photosModel[indePath.item].iconName
        var image: UIImage?
        if imageName == nil{
            let imagePath = photosModel[indePath.item].iconPath!
            image = UIImage(contentsOfFile: imagePath)
        }else{
            image = UIImage(named: imageName!)
        }
        imageView.image = image
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    
}
