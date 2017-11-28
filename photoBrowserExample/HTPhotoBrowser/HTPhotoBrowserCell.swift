//
//  HTPhotoBrowserCell.swift
//  photoBrowserExample
//
//  Created by emppu－cao on 2017/11/26.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit
@objc
protocol photoBrowserCellDelegate {
   @objc optional func closePage(photoBrowserCell: HTPhotoBrowserCell)
}

class HTPhotoBrowserCell: UICollectionViewCell {
    
    // MARK: - 懒加载属性
    open lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePageClick))
        
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    fileprivate lazy var containerView: UIScrollView = {
       let scroll = UIScrollView()
        return scroll
    }()
    
   weak var delegate: photoBrowserCellDelegate?
    
    
    var photosModel: HTPhotosModel?{
        didSet{
            let imageName = photosModel?.iconName
            var image: UIImage?
            if imageName == nil{
                let imagePath = photosModel?.iconPath!
                image = UIImage(contentsOfFile: imagePath!)
            }else{
                image = UIImage(named: imageName!)
            }
           photoView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}
extension HTPhotoBrowserCell{
    fileprivate func setUpUI(){
        
        contentView.addSubview(containerView)
        containerView.addSubview(photoView)
        containerView.frame = contentView.bounds
        containerView.frame.size.width -= 15
        photoView.frame = containerView.bounds
        
    }
    
    
    @objc fileprivate func closePageClick(){
        delegate?.closePage!(photoBrowserCell: self)
    }
}

