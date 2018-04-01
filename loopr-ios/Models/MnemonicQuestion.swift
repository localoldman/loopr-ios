//
//  MnemonicQuestion.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/1/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation

struct MnemonicQuestion {

    let index: Int
    let mnemonic: String
    let question: String
    var options: [String]

    init(index: Int, mnemonic: String) {
        self.index = index
        self.mnemonic = mnemonic

        question = "\(index+1)/24. Which of the following is the \((index+1).ordinal) word of your mnemonic?"
        
        // TODO: generate options
        options = [mnemonic]
        options.append(getRandomMnemoic())
        options.append(getRandomMnemoic())
        options.append(getRandomMnemoic())
    }

    // TODO: will be deprecated if we have a better method
    func getRandomMnemoic() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(mnemonic.count)))
        let randomValue = GenerateWalletDataManager.shared.getMnemonics()[randomIndex]

        if options.contains(randomValue) {
            return getRandomMnemoic()
        }
        
        return randomValue
    }

}
