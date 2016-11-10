//  Spotify.swift
//  Spotify ( https://github.com/xmartlabs/XLActionController )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
#if XLACTIONCONTROLLER_EXAMPLE
import XLActionController
#endif


open class SpotifyActionController: ActionController<TwitterCell, ActionData, TwitterActionControllerHeader, String, UICollectionReusableView, Void> {
    
    fileprivate lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
		blurView.effect = nil
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.addSubview(blurView)
        
        cancelView?.frame.origin.y = view.bounds.size.height // Starts hidden below screen
        cancelView?.layer.shadowColor = UIColor.white.cgColor
		cancelView?.layer.shadowOffset = CGSize( width: 0, height: -4)
        cancelView?.layer.shadowRadius = 2
        cancelView?.layer.shadowOpacity = 0.8
		
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blurView.frame = backgroundView.bounds
    }
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        settings.behavior.bounces = true
        settings.behavior.scrollEnabled = true
        settings.cancelView.showCancel = true
        settings.animation.scale = nil
        settings.animation.present.springVelocity = 0.0
		settings.behavior.hideOnScrollDown = true
        
        cellSpec = .nibFile(nibName: "TwitterCell", bundle: Bundle(for: TwitterCell.self), height: { _ in 60 })
		headerSpec = .cellClass(height: { _ -> CGFloat in return 45 })
		
		
		onConfigureHeader = { header, title in
			header.label.text = title
		}
		
        onConfigureCellForAction = { [weak self] cell, action, indexPath in
            cell.setup(action.data?.title, detail: action.data?.subtitle, image: action.data?.image)
            cell.separatorView?.isHidden = indexPath.item == (self?.collectionView.numberOfItems(inSection: indexPath.section))! - 1
            cell.alpha = action.enabled ? 1.0 : 0.5
        }
    }
  
    required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
	
	open override func performCustomPresentationAnimation(_ presentedView: UIView, presentingView: UIView) {
		super.performCustomPresentationAnimation(presentedView, presentingView: presentingView)
		blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
	}
	
    open override func performCustomDismissingAnimation(_ presentedView: UIView, presentingView: UIView) {
        super.performCustomDismissingAnimation(presentedView, presentingView: presentingView)
        cancelView?.frame.origin.y = view.bounds.size.height + 10
    }
    
    open override func onWillPresentView() {
        cancelView?.frame.origin.y = view.bounds.size.height
    }
}
