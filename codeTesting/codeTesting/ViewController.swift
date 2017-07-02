//  ViewController.swift
//  codeTesting


import UIKit

class ViewController: UIViewController {
  
  var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMenuBar()
  }
  
  lazy var menuBar: MenuBar = {
    let mb = MenuBar()
    mb.viewController = self
    return mb
  }()
  
  func setupMenuBar() {
    view.addSubview(menuBar)
    view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
    view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
    menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
  }
  
  class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var viewController: ViewController?
    
    lazy var cView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      cv.backgroundColor = UIColor.lightGray
      cv.dataSource = self
      cv.delegate = self
      return cv
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      cView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
      addSubview(cView)
      addConstraintsWithFormat("H:|[v0]|", views: cView)
      addConstraintsWithFormat("V:|[v0]|", views: cView)
      //intially select the first menuBar cell
      let selectedIndexPath = IndexPath(item: 0, section: 0)
      cView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if let numData = viewController?.data.count {
        return numData
      } else {
        return 3
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
      let numData = indexPath.item+1
      cell.imageView.image = UIImage(named: "num-\(numData)")?.withRenderingMode(.alwaysTemplate)
      cell.tintColor = UIColor.white
      cell.itemLabel.text = viewController?.data[indexPath.item]
      return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
  
  class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(imageView)
      addSubview(itemLabel)
      addConstraintsWithFormat("H:[v0(30)]", views: imageView)
      addConstraintsWithFormat("H:[v0(50)]", views: itemLabel)
      addConstraintsWithFormat("V:[v0(20)][v1(20)]", views: imageView,itemLabel)
      
    }
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    let imageView: UIImageView = {
      let iv = UIImageView()
      return iv
    }()
    
    var itemLabel: UILabel = {
      let label = UILabel()
      return label
    }()
  }
  
}
extension UIView {
  func addConstraintsWithFormat(_ format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDictionary[key] = view
    }
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
}
