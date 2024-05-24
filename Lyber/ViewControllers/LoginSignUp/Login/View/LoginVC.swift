//
//  LoginVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import AVFoundation
import AppsFlyerLib

class LoginVC: ViewController {
    let audioSession = AVAudioSession.sharedInstance()
    private var audioLevel: Float = 0.0
    private var isObservingVolume = false
    private let languageButton = UIButton(type: .custom)
    private let languageImageView = UIImageView()
    private let languageDropdown = UIStackView()
    private var isDropdownVisible = false

    //MARK: - IB OUTLETS
    @IBOutlet var backgroundImgVw: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subtitleLbl: UILabel!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var LoginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupLanguageButton()
        configureAudioSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activateAudioSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deactivateAudioSession()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            handleVolumeChange()
        }
    }

    //MARK: - SetUpUI
    override func setUpUI() {
        CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_CRYPTO_FINGERTIPS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: subtitleLbl, text: CommonFunctions.localisation(key: "SIMPLE_SECURE_DIVERSIFIED_INVESTMENT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        subtitleLbl.numberOfLines = 0
        CommonUI.setUpButton(btn: signUpBtn, text: CommonFunctions.localisation(key: "SIGN_UP"), textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        CommonUI.setUpButton(btn: LoginBtn, text: CommonFunctions.localisation(key: "LOG_IN"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))

        signUpBtn.addTarget(self, action: #selector(signUpBtnAct), for: .touchUpInside)
        LoginBtn.addTarget(self, action: #selector(loginBtnAct), for: .touchUpInside)
    }

    private func setupLanguageButton() {
        languageImageView.image = UIImage(named: getFlagImageName(for: userData.shared.language))
        languageImageView.contentMode = .scaleAspectFit
        languageImageView.translatesAutoresizingMaskIntoConstraints = false

        languageButton.addSubview(languageImageView)
        languageButton.addTarget(self, action: #selector(toggleLanguageDropdown), for: .touchUpInside)
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(languageButton)

        NSLayoutConstraint.activate([
            languageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            languageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            languageButton.widthAnchor.constraint(equalToConstant: 30),
            languageButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            languageImageView.centerXAnchor.constraint(equalTo: languageButton.centerXAnchor),
            languageImageView.centerYAnchor.constraint(equalTo: languageButton.centerYAnchor),
            languageImageView.widthAnchor.constraint(equalTo: languageButton.widthAnchor, multiplier: 0.8),
            languageImageView.heightAnchor.constraint(equalTo: languageButton.heightAnchor, multiplier: 0.8)
        ])

        configureLanguageDropdown()
    }

    private func configureLanguageDropdown() {
        // Configure language dropdown
       languageDropdown.backgroundColor = .white
       languageDropdown.layer.cornerRadius = 5
       languageDropdown.layer.shadowColor = UIColor.black.cgColor
       languageDropdown.layer.shadowOpacity = 0.5
       languageDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
       languageDropdown.layer.shadowRadius = 5
       languageDropdown.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(languageDropdown)
       
       let englishButton = UIButton(type: .system)
       englishButton.setTitle("English", for: .normal)
       englishButton.setTitleColor(.black, for: .normal)
       englishButton.addTarget(self, action: #selector(selectEnglish), for: .touchUpInside)
       englishButton.translatesAutoresizingMaskIntoConstraints = false
       
       let frenchButton = UIButton(type: .system)
       frenchButton.setTitle("Français", for: .normal)
       frenchButton.setTitleColor(.black, for: .normal)
       frenchButton.addTarget(self, action: #selector(selectFrench), for: .touchUpInside)
       frenchButton.translatesAutoresizingMaskIntoConstraints = false
       
       languageDropdown.addSubview(englishButton)
       languageDropdown.addSubview(frenchButton)
       
       NSLayoutConstraint.activate([
           englishButton.topAnchor.constraint(equalTo: languageDropdown.topAnchor, constant: 5),
           englishButton.leadingAnchor.constraint(equalTo: languageDropdown.leadingAnchor, constant: 5),
           englishButton.trailingAnchor.constraint(equalTo: languageDropdown.trailingAnchor, constant: -5),
           
           frenchButton.topAnchor.constraint(equalTo: englishButton.bottomAnchor, constant: 5),
           frenchButton.leadingAnchor.constraint(equalTo: languageDropdown.leadingAnchor, constant: 5),
           frenchButton.trailingAnchor.constraint(equalTo: languageDropdown.trailingAnchor, constant: -5),
           frenchButton.bottomAnchor.constraint(equalTo: languageDropdown.bottomAnchor, constant: -5)
       ])
       
       NSLayoutConstraint.activate([
           languageDropdown.topAnchor.constraint(equalTo: languageButton.bottomAnchor, constant: 5),
           languageDropdown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
       ])
       
       languageDropdown.isHidden = true
   }

    private func configureAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func activateAudioSession() {
        do {
            try audioSession.setActive(true, options: [])
            if !isObservingVolume {
                audioSession.addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
                isObservingVolume = true
            }
            audioLevel = audioSession.outputVolume
        } catch {
            print("Error")
        }
    }

    private func deactivateAudioSession() {
        if isObservingVolume {
            audioSession.removeObserver(self, forKeyPath: "outputVolume")
            isObservingVolume = false
        }
    }

    private func handleVolumeChange() {
        if AppConfig.dictEnvVariables["ENV"] as? String == "STAGING" {
            if audioSession.outputVolume < audioLevel {
                toggleEnvironment()
            }
            audioLevel = audioSession.outputVolume
        }
    }

    private func toggleEnvironment() {
        if GlobalVariables.baseUrl == ApiEnvironment.Staging.rawValue {
            CommonFunctions.toster("Environnement changé à : Dev")
            GlobalVariables.baseUrl = ApiEnvironment.Dev.rawValue
            userData.shared.environment = "DEV"
        } else {
            CommonFunctions.toster("Environnement changé à : Staging")
            GlobalVariables.baseUrl = ApiEnvironment.Staging.rawValue
            userData.shared.environment = "STAGING"
        }
        userData.shared.dataSave()
    }

    private func getFlagImageName(for language: String) -> String {
        switch language {
        case "fr":
            return "fr_flag"
        case "en":
            return "uk_flag"
        default:
            return "uk_flag"
        }
    }
    
    func setNewLanguage(language: String) {
        userData.shared.language = language
        userData.shared.dataSave()
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"), let bundle = Bundle(path: path) {
            GlobalVariables.bundle = bundle
        }
        DispatchQueue.main.async {
            self.updateUIForSelectedLanguage()
        }
    }

    private func updateUIForSelectedLanguage() {
        titleLbl.text = CommonFunctions.localisation(key: "LYBER_CRYPTO_FINGERTIPS")
        subtitleLbl.text = CommonFunctions.localisation(key: "SIMPLE_SECURE_DIVERSIFIED_INVESTMENT")
        signUpBtn.setTitle(CommonFunctions.localisation(key: "SIGN_UP"), for: .normal)
        LoginBtn.setTitle(CommonFunctions.localisation(key: "LOG_IN"), for: .normal)
    }
}

//MARK: - Objective functions
extension LoginVC {
    @objc func signUpBtnAct() {
        GlobalVariables.isRegistering = true
        GlobalVariables.isLogin = false
        var vc = UIViewController()
        if userData.shared.personalDataStepComplete > 0 && userData.shared.personalDataStepComplete < 3 {
            vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        } else {
            vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        }
        AppsFlyerLib.shared().logEvent(AFEventContentView, withValues: [AFEventParamContent: "RegistrationPage"])
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func loginBtnAct() {
        GlobalVariables.isRegistering = false
        GlobalVariables.isLogin = true
        let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func volumeDidChange(_ notification: Notification) {
        if let audioSession = notification.object as? AVAudioSession {
            let newVolume = audioSession.outputVolume
            print("New volume: \(newVolume)")
        }
    }

    @objc private func toggleLanguageDropdown() {
        isDropdownVisible.toggle()
        languageDropdown.isHidden = !isDropdownVisible
    }

    @objc private func selectEnglish() {
        languageImageView.image = UIImage(named: "uk_flag")
        languageDropdown.isHidden = true
        isDropdownVisible = false
        setNewLanguage(language: "en")
    }

    @objc private func selectFrench() {
        languageImageView.image = UIImage(named: "fr_flag")
        languageDropdown.isHidden = true
        isDropdownVisible = false
        setNewLanguage(language: "fr")
    }
}
