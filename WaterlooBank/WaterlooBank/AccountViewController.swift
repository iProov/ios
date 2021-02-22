// Copyright (c) 2021 iProov Ltd. All rights reserved.

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet private var tokenLabel: UILabel!

    var token: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Your Account"

        // Do any additional setup after loading the view.

        tokenLabel.text = String(format: "Your token is %@", token)
    }
}
