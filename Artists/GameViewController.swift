//
//  GameViewController.swift
//  Artists
//
//  Created by Peng Guo on 2017/4/13.
//  Copyright © 2017年 iblacksun. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		guard let skView = self.view as? SKView else{
			return
		}
		skView.backgroundColor = .white

		skView.ignoresSiblingOrder = true

		skView.showsFPS = true
		skView.showsNodeCount = true
		skView.showsPhysics = true

		let scene = ArtistsScene(size: skView.bounds.size)
		skView.presentScene(scene)
    }

}
