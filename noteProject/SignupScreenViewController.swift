//
//  SignupScreenViewController.swift
//  noteProject
//
//  Created by unvireak on 2/6/24.
//

import UIKit

class SignupScreenViewController: UIViewController {

    let scrollView: UIScrollView = {
        
        let view = UIScrollView()
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
    }
    
    func setupView(){
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
