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
    
    fileprivate var transitioner = UniversalTransitionsHandler()
    
    @IBAction func dismissTapped() {
        let catVC = CatViewController.instantiate()
        let navController = UINavigationController(rootViewController: catVC)
        present(navController, animated: true, completion: nil)
        transitioner = UniversalTransitionsHandler()
        transitioner.addTransition(for: catVC.collectionView!)
        transitioner.addTransition(for: catVC.collectionView!)
        transitioner.beginTransitionAction = {
            dismiss(animated: true, completion: nil)
        }
        navController.transitioningDelegate = self
    }
    
    @IBAction func popTapped() {
        let catVC = CatViewController.instantiate()
        catVC.removeDismissButton()
        navigationController?.pushViewController(catVC, animated: true)
        transitioenr.beginTransitionAction = {
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

extension IntroViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitioner.animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitioner.interactor
    }
}

extension IntroViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .pop else { return nil }
        return transitioner.animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitioner.interactor
    }
}

