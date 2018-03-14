//
//  Utils.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    
    init() {
        
    }
    
    //Indicador de carga
    func showLoadingIndicator(title: String, view: UIView) -> (UIActivityIndicatorView, UIVisualEffectView) {
        //https://stackoverflow.com/questions/28785715/how-to-display-an-activity-indicator-with-text-on-ios-8-with-swift
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        
        activityIndicator.startAnimating()
        view.addSubview(effectView)
        
        return (activityIndicator, effectView)
    }
    
    //Parar el indicador de carga
    func stopLoadingIndicator(indicator: (UIActivityIndicatorView, UIVisualEffectView)) {
        
        indicator.0.stopAnimating()
        indicator.1.removeFromSuperview()
    }
    
    func showToast(message: String, view: UIView) {
        //https://stackoverflow.com/questions/31540375/how-to-toast-message-in-swift
        
        let toast =  UILabel(frame: CGRect(x: view.frame.midX - 100, y: 0, width: 200, height: 50))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast.textColor = UIColor.white
        toast.textAlignment = .center
        toast.font = UIFont(name: "Monserrat-Light", size: 12.0)
        toast.text = message
        toast.alpha = 1.0
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        view.addSubview(toast)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: {(isCompleted) in
            toast.removeFromSuperview()
        })
        
    }
    
    //Alerta de conexión perdida
    func showAlertConnectionLost(view: UIViewController) {
        
        let alert = UIAlertController(title: "Connection Lost",
                                      message: "The device has lost connection to the server. Please, check the internet connection", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            
        })
        
        alert.addAction(okAction)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    //Mostrar alerta
    func showAlertError(code: Int, message: String, view: UIViewController) {
        
        let alert = UIAlertController(title: "Error \(code)",
                                      message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            
        })
        
        alert.addAction(okAction)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    //Mostrar alert con mensaje personalizado
    func showAlertWithCustomMessage(title: String, message: String, view: UIViewController) {
        
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            
        })
        
        alert.addAction(okAction)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    //Estilo de tarjeta para películas y series
    func customCardMoviesAndTVShows(cell: UICollectionViewCell) -> UICollectionViewCell {
        
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    //Estilo de tarjeta de actores
    
    func customCardPersons(cell: UICollectionViewCell) -> UICollectionViewCell {
        
        cell.contentView.layer.cornerRadius = 10.0        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        return cell
        
    }

    
}
