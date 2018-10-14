//
//  AssessmentPlaceController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 12/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AssessmentPlaceController: UIViewController {
    
    var databaseRef: DatabaseReference!
    var place: Place!
    
    var hookahRating: Int!
    var placeRating: Int!
    var staffRating: Int!
    
    @IBOutlet weak var addAssessmentButton: UIButton! {
        didSet {
            addAssessmentButton.layer.cornerRadius = 5
            addAssessmentButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var hookahRatingOne: UIButton!
    @IBOutlet weak var hookahRatingTwo: UIButton!
    @IBOutlet weak var hookahRatingThree: UIButton!
    @IBOutlet weak var hookahRatingFour: UIButton!
    @IBOutlet weak var hookahRatingFive: UIButton!
    
    @IBOutlet weak var placeRatingOne: UIButton!
    @IBOutlet weak var placeRatingTwo: UIButton!
    @IBOutlet weak var placeRatingThree: UIButton!
    @IBOutlet weak var placeRatingFour: UIButton!
    @IBOutlet weak var placeRatingFive: UIButton!
    
    @IBOutlet weak var staffRatingOne: UIButton!
    @IBOutlet weak var staffRatingTwo: UIButton!
    @IBOutlet weak var staffRatingThree: UIButton!
    @IBOutlet weak var staffRatingFour: UIButton!
    @IBOutlet weak var staffRatingFive: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookahRating = 0
        placeRating = 0
        staffRating = 0
        databaseRef = Database.database().reference()
    }
    
    // MARK: - IBAction Hookah Rating
    
    @IBAction func hookahRatingOne(_ sender: Any) {
        hookahRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingTwo.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRatingThree.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRating = 1
    }
    
    @IBAction func hookahRatingTwo(_ sender: Any) {
        hookahRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingThree.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRating = 2
    }
    
    @IBAction func hookahRatingThree(_ sender: Any) {
        hookahRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRating = 3
    }
    
    @IBAction func hookahRatingFour(_ sender: Any) {
        hookahRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingFour.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        hookahRating = 4
    }
    
    @IBAction func hookahRatingFive(_ sender: Any) {
        hookahRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingFour.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRatingFive.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        hookahRating = 5
    }
    
    // MARK: - IBAction Place Rating
    
    @IBAction func placeRatingOne(_ sender: Any) {
        placeRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingTwo.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRatingThree.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRating = 1
    }
    
    @IBAction func placeRatingTwo(_ sender: Any) {
        placeRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingThree.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRating = 2
    }
    
    @IBAction func placeRatingThree(_ sender: Any) {
        placeRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRating = 3
    }
    
    @IBAction func placeRatingFour(_ sender: Any) {
        placeRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingFour.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        placeRating = 4
    }
    
    @IBAction func placeRatingFive(_ sender: Any) {
        placeRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingFour.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRatingFive.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        placeRating = 5
    }
    
    // MARK: - IBAction Staff Rating
    
    @IBAction func staffRatingOne(_ sender: Any) {
        staffRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingTwo.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRatingThree.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRating = 1
    }
    
    @IBAction func staffRatingTwo(_ sender: Any) {
        staffRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingThree.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRating = 2
    }
    
    @IBAction func staffRatingThree(_ sender: Any) {
        staffRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingFour.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRating = 3
    }
    
    @IBAction func staffRatingFour(_ sender: Any) {
        staffRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingFour.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingFive.setBackgroundImage(UIImage(named: "assessment"), for: .normal)
        staffRating = 4
    }
    
    @IBAction func staffRatingFive(_ sender: Any) {
        staffRatingOne.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingTwo.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingThree.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingFour.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRatingFive.setBackgroundImage(UIImage(named: "assessment-black"), for: .normal)
        staffRating = 5
    }
    
    @IBAction func closeWindowBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAssessmentsBarButtonPressed(_ sender: Any) {
        guard hookahRating != 0, placeRating != 0, staffRating != 0 else {
            defaultAlertController(title: "Ошибка", message: "Поставьте везде оценку", actionTitle: "OK", handler: nil)
            return
        }
        addNewAssessment()
        let controller = self.presentingViewController as? DetailPlaceController
        controller?.isAssessment = true
        defaultAlertController(title: "Успешно", message: "Спасибо за поставленную оценку!", actionTitle: "OK") { (action) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func addNewAssessment() {
        databaseRef.child("places/\(place.id)").observeSingleEvent(of: .value) { (snapshot) in
            let place = snapshot.value as? NSDictionary
            var count = place?["countAssessment"] as? Int ?? -1
            guard count != -1 else {
                self.defaultAlertController(title: "Ошибка", message: "Ошибка соединения с сервером", actionTitle: "OK", handler: nil)
                return
            }
            self.databaseRef.child("places/\(self.place.id)/assessments/\(count)").setValue([
                "id": (Auth.auth().currentUser?.uid)!,
                "hookah": self.hookahRating!,
                "place": self.placeRating!,
                "staff": self.staffRating!
                ])
            self.databaseRef.child("places/\(self.place.id)/assessments").observeSingleEvent(of: .value, with: { (snapshot) in
                var index = 0
                while index < count {
                    self.databaseRef.child("places/\(self.place.id)/assessments/\(index)").observeSingleEvent(of: .value, with: { (assessmentsSnapshot) in
                        let assessment = assessmentsSnapshot.value as? NSDictionary
                        let hookahRat = assessment?["hookah"] as? Int ?? 0
                        let placeRat = assessment?["place"] as? Int ?? 0
                        let staffRat = assessment?["staff"] as? Int ?? 0
                        self.hookahRating += hookahRat
                        self.placeRating += placeRat
                        self.staffRating += staffRat
                    })
                    index += 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                    count += 1
                    self.databaseRef.child("places/\(self.place.id)/countAssessment").setValue(count)
                    let ratingHookah = Double(round(10 * Double(self.hookahRating!) / Double(count)) / 10)
                    let ratingPlace = Double(round(10 * Double(self.placeRating!) / Double(count)) / 10)
                    let ratingStaff = Double(round(10 * Double(self.staffRating!) / Double(count)) / 10)
                    let rating = Double(round(10 * Double(ratingHookah + ratingPlace + ratingStaff) / 3.0) / 10)
                    self.databaseRef.child("places/\(self.place.id)/ratingHookah").setValue(ratingHookah)
                    self.databaseRef.child("places/\(self.place.id)/ratingPlace").setValue(ratingPlace)
                    self.databaseRef.child("places/\(self.place.id)/ratingStaff").setValue(ratingStaff)
                    self.databaseRef.child("places/\(self.place.id)/rating").setValue(rating)
                })
            })
            self.databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/countAssessment").observeSingleEvent(of: .value, with: { (snapshot) in
                var countAssessments = snapshot.value as? Int ?? -1
                guard countAssessments != -1 else {
                    return
                }
                print("COUNT ASSESSMENTS - \(countAssessments)")
                countAssessments += 1
                self.databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/countAssessment").setValue(countAssessments)
            })
        }
    }

}
