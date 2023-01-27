//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2023/01/03.
//

import Foundation
import UIKit

class TableViewContentCell:UITableViewCell {
    static var identifier = "TableViewContentCell"
    var view = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func settingView(inView view:UIView){
        contentView.addSubview(view)
        view.constraints(top: contentView.topAnchor, paddingTop: 0,
                    left: contentView.leftAnchor, paddingLeft: 0,
                    right: contentView.rightAnchor, paddingRight: 0,
                    bottom: contentView.bottomAnchor, paddingBottom: 0)
    }
     
}


