// Copyright (c) 2021 iProov Ltd. All rights reserved.

import iProov
import iProovAPIClient
import MBProgressHUD
import UIKit

class ViewController: UIViewController {
    private static let baseURL = "https://eu.rp.secure.iproov.me/api/v2"

    // NOTE: This is provided for example/demo purposes only. You should never embed your credentials in a public app release!
    private let apiClient = APIClient(baseURL: baseURL,
                                      apiKey: <#T##String#>,
                                      secret: <#T##String#>)

    @IBOutlet private var userIDTextField: UITextField!

    @IBAction func enrolWithGPAButtonPressed(_: UIButton) {
        launch(claimType: .enrol, assuranceType: .genuinePresence)
    }

    @IBAction func verifyWithGPAButtonPressed(_: UIButton) {
        launch(claimType: .verify, assuranceType: .genuinePresence)
    }

    @IBAction func verifyWithLAButtonPressed(_: UIButton) {
        launch(claimType: .verify, assuranceType: .liveness)
    }

    private func launch(claimType: ClaimType, assuranceType: AssuranceType) {
        guard let userID = userIDTextField.text, !userID.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter a User ID", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        userIDTextField.resignFirstResponder()

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Getting token..."

        apiClient.getToken(assuranceType: assuranceType, type: claimType, userID: userID, success: { token in

            IProov.launch(streamingURL: Self.baseURL, token: token) { status in

                switch status {
                case .connecting:
                    hud.mode = .indeterminate
                    hud.label.text = "Connecting..."

                case .connected:
                    break

                case let .processing(progress, message):
                    hud.mode = .determinateHorizontalBar
                    hud.label.text = message
                    hud.progress = Float(progress)

                case let .success(result):
                    hud.hide(animated: true)

                    let alert = UIAlertController(title: "✅ Success", message: "Token: \(result.token)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                case let .failure(result):
                    hud.hide(animated: true)

                    let alert = UIAlertController(title: "❌ \(result.feedbackCode)", message: result.reason, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) -> Void in
                        self.launch(claimType: claimType, assuranceType: assuranceType)
                    }))
                    self.present(alert, animated: true, completion: nil)

                case .cancelled:
                    hud.hide(animated: true)

                case let .error(error):
                    hud.hide(animated: true)

                    let alert = UIAlertController(title: "❌ Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) -> Void in
                        self.launch(claimType: claimType, assuranceType: assuranceType)
                    }))
                    self.present(alert, animated: true, completion: nil)

                @unknown default:
                    break
                }
            }

        }, failure: { error in

            hud.hide(animated: true)

            let alert = UIAlertController(title: "Failed to get token", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) -> Void in
                self.launch(claimType: claimType, assuranceType: assuranceType)
            }))
            self.present(alert, animated: true, completion: nil)

        })
    }
}
