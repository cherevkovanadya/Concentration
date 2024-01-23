//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by nadya on 21.12.2023.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        " Fruits ": "🍓🍇🍑🍎🍉🍋🫐🍒🍏🥭🍌🥥🍍🥝🍐🍊🍈🥑🫑🥒🌶🌽🥕🥬",
        " Shapes&Colors ": "🔴🟡🟢🔵🟣⚫️🔶🔷🟥🟧🟩🟦🟪⬛️🟫🔺🔲🔘🟠🟤🟨♥️🔻🛑",
        " Flags ": "🇺🇳🇦🇺🇦🇹🇦🇿🇦🇽🇦🇱🇩🇿🇦🇸🇦🇷🇧🇾🇧🇪🇧🇬🇧🇷🇧🇯🇧🇭🇧🇼🇬🇧🏴󠁧󠁢󠁥󠁮󠁧󠁿🇭🇺🇻🇳🇬🇪🇬🇭🇬🇱🇬🇹"
    ]

    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    
    @IBOutlet weak var beginnerDifficultyLevelButton: UIButton!
    @IBOutlet weak var mediumDifficultyLevelButton: UIButton!
    @IBOutlet weak var masterDifficultyLevelButton: UIButton!
    @IBOutlet weak var randomThemeButton: UIButton!
    @IBOutlet weak var fruitsThemeButton: UIButton!
    @IBOutlet weak var shapesAndColorsThemeButton: UIButton!
    @IBOutlet weak var flagsThemeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginnerDifficultyLevelButton.layer.cornerRadius = 10
        mediumDifficultyLevelButton.layer.cornerRadius = 10
        masterDifficultyLevelButton.layer.cornerRadius = 10
        randomThemeButton.layer.cornerRadius = 10
        fruitsThemeButton.layer.cornerRadius = 10
        shapesAndColorsThemeButton.layer.cornerRadius = 10
        flagsThemeButton.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_: UISplitViewController, topColumnForCollapsingToProposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
    
    private func getDifficultyFromTitle(_ title: String?) -> Difficulty? {
        switch title {
        case " Beginner ":
            return .beginner
        case " Medium ":
            return .medium
        case " Master ":
            return .master
        default:
            return nil
        }
    }
    
    @IBAction func chooseDifficulty(_ sender: Any) {
        let difficultyLevel = (sender as? UIButton)?.currentTitle
        
        if let cvc = splitViewDetailConcentrationViewController {
            cvc.difficultyLevel = getDifficultyFromTitle(difficultyLevel)
        } else if let cvc = lastSeguedToConcentrationViewController {
            cvc.difficultyLevel = getDifficultyFromTitle(difficultyLevel)
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Difficulty", sender: sender)
        }
    }
    
    @IBAction func chooseRandomTheme(_ sender: Any) {
        let randomTheme = themes.values.randomElement()
        
        if let cvc = splitViewDetailConcentrationViewController {
            cvc.theme = randomTheme
        } else if let cvc = lastSeguedToConcentrationViewController {
            cvc.theme = randomTheme
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Random Theme", sender: sender)
        }
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
                performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Random Theme" {
            let theme = themes.values.randomElement()
            if let cvc = segue.destination as? ConcentrationViewController {
                cvc.theme = theme
                lastSeguedToConcentrationViewController = cvc
            }
        }
        
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
        
        if segue.identifier == "Choose Difficulty" {
            let difficultyLevel = (sender as? UIButton)?.currentTitle
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.difficultyLevel = getDifficultyFromTitle(difficultyLevel)
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
}

enum Difficulty: Int {
    case beginner = 8
    case medium = 12
    case master = 24
}
