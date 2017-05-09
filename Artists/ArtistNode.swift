//
//  ArtistNode.swift
//  Artists
//
//  Created by Peng Guo on 2017/4/14.
//  Copyright © 2017年 iblacksun. All rights reserved.
//

import SpriteKit

class ArtistNode: SKShapeNode {

	var isSelected = false{
		didSet{
			guard oldValue != isSelected else {
				return
			}

			removeAction(forKey: "scale")

			let scaleAction = SKAction.scale(to: (isSelected ? 1.5 : 1.0), duration: 0.2)
			run(scaleAction, withKey: "scale")
		}
	}

	convenience init(artistName :String) {
		self.init()
		self.init(circleOfRadius: 40)

		fillColor = .red

		physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width / 2)
		physicsBody?.allowsRotation = false
		physicsBody?.friction = 0
		physicsBody?.linearDamping = 3

		addMultilineTextNode(artistName, radius: 40)
	}
}


extension ArtistNode{

	func addMultilineTextNode(_ text: String, radius: CGFloat) {

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byWordWrapping
		paragraphStyle.alignment = .center

		var attributes = [String : Any]()
		attributes[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 16)
		attributes[NSParagraphStyleAttributeName] = paragraphStyle
		attributes[NSForegroundColorAttributeName] = UIColor.white


		let drawOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
		let size =  CGSize(width: radius * 2 - 10, height: radius * 2)

		let attributedString = NSAttributedString(string: text, attributes: attributes)
		var textRect = attributedString.boundingRect(with: size, options: drawOptions, context: nil)

		textRect.size.width = ceil(textRect.size.width)
		textRect.size.height = ceil(textRect.size.height)

		UIGraphicsBeginImageContextWithOptions(textRect.size, false, UIScreen.main.scale)

		attributedString.draw(with: textRect, options: drawOptions, context: nil)

		if let image = UIGraphicsGetImageFromCurrentImageContext(){
			let texture = SKTexture(image: image)
			let spriteNode = SKSpriteNode(texture: texture)

			addChild(spriteNode)
		}

		UIGraphicsEndImageContext()
	}
}
