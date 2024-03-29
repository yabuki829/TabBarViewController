//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2023/01/03.
//

import Foundation
import UIKit



class MenuCell:UITableViewCell ,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    static let identifier = "MenuCell"
    weak var delegate:reloadDelegate? = nil
    private var tabIndex = 0
    private var tabCount = 0
    private var isScrollable = false
    
    private var tabs = [TabTag]()
    var selectedIndexPath: IndexPath?
    var preselectedIndexPath: IndexPath?
    
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
        collecitonview.showsVerticalScrollIndicator = false
        collecitonview.showsHorizontalScrollIndicator = false
        return collecitonview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
       
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: TabCell.identifier)
        collectionView.constraints(top: contentView.topAnchor, paddingTop: 0,
                                   left: contentView.leftAnchor, paddingLeft: 0,
                                   right: contentView.rightAnchor, paddingRight: 0,
                                   bottom: contentView.bottomAnchor, paddingBottom: 0)
        
       
        let indexPath:IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        // 一個前に選択していた選択肢を覚えておく
        self.selectedIndexPath = indexPath
        self.preselectedIndexPath = indexPath
        
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: self.selectedIndexPath, animated: true, scrollPosition: .left)
        }
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.identifier, for: indexPath) as! TabCell
        if tabs[indexPath.row].isButton {
            cell.titleButton.setTitle(tabs[indexPath.row].title, for: .normal)
            cell.configureButton(defalt: defaultText!, selected: selectedText!, height: frame.height, isScrollable: self.isScrollable )
        }
        else {
            cell.titleLabel.text = String()
            
            cell.titleLabel.text = tabs[indexPath.row].title
            cell.configure(defalt: defaultText!, selected: selectedText!, height: frame.height, isScrollable: self.isScrollable )
        }
        
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
            var value = 20
            // アルファベットのみかどうか判別
            if isAlphanumeric(str: self.tabs[indexPath.row].title) {
                value = 13
            }
            else {
                //今後修正する
                // 使えるデータは文字数のみ
            if self.tabs[indexPath.row].title.count >= 30 {
                    value = 12
                }
                else if self.tabs[indexPath.row].title.count >= 25 {
                    value = 14
                }
                else if self.tabs[indexPath.row].title.count >= 20 {
                    value = 15
                }
                else if self.tabs[indexPath.row].title.count >= 15{
                    value = 15
                }
                else if self.tabs[indexPath.row].title.count >= 10 {
                    value = 16
                }
                else if self.tabs[indexPath.row].title.count >= 5 {
                    value = 18
                }
                
            }
            // 8文字の時
            // 18 * 8 =  144
            // 18 * 10 = 180
            var width = CGFloat(value * self.tabs[indexPath.row].title.count)
            
            
            
            
            // 最低でもheightの大きさにする
            if width  < frame.height {
                width = frame.height
            }
            return CGSize(width:width, height: frame.height )
        }
        
        return CGSize(width:collectionView.frame.width  / CGFloat(tabs.count), height: frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.preselectedIndexPath = self.selectedIndexPath
        selectedIndexPath = indexPath
        delegate?.reload(indexPath: indexPath)
        
        // 押したのがボタンであればtappedTabButtonを呼ぶ
        if tabs[indexPath.row].isButton {
            delegate?.tapped(indexPath: indexPath)
        }
        
    }
    
   func setting(_ tabindex:Int,tabs: [TabTag],defalutText:TabColor,selectedText:TabColor,isScrollable:Bool,insets:UIEdgeInsets){
    
        self.tabIndex = tabindex
        self.tabs = tabs
        self.defaultText = defalutText
        self.selectedText = selectedText
        self.isScrollable = isScrollable
       collectionView.contentInset = insets
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
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.systemGray3.cgColor
        label.layer.borderWidth = 0.5
        label.clipsToBounds = true
        label.text = "エラー"
        return label
    }()
    
    var titleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.borderWidth = 0.5
        button.clipsToBounds = true
        button.setTitle("エラー", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleButton)
        titleLabel.constraints(top: contentView.topAnchor, paddingTop: 0,
                          left: contentView.leftAnchor, paddingLeft: 0,
                          right: contentView.rightAnchor, paddingRight: 0,
                          bottom: contentView.bottomAnchor, paddingBottom: 0)
        
        titleButton.constraints(top: contentView.topAnchor, paddingTop: 0,
                          left: contentView.leftAnchor, paddingLeft: 0,
                          right: contentView.rightAnchor, paddingRight: 0,
                          bottom: contentView.bottomAnchor, paddingBottom: 0)
        
        
        
    }
    
    func configure(defalt:TabColor,selected:TabColor,height:CGFloat,isScrollable:Bool){
        titleButton.isHidden = true
        titleLabel.isHidden = false
        selectedColor = selected
        defalutColor = defalt
        titleLabel.textColor = defalutColor?.textColor
//        titleLabel.layer.cornerRadius = height / 2
        
        backgroundColor = defalutColor?.backgroundColor
        titleLabel.backgroundColor = defalutColor?.backgroundColor
        self.isScrollable = isScrollable
        
        if isScrollable {
            backgroundColor = .systemBackground
        }
       
    }
    func configureButton(defalt:TabColor,selected:TabColor,height:CGFloat,isScrollable:Bool){
        titleLabel.isHidden = true
        titleButton.isHidden = false
        selectedColor = selected
        defalutColor = defalt
        titleButton.setTitleColor(defalutColor?.textColor, for: .normal)
        titleButton.layer.cornerRadius = height / 2
        backgroundColor = defalutColor?.backgroundColor
        
        self.isScrollable = isScrollable
        if isScrollable {
            backgroundColor = .systemBackground
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
