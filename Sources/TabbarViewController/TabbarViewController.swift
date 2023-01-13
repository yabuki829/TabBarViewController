import Foundation
import UIKit

public struct TabColor {
    public var textColor:UIColor
    public var backgroundColor :UIColor
}
public struct TabContent{
    let view:UIView
    let height:CGFloat
    
    public init(view:UIView,height:CGFloat){
        self.view = view
        self.height = height
    }
}



open class UITabbarViewController:UIViewController {
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize  = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        return cv
    }()
   
    /// タブの位置
    private var tabIndex = 0
    private var tabs = [TabTag]()
    private var iconList = [String]()
    private var isScrollable = false
    
    // menucellを押すとselectedcellを変更するためにアクセスできるように宣言してる
    private var contentCell = TabContentViewCollectionCell()
    public var selectedText = TabColor(textColor: .white , backgroundColor: .link)
    public var defalultText = TabColor(textColor: .black , backgroundColor: .systemGray5)
    private var views = [UIView]()
    private var contents = [TabContent]()
    private var menuCell: MenuCell?
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
        
       
    }
    private func settingCollectionView(){
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.identifier)
        collectionView.register(TabContentViewCollectionCell.self, forCellWithReuseIdentifier: TabContentViewCollectionCell.identifier)
        collectionView.register(CollectionViewContentCell.self, forCellWithReuseIdentifier:CollectionViewContentCell.identifier)
        collectionView.delegate  = self
        collectionView.dataSource = self
    }
    
    ///isScroltableをtrueにすると名前の通りスクロールできるようになる。
    ///isScroltableのデフォルトはfalse
    open func setting(_ tabindex:Int ,tabs: [TabTag],isScroltable:Bool = false){
        self.tabIndex = tabindex
        self.isScrollable = isScroltable
        if tabindex > addContentViews().count || tabindex == views.count{
            print("changed the tabIndex to 0")
            self.tabIndex = 0
        }

        
        self.tabs = tabs
        views = addViews()
        contents = addContentViews()
    }
    ///　iconListにはuiimageのsystemnameを設定してください
    open func setting(_ tabindex:Int ,iconList: [String]){
        self.tabIndex = tabindex
        if tabindex > addContentViews().count || tabindex == views.count{
            print("changed the tabIndex to 0")
            self.tabIndex = 0
        }
        self.iconList = iconList
        views = addViews()
        contents = addContentViews()
        
    }
    
    /// テーブルビューのコンテント
    open func addViews() -> [UIView] {
        return views
    }
    /// タブのコンテント
    open func addContentViews() -> [TabContent] {
        return [TabContent]()
    }
    
    
    open func reloadCollectionView(){
        collectionView.reloadData()
    }
    
    open func reloadTabCell(_ tabindex:Int ,tabs: [TabTag],isScroltable:Bool = false){
        //menucellの情報を更新する
        menuCell?.setting(tabindex, tabs: tabs, defalutText: defalultText, selectedText: selectedText, isScrollable: isScroltable)
        menuCell?.collectionView.reloadData()
    }
    
    ///タブバーの高さ。デフォルトは30
    open func tabHeight() -> CGFloat{
        return 30
    }
    ///タブバーのコンテンツの高さ。デフォルトは200
    open func contentViewHeight() -> CGFloat{
        return 200
    }
    ///タップしたボタンのindexPathを返す
    ///if indexPath.row == 0 { do someting }
    ///- Parameters:
    /// - indexPath:タップされたボタンのindexPath
    open func tappedTabButton(indexPath:IndexPath){}
    /// 選択中のtabのindexを返す
    open func getSelectedTagIndex() -> Int{
        return menuCell?.selectedIndexPath?.row ?? 0
    }
    
    open func moveZeroIndexPath(){
        let indexPath = IndexPath(row: 0, section: 0)
        
        menuCell?.selectedIndexPath = indexPath
        // ベストは消したセルの一個前のセルを選択すること
        DispatchQueue.main.async {
            self.menuCell?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        contentCell.configure(views: views)
        contentCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
    }
    open func moveLastIndexPath(){
        let indexPath = IndexPath(row: addViews().count, section: 0)
        menuCell?.selectedIndexPath = indexPath
        // ベストは消したセルの一個前のセルを選択すること
        DispatchQueue.main.async {
            self.menuCell?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        contentCell.configure(views: views)
        contentCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
    }
}

extension UITabbarViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if indexPath.row == tabIndex {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
          cell.setting(tabIndex, tabs:tabs, defalutText: defalultText,selectedText: selectedText, isScrollable: self.isScrollable)
          cell.delegate = self
          menuCell = cell
          return menuCell ?? MenuCell()
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

extension UITabbarViewController:reloadDelegate{
    internal func tapped(indexPath: IndexPath) {
        tappedTabButton(indexPath: indexPath)
    }
    
    
    internal func reload(indexPath: IndexPath) {
        if tabs[indexPath.row].isButton {
            
        }
        else{
            contentCell.configure(views: views)
            contentCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
        }
    }
}


enum tab {
    case button
    case label
}

public struct TabTag:Codable {
    public let title: String
    public let isButton: Bool
    
    public init(title:String,isButton: Bool = false) {
        self.title = title
        self.isButton = isButton
    }
}


protocol reloadDelegate: AnyObject  {
    func reload(indexPath:IndexPath)
    func tapped(indexPath:IndexPath)
}





