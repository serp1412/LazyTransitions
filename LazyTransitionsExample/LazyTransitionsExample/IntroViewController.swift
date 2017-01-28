//
//  IntroViewController.swift
//  LazyTransitionsExample
//
//  Created by Serghei Catraniuc on 1/10/17.
//  Copyright © 2017 BeardWare. All rights reserved.
//

import UIKit
import LazyTransitions

class IntroViewController: UIViewController {
    fileprivate var transitioner = LazyTransitioner()
    
    @IBAction func dismissDemoTapped() {
        let catVC = CatViewController.instantiate(withTitle: "Dismiss Demo")
        let navController = UINavigationController(rootViewController: catVC)
        present(navController, animated: true, completion: nil)
        transitioner = LazyTransitioner()
        transitioner.addTransition(forScrollView: catVC.collectionView!)
        transitioner.addTransition(forView: catVC.view)
        transitioner.triggerTransitionAction = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        catVC.didScrollCallback = { [weak self] scrollView in
            self?.transitioner.didScroll(scrollView)
        }
        navController.transitioningDelegate = transitioner
    }
    
    @IBAction func popDemoTapped() {
        let catVC = CatViewController.instantiate(withTitle: "Pop Demo")
        catVC.removeDismissButton()
        navigationController?.pushViewController(catVC, animated: true)
        transitioner = LazyTransitioner(animator: PopAnimator(orientation: .leftToRight))
        transitioner.addTransition(forView: catVC.view)
        transitioner.triggerTransitionAction = { [weak self] _ in
            _ = self?.navigationController?.popViewController(animated: true)
        }
        transitioner.allowedOrientations = [.leftToRight]
        navigationController?.delegate = transitioner
    }
}
