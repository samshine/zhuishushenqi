//
//  SwipableCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/18.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol SwipableCellDelegate {
    func delete(model:BookDetail)
}

class SwipableCell: UITableViewCell,UIScrollViewDelegate {

    var delegate:SwipableCellDelegate?
    var model:BookDetail?{
        didSet{
            title!.text = model?.title
            
            let created = model?.updateInfo?.updated ?? "2014-02-23T16:48:18.179Z"
            self.detailTitle?.qs_setCreateTime(createTime: created, append: "更新：\(model?.updateInfo?.lastChapter ?? "")")
            let urlString = "\(self.model?.cover ?? "")"
            self.imgView?.qs_setBookCoverWithURLString(urlString: urlString)
        }
    }
    
    var imgView: UIImageView?
    var title:UILabel?
    
    var detailTitle:UILabel?

    private var scrollView:UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSubview(){
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 64))
        scrollView.contentSize = CGSize(width: (ScreenWidth - 74)*2, height: 64)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        //此处解决 UIScrollView屏蔽 UITableViewCell的点击事件，将 scrollView的手势识别交给他的父视图，苹果官方推荐的做法,但是这样回造成UIScrollView上的button无法点击，本次使用第二种方式，传递事件
//        scrollView.isUserInteractionEnabled = false
//        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        let imgView = UIImageView(frame: CGRect(x: 15, y: 10, width: 34, height: 44))
        imgView.backgroundColor = UIColor.orange
        imgView.image = UIImage(named: "default_book_cover")
        self.imgView = imgView
        
        let label = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 10,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        label.font = UIFont.systemFont(ofSize: 13)
        self.title = label
        
        let detaillabel = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 30,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        detaillabel.font = UIFont.systemFont(ofSize: 13)

        self.detailTitle = detaillabel
        
        
        scrollView.addSubview(self.imgView!)
        scrollView.addSubview(self.title!)
        scrollView.addSubview(self.detailTitle!)
        
        let delete:UIButton = UIButton(type: .custom)
        delete.frame = CGRect(x: scrollView.contentSize.width - 65, y: 17, width: 50, height: 30)
        delete.setTitle("删除", for: .normal)
        delete.setTitleColor(UIColor.red, for: .normal)
        delete.addTarget(self, action: #selector(deleteAction(btn:)), for: .touchUpInside)
        scrollView.addSubview(delete)
    }
    
    @objc func deleteAction(btn:UIButton){
        delegate?.delete(model: self.model!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(scrollView.contentOffset.x)
//        let offSetX = scrollView.contentOffset.x
//        if offSetX > (ScreenWidth - 74)/4 {
//            scrollView.setContentOffset(CGPointMake(ScreenWidth - 74, 0), animated:true)
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

extension UIScrollView{
    //2.解决UIScrollView屏蔽UITableViewCell的点击事件
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let next = touches.first?.view?.next?.next
        if next?.isKind(of: UITableViewCell.self) == true {
            next?.touchesBegan(touches, with: event)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let next = touches.first?.view?.next?.next
        if next?.isKind(of: UITableViewCell.self) == true {
            next?.touchesEnded(touches, with: event)
        }
    }
}
