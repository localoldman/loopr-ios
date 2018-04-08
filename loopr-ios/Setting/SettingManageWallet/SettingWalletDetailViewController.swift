//
//  SettingWalletDetailViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/6/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingWalletDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appWallet: AppWallet!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchWalletButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        switchWalletButton.title = NSLocalizedString("Switch to this Wallet", comment: "")
        switchWalletButton.setupRoundBlack()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedSwitchWalletButton(_ sender: Any) {
        print("pressedSwitchWalletButton")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Update the UITableViewCell.
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "title")
        
        if indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("Backup Mnemonic", comment: "")
        } else if indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString("Export Private Key", comment: "")
        } else if indexPath.row == 2 {
            cell.textLabel?.text = NSLocalizedString("Export Keystore", comment: "")
        }
        
        cell.textLabel?.font = FontConfigManager.shared.getLabelFont()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            let viewController = DisplayPrivateKeyViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath.row == 2 {
            let viewController = ExportKeystoreEnterPasswordViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}