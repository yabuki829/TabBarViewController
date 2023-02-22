import Foundation
import UIKit

public struct TabColor {
    var textColor:UIColor
    var backgroundColor :UIColor
    public init(textColor: UIColor,backgroundColor: UIColor){
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
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
    
    public let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
   
    /// タブの位置
    private var tabIndex = 0
    private var tabs = [TabTag]()
    private var iconList = [String]()
    private var isScrollable = false
    
    // menucellを押すとselectedcellを変更するためにアクセスできるように宣言してる
    private var contentCell = TabContentViewCell()
    public var selectedText = TabColor(textColor: .white , backgroundColor: .link)
    public var defalultText = TabColor(textColor: .label , backgroundColor: .systemGray5)
    private var views = [UIView]()
    private var contents = [TabContent]()
    private var menuCell: MenuCell?
    /// menucellのindexpathの初期値の設定
    public var selectIndexPathOfMenuCell = IndexPath(row: 0, section: 0)
    
    //タブにiconが設定されてるかどうか
    private var isTabIconImage = false
    /// タブのスペースを設定
    private var contentInsets = UIEdgeInsets(top: 0, left: 10,bottom: 0, right: 10)
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.constraints(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                    left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                    right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                    bottom: view.bottomAnchor, paddingBottom: 0)
        
        
        settingCollectionView()
        
       
    }
    private func settingCollectionView(){
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        tableView.register(TabContentViewCell.self, forCellReuseIdentifier: TabContentViewCell.identifier)
        tableView.register(TableViewContentCell.self, forCellReuseIdentifier:TableViewContentCell.identifier)
        tableView.delegate  = self
        tableView.dataSource = self
    }
    
    ///isScroltableをtrueにすると名前の通りスクロールできるようになる。
    ///isScroltableのデフォルトはfalse
    open func setting(_ tabindex:Int ,tabs: [TabTag],isScroltable:Bool = false,_ separatorStyle:UITableViewCell.SeparatorStyle = .none ){
        self.tabIndex = tabindex
        self.isScrollable = isScroltable
        if tabindex > addContentViews().count || tabindex == views.count{
            print("changed the tabIndex to 0")
            self.tabIndex = 0
        }

        tableView.separatorStyle = separatorStyle
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
        tableView.reloadData()
    }
    ///メニューセルを更新する
    open func reloadTabCell(tabs: [TabTag],isScroltable:Bool = false){
       
        //menucellの情報を更新する
        menuCell?.setting(self.tabIndex, tabs: tabs, defalutText: defalultText, selectedText: selectedText, isScrollable: isScroltable, insets: contentInsets)
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
    /**
        メニュセルの０番目を選択します
     */
    open func moveZeroIndexPath(){
        let indexPath = IndexPath(row: 0, section: 0)
        
        menuCell?.selectedIndexPath = indexPath
        // 前に選択していたcellに移動
       
        DispatchQueue.main.async {
            self.menuCell?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            
        }
        contentCell.configure(views: views)
        contentCell.collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)
    }
    /**
     最後に選択したメニューセルを選択します
     */
    open func moveIndexPath(){
        let nowIndexPath = IndexPath(row: (menuCell?.selectedIndexPath?.row ?? 0), section: 0)
        DispatchQueue.main.async {
            self.menuCell?.collectionView.selectItem(at: nowIndexPath, animated: true, scrollPosition: .left)
            
        }
        contentCell.configure(views: views)
        contentCell.collectionView.scrollToItem(at: nowIndexPath , at: .centeredHorizontally, animated: true)
    }
    
    /**
     一番最後のメニューセルを選択します
     */
    open func moveLastIndexPath(){
        let indexPath = IndexPath(row: addViews().count - 1, section: 0)
        menuCell?.selectedIndexPath = indexPath
        DispatchQueue.main.async {
            self.menuCell?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        contentCell.configure(views: views)
        contentCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
    }
    /**
     任意のメニューセルを選択します
     */
    open func moveSomeIndex(index:Int){
        if index > addViews().count {
          print("moveSomeIndexを使うときはindexの数をaddViews.count以上にしてください")
        }
        let indexPath = IndexPath(row: index, section: 0)
        menuCell?.selectedIndexPath = indexPath
        // ベストは消したセルの一個前のセルを選択すること
        DispatchQueue.main.async {
            self.menuCell?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        contentCell.configure(views: views)
        contentCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
    }
}

extension UITabbarViewController:UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tabIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
            cell.setting(tabIndex, tabs:tabs, defalutText: defalultText,selectedText: selectedText, isScrollable: self.isScrollable, insets: contentInsets)
            cell.delegate = self
            cell.selectionStyle = .none
            menuCell = cell
            menuCell?.selectedIndexPath = self.selectIndexPathOfMenuCell
            return menuCell ?? MenuCell()
        }
        else if indexPath.row == tabIndex+1 {
            contentCell = tableView.dequeueReusableCell(withIdentifier: TabContentViewCell.identifier, for: indexPath) as! TabContentViewCell
            contentCell.configure(views: views)
            
            return contentCell
        }
        
        
        if tabIndex > indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier:TableViewContentCell.identifier , for: indexPath) as! TableViewContentCell
            cell.settingView(inView: contents[indexPath.row].view)
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier:TableViewContentCell.identifier , for: indexPath) as! TableViewContentCell
            cell.settingView(inView: contents[indexPath.row-2].view)
            
            return cell
        }
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count + 2
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tabIndex == indexPath.row {
            var tabheight = tabHeight()
            if tabheight <= 0 { tabheight = 30 }
            
            return  tabheight
        }
        else if tabIndex+1 == indexPath.row {
            var contentHeight = contentViewHeight()
            if contentHeight <= 0 { contentHeight = 200 }
            
            return contentHeight
        }
        else {
            if tabIndex > indexPath.row {
                return  contents[indexPath.row].height
            }
            else{
                return contents[indexPath.row-2].height
            }

        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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

public struct TabTag:Codable,Equatable {
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





