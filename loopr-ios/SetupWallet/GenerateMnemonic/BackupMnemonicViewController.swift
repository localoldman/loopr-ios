//
//  BackupMnemonicViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/4/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class BackupMnemonicViewController: UIViewController {

    var mnemonics: [String] = []

    var backgroundImageView1 = UIImageView()
    var titleLabel: UILabel =  UILabel()
    var infoTextView: UITextView = UITextView()
    
    @IBOutlet weak var skipVerifyNowButton: UIButton!
    @IBOutlet weak var verifyNowButton: UIButton!
    
    var backgroundImageView2 = UIImageView()
    var mnemonicCollectionViewController0: MnemonicCollectionViewController!

    var collectionViewY: CGFloat = 200
    var collectionViewWidth: CGFloat = 200
    var collectionViewHeight: CGFloat = 220
    
    private let originY: CGFloat = 30
    private let padding: CGFloat = 15
    private let buttonPaddingY: CGFloat = 40
    
    private var firstAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setBackButton()
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        self.navigationItem.title = LocalizedString("Generate Wallet", comment: "")

        mnemonics = GenerateWalletDataManager.shared.getMnemonics()

        // Setup UI
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        
        backgroundImageView1.frame = CGRect(x: 18, y: 10, width: screenWidth - 18 * 2, height: 200)
        backgroundImageView1.backgroundColor = UIColor.clear
        backgroundImageView1.image = UIImage.init(named: "MnemonicBackgroundImage1")
        view.addSubview(backgroundImageView1)
        
        backgroundImageView2.frame = CGRect(x: 18, y: backgroundImageView1.bottomY, width: screenWidth - 18 * 2, height: 200)
        backgroundImageView2.backgroundColor = UIColor.clear
        backgroundImageView2.image = UIImage.init(named: "MnemonicBackgroundImage2")
        view.addSubview(backgroundImageView2)
        
        titleLabel.frame = CGRect(x: padding, y: 30, width: backgroundImageView1.width - padding * 2, height: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.font = FontConfigManager.shared.getMediumFont(size: 16)
        titleLabel.text = LocalizedString("Backup Mnemonic", comment: "")
        titleLabel.textAlignment = .center
        backgroundImageView1.addSubview(titleLabel)
        
        infoTextView.frame = CGRect(x: 20, y: 65, width: backgroundImageView1.width - 20*2, height: 120)
        infoTextView.isEditable = false
        infoTextView.textColor = UIColor.white
        infoTextView.backgroundColor = UIColor.clear
        infoTextView.font = UIFont.init(name: "Rubik-Italic", size: 14)
        backgroundImageView1.addSubview(infoTextView)

        collectionViewWidth = backgroundImageView1.width - 20 * 2
        collectionViewHeight = 4*MnemonicCollectionViewCell.getHeight() + 2*padding
        collectionViewY = 22
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (collectionViewWidth - 30)/3, height: MnemonicCollectionViewCell.getHeight())
        flowLayout.scrollDirection = .vertical
        
        mnemonicCollectionViewController0 = MnemonicCollectionViewController(collectionViewLayout: flowLayout)
        // assign first 12 words
        mnemonicCollectionViewController0.mnemonics = mnemonics
        mnemonicCollectionViewController0.view.isHidden = false
        mnemonicCollectionViewController0.view.frame = CGRect(x: 20, y: collectionViewY, width: collectionViewWidth, height: collectionViewHeight)
        backgroundImageView2.addSubview(mnemonicCollectionViewController0.view)
        addChildViewController(mnemonicCollectionViewController0)

        skipVerifyNowButton.title = LocalizedString("Skip Verification", comment: "Go to VerifyMnemonicViewController")
        skipVerifyNowButton.setupPrimary(height: 44)
        
        verifyNowButton.title = LocalizedString("Verify Now", comment: "Go to VerifyMnemonicViewController")
        verifyNowButton.setupSecondary(height: 44)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        infoTextView.text = LocalizedString("Revealing your mnemonic phrases on web sites is highly dangerous. If the site is compromised or you accidentally visit a phishing website, your assets in all associated addresses can be stolen.", comment: "")

        // CollectionView won't be layout correctly in viewDidLoad()
        // https://stackoverflow.com/questions/12927027/uicollectionview-flowlayout-not-wrapping-cells-correctly-ios
        // If you want to improve this part, please submit a PR to review
        if firstAppear {
            self.mnemonicCollectionViewController0.view.frame = CGRect(x: 20, y: collectionViewY, width: self.collectionViewWidth, height: self.collectionViewHeight)
            mnemonicCollectionViewController0.collectionView?.collectionViewLayout.invalidateLayout()
            
            firstAppear = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func pressedVerifyNowButton(_ sender: Any) {
        let viewController = VerifyMnemonicViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func pressedSkipVerifyNowButton(_ sender: Any) {
        exit()
    }

    func exit() {
        let header = LocalizedString("Create_used_in_creating_wallet", comment: "used in creating wallet")
        let footer = LocalizedString("successfully_used_in_creating_wallet", comment: "used in creating wallet")
        let attributedString = NSAttributedString(string: header + " " + "\(GenerateWalletDataManager.shared.walletName)" + " " + footer, attributes: [
            NSAttributedStringKey.font: UIFont.init(name: FontConfigManager.shared.getMedium(), size: 17) ?? UIFont.systemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor: UIColor.init(rgba: "#030303")
            ])
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")

        let backAction = UIAlertAction(title: LocalizedString("Back", comment: ""), style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(backAction)

        let confirmAction = UIAlertAction(title: LocalizedString("Enter Wallet", comment: ""), style: .default, handler: { _ in
            GenerateWalletDataManager.shared.complete(completion: {(appWallet, error) in
                if error == nil {
                    self.dismissGenerateWallet()
                } else if error == .duplicatedAddress {
                    self.alertForDuplicatedAddress()
                } else {
                    self.alertForError()
                }
            })
        })
        alertController.addAction(confirmAction)
        
        // Show the UIAlertController
        self.present(alertController, animated: true, completion: nil)
    }

    func dismissGenerateWallet() {
        if SetupDataManager.shared.hasPresented {
            self.dismiss(animated: true, completion: {
                
            })
        } else {
            SetupDataManager.shared.hasPresented = true
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        }
    }
    
}
