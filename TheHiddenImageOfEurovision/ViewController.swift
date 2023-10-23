//
//  ViewController.swift
//  TheHiddenImageOfEurovision
//
//  Created by Cenker Soyak on 20.10.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    var eurovisionLabel = UILabel()
    var label2022 = UILabel()
    var imageView = UIImageView()
    
    var contestName : String?
    var contestYear : Int?
    var imageIsHidden : Bool?
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI(){
        view.backgroundColor = .white
        
        eurovisionLabel.text = ""
        eurovisionLabel.textAlignment = .center
        eurovisionLabel.font = UIFont.systemFont(ofSize: 23)
        view.addSubview(eurovisionLabel)
        eurovisionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        label2022.text = ""
        label2022.textAlignment = .justified
        label2022.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(label2022)
        label2022.snp.makeConstraints { make in
            make.top.equalTo(eurovisionLabel.snp.bottom).offset(1)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-50)
        }
        imageView.image = UIImage(named: "eurovision0")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.isHidden = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(label2022.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaInsets).offset(-110)
        }
        fetchValues()
    }
    func fetchValues() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
        let defaults : [String : NSObject] = ["contestName" : "" as NSObject]
        remoteConfig.setDefaults(defaults)
        
        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if status == .success, error == nil {
                self.remoteConfig.activate { _, error in
                    guard error == nil else { return }
                    let cN = self.remoteConfig.configValue(forKey: "string_value").stringValue
                    let cY = self.remoteConfig.configValue(forKey: "number_value").numberValue as! Int
                    let iH = self.remoteConfig.configValue(forKey: "change_images_ishidden").boolValue
                    
                    DispatchQueue.main.async {
                        self.updateUI(contestName: cN ?? "", contestYear: cY, imageIsHidden: iH )
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    func updateUI(contestName: String, contestYear: Int, imageIsHidden: Bool) {
        eurovisionLabel.text = contestName
        label2022.text = "\(contestYear)"
        imageView.isHidden = imageIsHidden
    }
}
