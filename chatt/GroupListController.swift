//
//  GroupController.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/12/08.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase
import LBTAComponents

class GroupListController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroup()

        self.tableView.backgroundColor = .white
        self.tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        self.tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    func fetchGroup() {
        Database.database().reference().child("group").observe(.childAdded, with: { [weak self]
            (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let group = Group()
                group.id = DataSnapshot.key
                group.setValuesForKeys(dictionary)
                self?.groups.append(group)
                self?.groups.sort(by: {
                    (user1, user2) -> Bool in
                    return (user1.name) ?? "" < (user2.name) ?? ""
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.callButton.isHidden = true
        cell.callVideoButton.isHidden = true
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Create New Group"
            
            cell.detailTextLabel?.text = ""
            
            cell.profileImageView.image = UIImage(named: "addGroupBT")
            cell.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        }
        
        if indexPath.section == 1 {
            if groups.count > 0 {
            let group = self.groups[indexPath.row]
            cell.textLabel?.text = group.name
            cell.detailTextLabel?.text = ""
            
            if let profileImageUrl = group.profileImageUrl {
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            }
                cell.backgroundColor = UIColor(r: 250, g: 250, b: 250) }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 20
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.present(RegisterGroupController(), animated: true, completion: nil)
        }
        
        if indexPath.section == 1 {
            let group = self.groups[indexPath.row]
            self.showChatControllerForGroups(group: group)
        }
    }
    
    func showChatControllerForGroups(group: Group) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.group = group
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let group = self.groups[indexPath.row]
        
        if let groupId = group.id {
            Database.database().reference().child("group").child(groupId).removeValue()
            Database.database().reference().child("user-message").child(groupId).removeValue()
                self.groups.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                self.tableView.reloadData()
            }
        }

}


class CustomTableViewHeader: UITableViewHeaderFooterView {
    var headerName = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        headerName.text = "Groups Name"
        headerName.textColor = .blue
        contentView.addSubview(headerName)
        headerName.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        contentView.backgroundColor = .gray

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
