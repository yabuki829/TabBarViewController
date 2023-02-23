//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2023/01/03.
//

import Foundation
import UIKit



public class TabContentViewCell:UITableViewCell,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate{
    static let identifier = "TabContentViewCell"
    var views = [UIView]()
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        layout.estimatedItemSize  = UICollectionViewFlowLayout.automaticSize
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.isScrollEnabled = false
        return collecitonview
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.register(TabbarCollectionViewCell.self, forCellWithReuseIdentifier: TabbarCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        collectionView.constraints(top: contentView.topAnchor, paddingTop: 0,
                                   left: contentView.leftAnchor, paddingLeft: 0,
                                   right: contentView.rightAnchor, paddingRight: 0,
                                   bottom: contentView.bottomAnchor, paddingBottom: 0)
        
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return views.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabbarCollectionViewCell.identifier, for: indexPath) as! TabbarCollectionViewCell
        
        cell.setView(inView: views[indexPath.row])
        return cell
    }
    
    func configure(views:[UIView]){
        self.views = views
      
        collectionView.reloadData()
       
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

class TabbarCollectionViewCell:UICollectionViewCell{
    static let identifier = "TabbarCollectionViewCell"
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setView(inView view:UIView){
        contentView.addSubview(view)
        view.center(inView: view)
        view.sizing(height: self.frame.height,width: self.frame.width)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// TODO- 今後制約コード書き直す
extension UIView{
    public func constraints(top: NSLayoutYAxisAnchor? = nil,paddingTop: CGFloat = 0,
                left: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,paddingRight: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,paddingBottom: CGFloat = 0,
                height: CGFloat? = nil,width: CGFloat? = nil) {
    
        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let height = height{
            sizing(height: height)
        }
        if let width = width {
            sizing(width:width)
        }
       
    }
    public func sizing(height: CGFloat? = nil,width: CGFloat? = nil){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        
    }
    public func center(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    public func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor = topAnchor, let padding = paddingTop  {
            self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }

    public func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingleft: CGFloat? = nil, constant: CGFloat? = 0) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true

        if let leftAnchor = leftAnchor, let padding = paddingleft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    public func removeConstraint(){
        removeConstraints(constraints)
    }
}





