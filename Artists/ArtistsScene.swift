//
//  ArtistsScene.swift
//  Artists
//
//  Created by Peng Guo on 2017/4/13.
//  Copyright © 2017年 iblacksun. All rights reserved.
//

import SpriteKit


let artists = ["Adele", "Linkin Park", "Lady Gaga", "Miley Cyrus", "Bob Dylan", "Queen", "U2", "Coldplay", "Jay-Z", "Michael Jackson", "Rihanna", "David Bowie", "Katy Perry", "Amy Winehouse", "Madonna", "Justin Bieber"]


class ArtistsScene: SKScene {

	var isMoving = false

	override func didMove(to view: SKView) {
		super.didMove(to: view)

		backgroundColor = .white

		//1. 禁用重力
		physicsWorld.gravity = CGVector.zero

		let viewWidth = view.frame.size.width
		let viewHeight = view.frame.size.height

		let radius = max(viewWidth, viewHeight)

		//2. 添加一个特殊的 SKFieldNode，向心力
		let fieldNode = SKFieldNode.radialGravityField()
		fieldNode.region = SKRegion(radius: Float(radius))
		fieldNode.minimumRadius = Float(radius)
		fieldNode.strength = 50
		addChild(fieldNode)

		//3. 修改坐标原点
		anchorPoint = CGPoint(x: 0.5, y: 0.5)

		//4. 添加所有 Artist nodes，初始随机分配在左右两侧，受向心力作用，会自动汇聚到中心点
		for (index, artistName) in artists.enumerated() {
			let node = ArtistNode(artistName: artistName)

			let x = (index % 2 == 0) ? -viewWidth/2 : viewWidth/2
			let y = CGFloat.random(-viewHeight/2, viewHeight/2)

			node.position = CGPoint(x: x, y: y)

			addChild(node)
		}
	}
}

//MARK: Move
extension ArtistsScene{

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}

		let previous = touch.previousLocation(in: self)
		let location = touch.location(in: self)

		if location.distance(from: previous) == 0{
			return
		}
		isMoving = true

		let x = location.x - previous.x
		let y = location.y - previous.y

		for node in children{
			let distance = node.position.distance(from: location)
			let acceleration: CGFloat = 3 * pow(distance, 1/2)
			let direction = CGVector(dx: x * acceleration, dy: y * acceleration)

			node.physicsBody?.applyForce(direction)
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

		guard let touch = touches.first, !isMoving else {
			isMoving = false
			return
		}
		isMoving = false

		let location = touch.location(in: self)

		guard let artistNode = artistNodeAt(location) else{
			return
		}
		artistNode.isSelected = !artistNode.isSelected

	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		isMoving = false
	}
	

	/**
	 查找被点击的 ArtistNode.
	 */
	func artistNodeAt(_ p: CGPoint) -> ArtistNode? {
		var node = self.atPoint(p)
		if node === self {
			return nil
		}
		while true {
			if node is ArtistNode{
				return node as? ArtistNode
			}else if let parent = node.parent {
				node = parent
			}else{
				break
			}
		}

		return nil
	}

}
