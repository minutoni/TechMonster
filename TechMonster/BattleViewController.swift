//
//  BattleViewController.swift
//  TechMonster
//
//  Created by 所　紀彦 on 2019/04/11.
//  Copyright © 2019 所　紀彦. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    var enemyAttackTimer: Timer!
    
    var enemy: Enemy!
    var player: Player! //LobbyviewControllerから渡される
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var attackButton: UIButton!
    
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var playerImageView: UIImageView!
    
    @IBOutlet var enemyHPBar: UIProgressView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var playerNamelabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //標準だとprogressbarbが細いので拡大
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        
        //プレイヤーのデータをリセット
        playerNamelabel.text = player.name
        playerImageView.image = player.image
        playerHPBar.progress = player.currentHP / player.maxHP
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startBattle()
    }
    
    func startBattle(){
        TechDraUtil.playBGM(fileName: "BGM_battle001")
        
        enemy = Enemy()
        
        //敵のデータをセット
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
        
        //こうげきボタン
        attackButton.isHidden = true
        
        //敵の自動こうげき
        enemyAttackTimer = Timer.scheduledTimer(timeInterval: enemy.attackInterval, target: self, selector: #selector(self.enemyAttack),userInfo: nil,repeats: true)
    }
    
    @IBAction func playerAttack(){
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        //HPの更新
        enemy.currentHP = enemy.currentHP - player.attackPower
        enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP , animated: true)
        
        //敵の敗北
        if enemy.currentHP < 0 {
            TechDraUtil.animateVanish(enemyImageView)
            finishBattle(winPlayer: true)
        }
    }
    
    func finishBattle(winPlayer: Bool){
        TechDraUtil.stopBGM()
        
        //こうげきボタンを隠す
        attackButton.isHidden = true
        
        //アラートを表示
        let finishedMessage: String
        if winPlayer == true {
            TechDraUtil.playSE(fileName: "SE_fanfare")
            finishedMessage = "プレイヤーの勝利！！"
        }else{
            TechDraUtil.playSE(fileName: "SE_gameover")
            finishedMessage = "プレイヤーの敗北...."
        }
        let alert = UIAlertController(title: "バトル終了!", message: finishedMessage, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {actioin in
            //OKを押すと、モーダルを消してLobbyViewControllerに戻る
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        self.present(alert, animated: true,completion: nil)
    }
    
    
    
    @objc func enemyAttack(){
        TechDraUtil.animateDamage(playerImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        //HPの更新
        player.currentHP = player.currentHP - player.attackPower
        playerHPBar.setProgress(player.currentHP / player.maxHP, animated: true)
        
        //プレイヤーの敗北
        if player.currentHP < 0 {
            TechDraUtil.animateVanish(playerImageView)
            finishBattle(winPlayer: false)
        }
    }
    
    
    
    
    }




    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

