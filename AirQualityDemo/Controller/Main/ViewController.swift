//
//  ViewController.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2024/12/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var dataSource: [String] = ["行事曆", "顯示項目2", "顯示項目3", "顯示項目4", "顯示項目5"]
    var burgerButton = UIButton() //用於觸發的按鈕
    let burgerTableView = UITableView() //下拉出現的表單
    let burgerTransparentView = UIView()//黑色透明背景
    
    @IBOutlet weak var selectOptionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBurgerTableView()
        
    }
    
    // 按下按鈕顯示下拉選單
    @IBAction func popBurgerList(_ sender: Any) {
        burgerButton = selectOptionButton //將綁定的按鈕賦值給burgerButton
        addBurgerTransparentView(frames: selectOptionButton.frame) //顯示黑色背景和下拉選單
        
    }
    
    //配置下拉選單的表格 UITableView 的基礎屬性
    func setBurgerTableView() {
        burgerTableView.delegate = self //設置表格的代理
        burgerTableView.dataSource = self //設置表格的數據源
        burgerTableView.isScrollEnabled = false //關閉滾動
        burgerTableView.register(BurgerTableViewCell.self, forCellReuseIdentifier: "DemoCell") //註冊Cell
        burgerTableView.separatorStyle = .none //隱藏表格分隔線
    }
    
    //添加透明背景和表格,實現下拉選單效果
    func addBurgerTransparentView(frames: CGRect){
        // 獲取當前的視窗Window ，如果找不到就用控制器的view
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        burgerTransparentView.frame = window?.frame ?? self.view.frame //設置透明背景的大小
        self.view.addSubview(burgerTransparentView)// 將透明背景加入主視圖
        
        //設置表格的初始位置（寬度為0，逐步展開）
        burgerTableView.frame = CGRect(
            x: self.view.bounds.minX, //初始位置稍微偏移
            y: 0,  //按鈕下方
            width: 0, //初始寬度
            height: self.view.frame.height / 1.3 //表格高度設為螢幕的 1/1.3
        )
        self.view.addSubview(burgerTableView) //將表格加入主視圖
        burgerTableView.layer.cornerRadius = 10 //圓角
        burgerTableView.alpha = 1 //半透明
        
        //設置透背景的顏色（黑色，透明度0.9）
        burgerTransparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        burgerTableView.reloadData() //重新加載數據源
        
        //點擊透明背景時，關閉下拉選單
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeBurgerTransparentView))
        burgerTransparentView.addGestureRecognizer(tapGesture) //加入點擊動作
        
        //動畫效果：透明背景淡入，下拉選單展開
        burgerTransparentView.alpha = 0
        UIView.animate(
            withDuration: 0.8, //動畫持續時間 0.4 秒
            delay: 0.0, //動畫開始前的延遲時間為0秒,立刻執行
            usingSpringWithDamping: 1.0,  //彈性阻尼係數，1.0表示沒有彈跳效果
            initialSpringVelocity: 1.0, //初始速度， 1.0表示正常速度
            options: .overrideInheritedCurve,
            animations: { [self] in
                //執行動畫內容
                self.burgerTransparentView.alpha = 0.3 //逐漸變透明背景
                self.burgerTableView.frame = CGRect(
                    x: self.view.bounds.minX - 10, //表格的 x 座標（向左稍微偏移 10 像素已對齊
                    y: 0, //表格的 y 座標，位於按鈕下方
                    width: self.view.frame.width / 2 + 10, //展開後的寬度（螢幕寬度的一半加 10 像素）
                    height: self.view.frame.height / 1.3) //表格最終的高度（螢幕高度的 1.3 分之一）
                
            }, completion: nil) // 動畫完成後的處理，這裡設為 nil，表示無需進一步動作
    }
    
    //點擊透明背景時，關閉下拉選單
    @objc func removeBurgerTransparentView() {
        let frames = burgerButton.frame //獲取觸發按鈕的 frame
        UIView.animate(
            withDuration: 1.2, //動畫時長
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .overrideInheritedCurve,
            animations: { [self] in
                self.burgerTransparentView.alpha = 0 //背景逐漸消失
                self.burgerTableView.frame = CGRect(
                    x: self.view.bounds.minX - 10,
                    y: 0,
                    width: 0, //收起的寬度
                    height: self.view.frame.height / 1.3) //表格的高度不變
            }, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //            self.navigationController?.pushViewController(SchedulePageVC(), animated: true)
            navigateToViewController(storyBoardID: "SchedulePage", nextVC: "SchedulePageVC")
        }
    }
    
}

extension ViewController {
    
    func navigateToViewController(storyBoardID: String, nextVC: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardID, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: nextVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
