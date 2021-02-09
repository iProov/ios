// Copyright (c) 2021 iProov Ltd. All rights reserved.

import iProov
import iProovAPIClient
import MBProgressHUD
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private var usernameTextField: UITextField!

    private static let baseURL = "https://eu.rp.secure.iproov.me/api/v2" // TODO: Add your base URL here (if different from EU)

    private let apiClient = APIClient(baseURL: baseURL,
                                      apiKey: "< YOUR API KEY >", // TODO: Add your API key here
                                      secret: "< YOUR SECRET >") // TODO: Add your Secret here

    private var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Waterloo Bank"
    }

    @IBAction private func loginButtonPressed(_: UIButton) {
        guard let username = usernameTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Please enter your username/email to login.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

            return
        }

        launchIProov(claimType: .verify, username: username)
    }

    @IBAction private func registerButtonPressed(_: UIButton) {
        guard let username = usernameTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Please enter your username/email to register.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

            return
        }

        launchIProov(claimType: .enrol, username: username)
    }

    private func launchIProov(claimType: ClaimType, username: String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Getting token..."

        apiClient.getToken(type: claimType, userID: username, success: { token in

            IProov.launch(streamingURL: Self.baseURL, token: token, callback: { status in

                switch status {
                case .connecting:
                    hud.mode = .indeterminate
                    hud.label.text = "Connecting"

                case .connected:
                    break

                case let .processing(progress, message):
                    hud.mode = .determinateHorizontalBar
                    hud.label.text = message
                    hud.progress = Float(progress)

                case let .success(result):

                    hud.hide(animated: true)

                    self.token = result.token

                    self.performSegue(withIdentifier: "ShowMain", sender: self)
                    self.usernameTextField.text = nil

                case let .failure(result):

                    hud.hide(animated: true)

                    let alert = UIAlertController(title: result.feedbackCode, message: result.reason, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) -> Void in
                        self.launchIProov(claimType: claimType, username: username)
                    }))
                    self.present(alert, animated: true, completion: nil)

                case .cancelled:

                    hud.hide(animated: true)

                case let .error(error):
                    hud.hide(animated: true)

                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) -> Void in
                        self.launchIProov(claimType: claimType, username: username)
                    }))
                    self.present(alert, animated: true, completion: nil)

                @unknown default:
                    break
                }

            })

        }, failure: { error in

            hud.hide(animated: true)

            let alert = UIAlertController(title: "Failed to get token", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) -> Void in
                self.launchIProov(claimType: claimType, username: username)
            }))
            self.present(alert, animated: true, completion: nil)

        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let accountViewController = segue.destination as? AccountViewController {
            accountViewController.token = token
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
