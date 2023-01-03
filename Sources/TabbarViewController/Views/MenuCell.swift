//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2023/01/03.
//

import Foundation
import UIKit



class MenuCell:UICollectionViewCell ,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    static let identifier = "MenuCell"
    weak var delegate:reloadDelegate? = nil
    private var tabIndex = 0
    private var tabCount = 0
    private var isScrollable = false
    
    private var titleList = [String]()
    var selectedIndexPath: IndexPath?
    
    
    var selectedText: TabColor?
    var defaultText: TabColor?
    private let underlineView: UIView = {
         let view = UIView()
         return view
     }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.dataSource = self
        collecitonview.delegate = self
        collecitonview.isScrollEnabled = false
        return collecitonview
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(collectionView)
        collectionView.center(inView: self)
        collectionView.sizing(height: self.frame.height,width: self.frame.width)
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: TabCell.identifier)
        
        
        
        let indexPath:IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.selectedIndexPath = indexPath
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.identifier, for: indexPath) as! TabCell
        cell.titleLabel.text = titleList[indexPath.row]
        cell.configure(defalt: defaultText!, selected: selectedText!,height:frame.height,isScrollable: isScrollable)
        
        if  selectedIndexPath?.row == indexPath.row {
            cell.isSelected = true
           
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isScrollable {
            return 10
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isScrollable {
            
            var value = 18
    
            if isAlphanumeric(str: titleList[indexPath.row]) {
                value = 13
            }
            else {
                //文字数が15文字超えたら, valueを15で計算する
                if titleList[indexPath.row].count > 15{ value = 15}
            }

            let width = CGFloat(value * titleList[indexPath.row].count)
            
            return CGSize(width:width, height: frame.height )
        }
        
        return CGSize(width:collectionView.frame.width  / CGFloat(titleList.count), height: frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        delegate?.reload(indexPath: indexPath)
    }
    func setting(_ tabindex:Int,titleList: [String],defalutText:TabColor,selectedText:TabColor,isScrollable:Bool){
        self.tabIndex = tabindex
        self.titleList = titleList
        self.defaultText = defalutText
        self.selectedText = selectedText
        self.isScrollable = isScrollable
        if isScrollable{
            collectionView.isScrollEnabled = true
        }
        else{
            collectionView.isScrollEnabled = false
        }
    }
    ////アルファベットのみで構成されているかどうか
    private func isAlphanumeric(str:String) -> Bool{
        
        guard str != "" else { return false }
        if str.range(of:"[^a-zA-Z0-9]", options: .regularExpression) == nil {
            return true
        }
        return false
    }
}


class TabCell:UICollectionViewCell{
    static let identifier = "tabCell"
    
    private var selectedColor:TabColor?
    private var defalutColor:TabColor?
    private var isScrollable = false
    override var isSelected: Bool{
          didSet{
            if isScrollable {
                titleLabel.textColor = isSelected ? selectedColor?.textColor : defalutColor?.textColor
                titleLabel.backgroundColor = isSelected ? selectedColor?.backgroundColor : defalutColor?.backgroundColor
            }
            else{
                backgroundColor = isSelected ? selectedColor?.backgroundColor : defalutColor?.backgroundColor
                titleLabel.textColor = isSelected ? selectedColor?.textColor : defalutColor?.textColor
            }
        }
    }
    var titleLabel: SSPaddingLabel = {
        let label = SSPaddingLabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.systemGray3.cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.constraints(top: contentView.topAnchor, paddingTop: 0,
                          left: contentView.leftAnchor, paddingLeft: 0,
                          right: contentView.rightAnchor, paddingRight: 0,
                          bottom: contentView.bottomAnchor, paddingBottom: 0)
    }
    
    func configure(defalt:TabColor,selected:TabColor,height:CGFloat,isScrollable:Bool){
        selectedColor = selected
        defalutColor = defalt
        titleLabel.textColor = defalutColor?.textColor
        titleLabel.layer.cornerRadius = height / 2
        backgroundColor = defalutColor?.backgroundColor
        self.isScrollable = isScrollable
        
        if isScrollable {
            backgroundColor = .white
        }
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
