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
   @objc optional  func photoBrowser(pageDidChange: HTPhotoBrowserCell, scale: CGFloat)
    @objc optional func photoBrowser(pageDidBegan: HTPhotoBrowserCell, scale: CGFloat)
   @objc optional func photoBrowser(endChange:HTPhotoBrowserCell)
}

class HTPhotoBrowserCell: UICollectionViewCell {
    
    // MARK: - 懒加载属性
    open lazy var photoView: UIImageView = {
        let imageView = UIImageView()
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePageClick))
        
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    fileprivate lazy var containerView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.maximumZoomScale = 3.5
        scroll.minimumZoomScale = 1.0
        scroll.delegate = self
        return scroll
    }()
    fileprivate var isUpDownScroll: Bool = false
    fileprivate var startPoint: CGPoint = CGPoint.zero
    fileprivate var testNum: CGFloat = 1.0
   weak var delegate: photoBrowserCellDelegate?
    
    //MARK: - 重写模型set方法
    var photosModel: HTPhotosModel?{
        didSet{
            // 重置之前的图片szie
            resetScrollView()
            
            let imageName = photosModel?.iconName
            var image: UIImage?
            if imageName == nil{
                let imagePath = photosModel?.iconPath!
                image = UIImage(contentsOfFile: imagePath!)
            }else{
                image = UIImage(named: imageName!)
            }
           photoView.image = image
            setImagePosition()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        // 添加拖拽手势
        addPanGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 设置UI
extension HTPhotoBrowserCell{
    fileprivate func setUpUI(){
        
        contentView.addSubview(containerView)
        containerView.addSubview(photoView)
        containerView.frame = contentView.bounds
        containerView.frame.size.width -= 15
        photoView.frame = containerView.bounds
        
    }
    
    fileprivate func addPanGesture(){
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureChange(gesture:)))
        pan.delegate = self
       containerView.addGestureRecognizer(pan)
    }
    @objc fileprivate func closePageClick(){
        delegate?.closePage!(photoBrowserCell: self)
    }
    
    @objc fileprivate func panGestureChange(gesture: UIPanGestureRecognizer){
        guard isUpDownScroll, containerView.contentSize.height <= containerView.frame.height else {
            return
        }
        let point = gesture.location(in: contentView)

        if gesture.state == UIGestureRecognizerState.began {
             startPoint = point
        }
        
        if gesture.state == UIGestureRecognizerState.changed {
            let position = photoView.layer.position
            if startPoint.y > point.y{ // 往上滑动
//                photoView.layer.position = CGPoint(x: position.x, y: position.y - testNum)
                print("\(startPoint.y - point.y)")
                
            }else if startPoint.y < point.y{
                let y = position.y - startPoint.y
                
                print("w")
            }
            photoView.layer.position = point
        }
        if gesture.state == UIGestureRecognizerState.ended{
//            delegate?.photoBrowser!(endChange: self)
        }
        
    }
    
}
//MARK: - 计算size
extension HTPhotoBrowserCell{
    fileprivate func setImagePosition(){
        // 获取图片的显示尺寸
        let size = displaySize()
        photoView.frame = CGRect(origin: CGPoint.zero, size: size)
        let screenHeight = UIScreen.main.bounds.height
        // 判断长短图
        if size.height > screenHeight {
            containerView.contentSize = size
        }else{
            let margin = (screenHeight - size.height) * 0.5
            containerView.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0)
        }
    }
    private func displaySize() -> CGSize{
        guard let image = photoView.image else {
            return CGSize(width: 0, height: 0)
        }
        let width = UIScreen.main.bounds.width
        // 获取比例
        let scale = width / image.size.width
        let height = image.size.height * scale
        return CGSize(width: width, height: height)
    }
    
    fileprivate func resetScrollView(){
        containerView.contentInset = UIEdgeInsets.zero
        containerView.contentOffset = CGPoint.zero
        containerView.contentSize = CGSize.zero
        photoView.transform = CGAffineTransform.identity
    }
    
}

extension HTPhotoBrowserCell: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
    // 缩放时调整inset
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var offsetY = (scrollView.frame.height - photoView.frame.height) * 0.5
        offsetY = (offsetY < 0) ? 0 : offsetY
        var offsetX = (scrollView.frame.width - photoView.frame.width) * 0.5
        offsetX = (offsetX < 0) ? 0 : offsetX
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
    }
}

extension HTPhotoBrowserCell: UIGestureRecognizerDelegate{
   
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        isUpDownScroll = false
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self){
          let panGest = gestureRecognizer as! UIPanGestureRecognizer
            let trans = panGest.translation(in: containerView)
            let x = fabsf(Float(trans.x))
            let y = fabsf(Float(trans.y))
            if y > x{ // 上下滑动
                isUpDownScroll = true
                return false
            }else{
                return true
            }
        }
     return true
    }
}

