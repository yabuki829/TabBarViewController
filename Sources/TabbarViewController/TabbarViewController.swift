import Foundation
import UIKit


public struct TabColor {
    var textColor:UIColor
    var backgroundColor :UIColor
}
public struct TabContent{
    let view:UIView
    let height:CGFloat
}


open class TabbarViewController:UIViewController {
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize  = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
   
    /// タブの位置
    private var tabIndex = 0
    private var titleList = [String]()
    private var iconList = [String]()
    // menucellを押すとselectedcellを変更するためにアクセスできるように宣言してる
    private var contentCell = TabContentViewCollectionCell()
    var selectedText = TabColor(textColor: .white , backgroundColor: .link)
    var defalultText = TabColor(textColor: .black , backgroundColor: .systemGray5)
    private var views = [UIView]()
    private var contents = [TabContent]()
    //タブにiconが設定されてるかどうか
    private var isTabIconImage = false
   
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.constraints(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                    left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                    right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                    bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        
        
        settingCollectionView()
        views = addViews()
        contents = addContentViews()
       
    }
    private func settingCollectionView(){
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.identifier)
        collectionView.register(TabContentViewCollectionCell.self, forCellWithReuseIdentifier: TabContentViewCollectionCell.identifier)
        collectionView.register(CollectionViewContentCell.self, forCellWithReuseIdentifier:CollectionViewContentCell.identifier)
        collectionView.delegate  = self
        collectionView.dataSource = self
    }

    func setting(_ tabindex:Int ,titleList: [String]){
        self.tabIndex = tabindex
        if tabindex > addContentViews().count || tabindex == views.count-1{
            print("changed the tabIndex to 0")
            self.tabIndex = 0
        }

        
        self.titleList = titleList
    }
    ///　iconListはuiimageのsystemnameを設定してください
    func setting(_ tabindex:Int ,iconList: [String]){
        self.tabIndex = tabindex
        if tabindex > addContentViews().count || tabindex == views.count-1{
            print("changed the tabIndex to 0")
            self.tabIndex = 0
        }
        self.iconList = iconList
        
        
    }
    func addViews() -> [UIView] {
        return views
    }
    func addContentViews() -> [TabContent] {
        return [TabContent]()
    }
    
 

    
    ///タブバーの高さ。デフォルトは30
    func tabHeight() -> CGFloat{
        return 30
    }
    ///タブバーのコンテンツの高さ。デフォルトは200
    func contentViewHeight() -> CGFloat{
        return 200
    }
}

extension TabbarViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if indexPath.row == tabIndex {
          if isTabIconImage {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
              cell.setting(tabIndex, titleList:  titleList,defalutText: defalultText,selectedText: selectedText)
              cell.delegate = self
              return cell
          }
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
          cell.setting(tabIndex, titleList:  titleList,defalutText: defalultText,selectedText: selectedText)
          cell.delegate = self
          
          return cell
      }
      else if indexPath.row == tabIndex+1 {
          contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabContentViewCollectionCell.identifier, for: indexPath) as! TabContentViewCollectionCell
          contentCell.configure(views: views)
          
          return contentCell
      }
      
      if tabIndex > indexPath.row {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewContentCell.identifier , for: indexPath) as! CollectionViewContentCell
          cell.settingView(inView: contents[indexPath.row].view)
          
          return cell
      }
      else{
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewContentCell.identifier , for: indexPath) as! CollectionViewContentCell
          cell.settingView(inView: contents[indexPath.row-2].view)
          
          return cell
      }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count + 2
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tabIndex == indexPath.row {
            var tabheight = tabHeight()
            if tabheight <= 0 { tabheight = 30 }
            
            return CGSize(width: view.frame.width, height: tabheight)
        }
        else if tabIndex+1 == indexPath.row {
            var contentHeight = contentViewHeight()
            if contentHeight <= 0 { contentHeight = 200 }
            
            return CGSize(width:view.frame.width, height: contentHeight)
        }
        else {
            if tabIndex > indexPath.row {
                return CGSize(width: view.frame.width, height: contents[indexPath.row].height)
            }
            else{
                return CGSize(width: view.frame.width, height: contents[indexPath.row-2].height)
            }
          
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension TabbarViewController:reloadDelegate{
    
    internal func reload(indexPath: IndexPath) {
        contentCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
    }
}




class CollectionViewContentCell:UICollectionViewCell {
    static var identifier = "CollectionViewContentCell"
    var view = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func settingView(inView view:UIView){
        print("TabContentCellにviewを設定します")
        contentView.addSubview(view)
        view.constraints(top: contentView.topAnchor, paddingTop: 0,
                    left: contentView.leftAnchor, paddingLeft: 0,
                    right: contentView.rightAnchor, paddingRight: 0,
                    bottom: contentView.bottomAnchor, paddingBottom: 0)
    }
     
}



class MenuCell:UICollectionViewCell ,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    static let identifier = "MenuCell"
    weak var delegate:reloadDelegate? = nil
    private var tabIndex = 0
    private var tabCount = 0
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
        cell.configure(defalt: defaultText!, selected: selectedText!)
        
        if  selectedIndexPath?.row == indexPath.row {
            cell.isSelected = true
           
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width  / CGFloat(titleList.count), height: frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        delegate?.reload(indexPath: indexPath)
    }
    func setting(_ tabindex:Int,titleList: [String],defalutText:TabColor,selectedText:TabColor){
        self.tabIndex = tabindex
        self.titleList = titleList
        self.defaultText = defalutText
        self.selectedText = selectedText
    }
}





protocol reloadDelegate: AnyObject  {
    func reload(indexPath:IndexPath)
}

class TabCell:UICollectionViewCell{
    static let identifier = "tabCell"
    
    var selectedColor:TabColor?
    var defalutColor:TabColor?
    override var isSelected: Bool{
          didSet{
              backgroundColor = isSelected ? selectedColor?.backgroundColor : defalutColor?.backgroundColor
              titleLabel.textColor = isSelected ? selectedColor?.textColor : defalutColor?.textColor
          }
      }
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
    
    func configure(defalt:TabColor,selected:TabColor){
        selectedColor = selected
        defalutColor = defalt
        titleLabel.textColor = defalutColor?.textColor
        backgroundColor = defalutColor?.backgroundColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class TabContentViewCollectionCell:UICollectionViewCell,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate{
    static let identifier = "TabContentViewCollectionCell"
    var views = [UIView]()
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        layout.estimatedItemSize  = UICollectionViewFlowLayout.automaticSize
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.isScrollEnabled = false
        return collecitonview
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.backgroundColor = .white
        collectionView.register(TabbarCollectionViewCell.self, forCellWithReuseIdentifier: TabbarCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabbarCollectionViewCell.identifier, for: indexPath) as! TabbarCollectionViewCell
        
        cell.setView(inView: views[indexPath.row])
        return cell
    }
    
    func configure(views:[UIView]){
        self.views = views
        collectionView.center(inView: self)
        collectionView.sizing(height: self.frame.height,width: self.frame.width)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
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





