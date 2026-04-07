//
//  GameScene.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//

import SpriteKit

final class 

MapperProviderRunnerEngine: SKScene {
    
    var gameViewModel: ObserverContextGeneratorValidator?
    
    
    private let fieldNode = SKSpriteNode(imageNamed: "field_center")
    private let leftPodium = SKSpriteNode(imageNamed: "podium")
    private let rightPodium = SKSpriteNode(imageNamed: "podium")
    private let leftPet = SKSpriteNode(imageNamed: "pet_left")
    private let rightPet = SKSpriteNode(imageNamed: "pet_right")
    private let player = SKSpriteNode(imageNamed: "playerIcon_\(UserDefaults.standard.integer(forKey: "pickedModel"))")
    private var enemyName: String = "enemyIcon_1"
    private let enemy = SKSpriteNode()
    private let topJudge = SKSpriteNode(imageNamed: "judge_top")
    private let bottomJudge = SKSpriteNode(imageNamed: "judge_bottom")
    
    private var leftCovers: [SKSpriteNode] = []
    private var rightCovers: [SKSpriteNode] = []
    
    private var leftCols: [[UpdaterCheckerInteractorCache]] = []
    private var rightCols: [[UpdaterCheckerInteractorCache]] = []
    
    private var leftHighlights: [SKSpriteNode] = []
    private var rightHighlights: [SKSpriteNode] = []
    private let highlightTextureName = "column_highlight"
    
    private var playerProgress = 0
    private var enemyProgress  = 0
    private var playerHidden: (col: Int, idx: Int)? = nil
    private var enemyHidden:  (col: Int, idx: Int)? = nil
    private var phase: Phase = .playerHide
    
    private var coversBound = false
    
    private var built = false
    
    private let fieldWidthFrac: CGFloat = 0.6
    private let fieldHeightFrac: CGFloat = 0.95
    private let podiumWidthFrac: CGFloat = 0.125
    private let podiumHeightFrac: CGFloat = 0.3
    private let sidePaddingFrac: CGFloat = 0.03
    private let judgeWidthFrac: CGFloat = 0.10
    private let judgesYOffsetFrac: CGFloat = 0.25
    
    private let columnsPerSide = 5
    private let maxRows = 6
    private let minRows = 2
    
    private enum TouchMode { case hide, guess }
    private var touchMode: TouchMode? = nil
    private var touchSide: Side = .player
    private var nextShooter: Side = .player
    private var shotsThisRound = 0

    private var touchCol: Int = 0
    
    private let enemyHideThinkDelay: TimeInterval  = 0.6
    private let enemyThrowThinkDelay: TimeInterval = 0.6
    private let enemyWindupDelay: TimeInterval     = 0.15
    
      override init(size: CGSize) {
          super.init(size: size)
      }

      convenience init(enemyName: String, gameViewModel: ObserverContextGeneratorValidator? = nil) {
          self.init(size: .zero) 
          self.enemyName = enemyName
          self.gameViewModel = gameViewModel
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }
    
    override func didMove(to view: SKView) {
        guard !built else { return }
        anchorPoint = CGPoint(x: 0.525, y: 0.5)
        backgroundColor = .clear
        
        enemy.texture = SKTexture(imageNamed: enemyName)

        fieldNode.zPosition = 0
        addChild(fieldNode)
        
        leftPodium.zPosition = 1
        rightPodium.zPosition = 1
        player.zPosition = 2
        enemy.zPosition = 2
        leftPet.zPosition = 3
        rightPet.zPosition = 3
        addChild(leftPodium)
        addChild(rightPodium)
        addChild(leftPet)
        addChild(rightPet)
        addChild(player)
        addChild(enemy)
        
        topJudge.zPosition = 4
        bottomJudge.zPosition = 4
        addChild(topJudge)
        addChild(bottomJudge)
        
        makeCovers()
        makeHighlights()
        
        built = true
        layoutScene()
        
        bindCoverRefsIfNeeded()
        startGame()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if built { layoutScene() }
    }
    
    private func makeCovers() {
        let totalPerSide = (minRows + maxRows) * columnsPerSide / 2
        leftCovers = (0..<totalPerSide).map { _ in
            let n = SKSpriteNode(imageNamed: "cover_friendly")
            n.zPosition = 5
            addChild(n)
            return n
        }
        rightCovers = (0..<totalPerSide).map { _ in
            let n = SKSpriteNode(imageNamed: "cover_enemy")
            n.zPosition = 5
            addChild(n)
            return n
        }
    }
    
    private func makeHighlights() {
        leftHighlights = (0..<columnsPerSide).map { _ in
            let n = SKSpriteNode(imageNamed: highlightTextureName)
            n.zPosition = 2
            n.alpha = 0.0
            addChild(n)
            return n
        }
        rightHighlights = (0..<columnsPerSide).map { _ in
            let n = SKSpriteNode(imageNamed: highlightTextureName)
            n.zPosition = 2
            n.alpha = 0.0
            addChild(n)
            return n
        }
    }
    
    private func clearAllHighlights() {
        for n in leftHighlights { n.removeAllActions(); n.alpha = 0 }
        for n in rightHighlights { n.removeAllActions(); n.alpha = 0 }
    }
    
    private func bindCoverRefsIfNeeded() {
        guard !coversBound else { return }
        leftCols = (0..<columnsPerSide).map { _ in [] }
        rightCols = (0..<columnsPerSide).map { _ in [] }
        
        var li = 0
        for c in 0..<columnsPerSide {
            let rows = minRows + c
            for r in 0..<rows {
                let node = leftCovers[li]; li += 1
                leftCols[c].append(UpdaterCheckerInteractorCache(node: node, col: c, idx: r))
            }
        }
        var ri = 0
        for c in 0..<columnsPerSide {
            let rows = minRows + c
            for r in 0..<rows {
                let node = rightCovers[ri]; ri += 1
                rightCols[c].append(UpdaterCheckerInteractorCache(node: node, col: c, idx: r))
            }
        }
        coversBound = true
    }
    
    private func layoutScene() {
        let w = size.width
        let h = size.height
        let center = CGPoint(x: 0, y: 0)
        
        let fieldW = w * fieldWidthFrac
        let fieldH = h * fieldHeightFrac
        fieldNode.size = CGSize(width: fieldW, height: fieldH)
        fieldNode.position = center
        
        let podiumW = w * podiumWidthFrac
        let podiumH = h * podiumHeightFrac
        let sidePad = w * sidePaddingFrac
        
        leftPodium.size = CGSize(width: podiumW, height: podiumH)
        rightPodium.size = CGSize(width: podiumW, height: podiumH)
        
        leftPodium.position = CGPoint(x: -w/2 + sidePad + podiumW/2,
                                      y: 0)
        rightPodium.position = CGPoint(x:  w/2 - sidePad - podiumW/2,
                                       y: 0)
        
        let petW = (w * 0.6)/2 / 7
        let petH = petW*1.2
        leftPet.size = CGSize(width: petW, height: petH)
        rightPet.size = CGSize(width: petW, height: petH)
        
        leftPet.position = CGPoint(x: leftPodium.position.x,
                                   y: leftPodium.position.y - podiumH*0.15)
        rightPet.position = CGPoint(x: rightPodium.position.x,
                                    y: rightPodium.position.y - podiumH*0.15)
        
        player.size = CGSize(width: petW*1.25, height: petH*1.75)
        enemy.size = CGSize(width: petW*1.75, height: petH*1.75)
        
        player.position = CGPoint(x: leftPodium.position.x,
                                  y: leftPodium.position.y + podiumH*0.25)
        enemy.position = CGPoint(x: rightPodium.position.x,
                                 y: rightPodium.position.y + podiumH*0.25)
        
        layoutJudges(fieldCenter: center, fieldW: fieldW, fieldH: fieldH)
        
        layoutCoversOnField(fieldCenter: center, fieldW: fieldW, fieldH: fieldH)
    }
    
    private func layoutCoversOnField(fieldCenter: CGPoint, fieldW: CGFloat, fieldH: CGFloat) {
        let coverSize = fieldW/2 / 7
        let rowStep   = coverSize * 1.1
        let colStep   = coverSize * 1.3
        let centerGap = coverSize
        let midY      = fieldCenter.y - fieldH * 0.05
        let highlightW = coverSize * 1.15
        
        func xLeft(c: Int)  -> CGFloat { fieldCenter.x - centerGap/2 - colStep * CGFloat(c + 1) }
        func xRight(c: Int) -> CGFloat { fieldCenter.x + centerGap/2 + colStep * CGFloat(c + 1) }
        
        for c in 0..<columnsPerSide {
            let rows = minRows + c
            let h = CGFloat(rows - 1) * rowStep + coverSize
            
            if c < leftHighlights.count {
                let n = leftHighlights[c]
                n.size = CGSize(width: highlightW, height: h)
                n.position = CGPoint(x: xLeft(c: c), y: midY)
            }
            if c < rightHighlights.count {
                let n = rightHighlights[c]
                n.size = CGSize(width: highlightW, height: h)
                n.position = CGPoint(x: xRight(c: c), y: midY)
            }
        }
        
        var li = 0, ri = 0
        
        for c in 0..<columnsPerSide {
            let rows = minRows + c
            let startY = midY - 0.5 * CGFloat(rows - 1) * rowStep
            let x = xLeft(c: c)
            for r in 0..<rows {
                if li < leftCovers.count {
                    let node = leftCovers[li]
                    node.size = CGSize(width: coverSize, height: coverSize)
                    node.position = CGPoint(x: x, y: startY + CGFloat(r) * rowStep)
                    li += 1
                }
            }
        }
        
        for c in 0..<columnsPerSide {
            let rows = minRows + c
            let startY = midY - 0.5 * CGFloat(rows - 1) * rowStep
            let x = xRight(c: c)
            for r in 0..<rows {
                if ri < rightCovers.count {
                    let node = rightCovers[ri]
                    node.size = CGSize(width: coverSize, height: coverSize)
                    node.position = CGPoint(x: x, y: startY + CGFloat(r) * rowStep)
                    ri += 1
                }
            }
        }
        
        while li < leftCovers.count { leftCovers[li].isHidden = true; li += 1 }
        while ri < rightCovers.count { rightCovers[ri].isHidden = true; ri += 1 }
        for i in 0..<((minRows+maxRows)*columnsPerSide/2) {
            leftCovers[i].isHidden = false
            rightCovers[i].isHidden = false
        }
        bindCoverRefsIfNeeded()
    }
    
    private func layoutJudges(fieldCenter: CGPoint, fieldW: CGFloat, fieldH: CGFloat) {
        let const = fieldW * judgeWidthFrac
        topJudge.size = CGSize(width: const*1.2, height: const*1.75)
        bottomJudge.size = CGSize(width: const, height: const*1.5)
        
        let dy = fieldH * judgesYOffsetFrac
        topJudge.position = CGPoint(x: fieldCenter.x, y: fieldCenter.y + dy)
        bottomJudge.position = CGPoint(x: fieldCenter.x, y: fieldCenter.y - dy)
    }
    
    private func highlight(side: Side, col: Int, on: Bool) {
        let cols = (side == .player) ? leftCols : rightCols
        let pads = (side == .player) ? leftHighlights : rightHighlights
        
        let pad = pads[col]
        pad.removeAllActions()
        pad.run(.fadeAlpha(to: on ? 0.9 : 0.0, duration: 0.15))
        
        for cover in cols[col] {
            cover.node.color = .white
            cover.node.colorBlendFactor = on ? 0.25 : 0.0
        }
    }
    
    func startGame() {
        resetAllCovers()
        playerProgress = 0; enemyProgress = 0
        playerHidden = nil; enemyHidden = nil
        rightPet.alpha = 1.0; leftPet.alpha = 1.0
        nextShooter = .player
        shotsThisRound = 0
        phase = .playerHide
        showPhase()
    }
    
    private func showPhase() {
        switch phase {
        case .playerHide:
            setActiveTurn(.player)
            let col = 4 - playerProgress
            highlight(side: .player, col: col, on: true)
            enableTouchesFor(side: .player, col: col, mode: .hide)

        case .enemyHide:
            setActiveTurn(.enemy)
            let col = 4 - enemyProgress
            highlight(side: .enemy, col: col, on: true)
            enemyChooseHide(in: col)

        case .playerGuess:
            setActiveTurn(.player)
            let col = 4 - enemyProgress
            highlight(side: .enemy, col: col, on: true)
            enableTouchesFor(side: .enemy, col: col, mode: .guess)

        case .enemyGuess:
            setActiveTurn(.enemy)
            let col = 4 - playerProgress
            highlight(side: .player, col: col, on: true)
            enemyMakeGuess(in: col)

        case .resolveHit(let side, let col, let idx, let hit):
            let shooterIsPlayer = (side == .enemy)
            setActiveTurn(shooterIsPlayer ? .player : .enemy)
            resolveThrow(side: side, col: col, idx: idx, hit: hit)

        case .advance:
            setActiveTurn(nil)
            nextTurn()
        }
    }
    
    private func resetAllCovers() {
        for c in 0..<columnsPerSide {
            for ref in leftCols[c] { ref.node.isHidden = false; ref.node.removeAllActions() }
            for ref in rightCols[c] { ref.node.isHidden = false; ref.node.removeAllActions() }
        }
    }
    
    private func playerShoot(at target: UpdaterCheckerInteractorCache, idx: Int) {
        let hit = (enemyHidden?.col == target.col && enemyHidden?.idx == idx)
        phase = .resolveHit(side: .enemy, col: target.col, idx: idx, hit: hit)
        showPhase()
    }
    
    private func enemyShoot(at target: UpdaterCheckerInteractorCache, idx: Int) {
        let hit = (playerHidden?.col == target.col && playerHidden?.idx == idx)
        phase = .resolveHit(side: .player, col: target.col, idx: idx, hit: hit)
        showPhase()
    }
    
    private func resolveThrow(side: Side, col: Int, idx: Int, hit: Bool) {
        let shooterIsPlayer = (side == .enemy)
        let shooter = shooterIsPlayer ? leftPet : rightPet
        let targetNode = (side == .enemy ? rightCols : leftCols)[col][idx].node

        touchMode = nil
        highlight(side: shooterIsPlayer ? .enemy : .player, col: col, on: false)
        setActiveTurn(shooterIsPlayer ? .player : .enemy)

        let shoot: () -> Void = {
            let ball = SKSpriteNode(imageNamed: "ball")
            ball.zPosition = 5; ball.position = shooter.position; self.addChild(ball)
            ball.run(.move(to: targetNode.position, duration: 1)) { [weak self] in
                guard let self else { return }
                ball.removeFromParent()
                self.explode(at: targetNode) {
                    if hit {
                        self.reveal(side)
                        self.resetSide(side)
                        self.nextShooter = (self.nextShooter == .player) ? .enemy : .player
                        self.phase = .advance
                        self.showPhase()
                        return
                    } else {
                        targetNode.isHidden = true
                    }

                    self.shotsThisRound += 1
                    self.nextShooter = (self.nextShooter == .player) ? .enemy : .player

                    if self.shotsThisRound >= 2 {
                        self.phase = .advance
                        self.showPhase()
                    } else {
                        self.phase = shooterIsPlayer ? .enemyGuess : .playerGuess
                        self.showPhase()
                    }
                }
            }
        }

        if !shooterIsPlayer { rightPet.run(.wait(forDuration: enemyWindupDelay)) { shoot() } }
        else { shoot() }
    }

    
    private func explode(at node: SKSpriteNode, completion: @escaping ()->Void) {
        let t1 = SKTexture(imageNamed: "explosion_1")
        let t2 = SKTexture(imageNamed: "explosion_2")
        let spr = SKSpriteNode(texture: t1); spr.zPosition = 6; spr.position = node.position; addChild(spr)
        spr.run(.sequence([.animate(with: [t1,t2], timePerFrame: 0.15),
                           .removeFromParent()])) { completion() }
    }
    
    private func movePet(_ side: Side, to p: CGPoint, completion: @escaping ()->Void) {
        let pet = (side == .player) ? leftPet : rightPet
        pet.run(.move(to: p, duration: 0.2), completion: completion)
    }
    
    private func reveal(_ side: Side) {
        if side == .enemy { rightPet.alpha = 1.0 } else { leftPet.alpha = 1.0 }
    }
    
    private func resetSide(_ side: Side) {
        if side == .enemy {
            rightPet.run(.move(to: rightPodium.position, duration: 0.2))
            for c in 0..<columnsPerSide { for ref in rightCols[c] { ref.node.isHidden = false } }
            enemyProgress = 0; enemyHidden = nil
        } else {
            leftPet.run(.move(to: leftPodium.position, duration: 0.2))
            for c in 0..<columnsPerSide { for ref in leftCols[c] { ref.node.isHidden = false } }
            playerProgress = 0; playerHidden = nil
        }
    }
    
    private func columnCenter(for side: Side, col: Int) -> CGPoint {
        let refs = (side == .enemy) ? rightCols[col] : leftCols[col]
        guard let first = refs.first?.node.position, let last = refs.last?.node.position else { return .zero }
        return CGPoint(x: first.x, y: (first.y + last.y) * 0.5)
    }
    
    private func enemyChooseHide(in col: Int) {
        setActiveTurn(.enemy)
        highlight(side: .enemy, col: col, on: false)
        touchMode = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + enemyHideThinkDelay) { [weak self] in
            guard let self else { return }

            let opts = self.rightCols[col].indices.filter { !self.rightCols[col][$0].node.isHidden }
            let idx = opts.randomElement() ?? 0
            self.enemyHidden = (col, idx)

            let mid  = self.columnCenter(for: .enemy, col: col)
            let dest = self.rightCols[col][idx].node.position

            self.rightPet.removeAllActions()
            let fadeIn  = SKAction.fadeIn(withDuration: 0.08)
            let toMid   = SKAction.move(to: mid,  duration: 0.18)
            let fadeOut = SKAction.fadeOut(withDuration: 0.10)
            let toDest  = SKAction.move(to: dest, duration: 0.20)

            self.rightPet.run(.sequence([fadeIn, toMid, fadeOut, toDest])) { [weak self] in
                self?.phase = (self?.nextShooter == .player) ? .playerGuess : .enemyGuess
                self?.showPhase()
            }
        }
    }
    
    private func enemyMakeGuess(in col: Int) {
        setActiveTurn(.enemy)
        highlight(side: .player, col: col, on: false)
        touchMode = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + enemyThrowThinkDelay) { [weak self] in
            guard let self else { return }
            let opts = self.leftCols[col].indices.filter { !self.leftCols[col][$0].node.isHidden }
            let idx = opts.randomElement() ?? 0

            self.rightPet.run(.wait(forDuration: self.enemyWindupDelay)) { [weak self] in
                guard let self else { return }
                self.enemyShoot(at: self.leftCols[col][idx], idx: idx)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let p = t.location(in: self)
        guard let mode = touchMode else { return }
        
        let cols = (touchSide == .player) ? leftCols : rightCols
        let hitList = cols[touchCol].enumerated().compactMap { (i, ref) -> (Int, UpdaterCheckerInteractorCache)? in
            ref.node.contains(p) && !ref.node.isHidden ? (i, ref) : nil
        }
        guard let (idx, ref) = hitList.first else { return }
        
        switch mode {
            
        case .hide:
            touchMode = nil
            highlight(side: touchSide, col: touchCol, on: false)
            guard touchSide == .player else { return }
            playerHidden = (touchCol, idx)
            movePet(.player, to: ref.node.position) { [weak self] in
                self?.phase = .enemyHide; self?.showPhase()
            }
        case .guess:
            touchMode = nil
            if touchSide == .enemy {
                playerShoot(at: ref, idx: idx)
            } else {
                enemyShoot(at: ref, idx: idx)
            }
        }
    }
    
    private func enableTouchesFor(side: Side, col: Int, mode: TouchMode) {
        touchMode = mode; touchSide = side; touchCol = col
    }
    
    private func nextTurn() {
        clearAllHighlights()
        if enemyHidden != nil { enemyProgress = min(enemyProgress + 1, 5) }
        if playerHidden != nil { playerProgress = min(playerProgress + 1, 5) }
        if finishIfReachedCenter() { return }
        playerHidden = nil
        enemyHidden  = nil
        shotsThisRound = 0
        phase = .playerHide
        showPhase()
    }
    
    private func setActiveTurn(_ side: Side?) {
        let active: CGFloat = 1.0
        let inactive: CGFloat = 0.35

        topJudge.removeAllActions()
        bottomJudge.removeAllActions()

        switch side {
        case .player?:
            bottomJudge.run(.fadeAlpha(to: inactive, duration: 0.15))
            topJudge.run(.fadeAlpha(to: active, duration: 0.15))
        case .enemy?:
            topJudge.run(.fadeAlpha(to: inactive, duration: 0.15))
            bottomJudge.run(.fadeAlpha(to: active, duration: 0.15))
        case nil:
            topJudge.alpha = active
            bottomJudge.alpha = active
        }
    }
    
    private func finishIfReachedCenter() -> Bool {
        if playerProgress >= 5 {
            touchMode = nil
            leftPet.alpha = 1.0
            leftPet.run(.move(to: .zero, duration: 0.25)) { [weak self] in
                self?.gameOver(playerWon: true)
            }
            return true
        }
        if enemyProgress >= 5 {
            touchMode = nil
            rightPet.alpha = 1.0
            rightPet.run(.move(to: .zero, duration: 0.25)) { [weak self] in
                self?.gameOver(playerWon: false)
            }
            return true
        }
        return false
    }
    
    private func gameOver(playerWon: Bool) {
        print("Игра окончена")
        if playerWon {
            gameViewModel?.showWinView()
        } else {
            gameViewModel?.showLoseView()

        }
    }
}

private enum Phase {
    case playerHide, enemyHide
    case playerGuess, enemyGuess
    case resolveHit(side: Side, col: Int, idx: Int, hit: Bool)
    case advance
}

private enum Side { case player, enemy }

private struct 

UpdaterCheckerInteractorCache{
    let node: SKSpriteNode
    let col: Int
    let idx: Int
}
