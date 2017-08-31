import UIKit

private class SweetToolBar: UIToolbar {

    var touchMove: ((CGFloat) -> ())?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchEvent = touches.first!
        let preDy = touchEvent.previousLocation(in: self.superview).y
        let newDy = touchEvent.location(in: self.superview).y
        let dy = newDy - preDy
        touchMove?(dy)
    }
}
public extension UIImage {
    static func make(name: String) -> UIImage? {
        let bundle = Bundle(for: ConsoleView.self)
        let path = bundle.path(forResource: "Resources", ofType: "bundle")
        let resBundle = Bundle(path: path!)!
        return UIImage(contentsOfFile: resBundle.path(forResource: name, ofType: "png")!)
    }
}
public class ConsoleView: UIView {
    
    //MARK: - Properties
    public static let shared = ConsoleView()
    
    //Mark: - Struct
    private struct Misc {
        static let ConsViewHeight: CGFloat = 300
        static let toolBarHeight: CGFloat = 44
        static let bundle = Bundle(for: ConsoleView.self)
        
        static let showImage = UIImage.make(name: "show_up")// UIImage(contentsOfFile: Misc.bundle.path(forResource: "show_up", ofType: ".png")!)// UIImage(named: "show_up")
        static let hideImage = UIImage.make(name: "hide_down") //UIImage(contentsOfFile: Misc.bundle.path(forResource: "hide_down", ofType: ".png")!)//UIImage(named: "hide_down")
        static let trashImage = UIImage.make(name: "trash") //UIImage(contentsOfFile: Misc.bundle.path(forResource: "trash", ofType: ".png")!)//UIImage(named: "trash")
    }
    
    //MARK: - UI
    
    private lazy var hideBar: UIBarButtonItem = {
        return UIBarButtonItem(image: Misc.hideImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(hideBarClickAction))
    }()
    
    private lazy var toolBar: SweetToolBar = {
        let view = SweetToolBar()
        view.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: Misc.toolBarHeight)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let trashBar = UIBarButtonItem(image: Misc.trashImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(clearOutputAction))
        view.items = [self.hideBar, flexibleSpace, trashBar]
        return view
    }()
    
    private lazy var outputTextView: UITextView = {
        let view = UITextView()
        view.frame = CGRect(x: 0,
                            y: self.toolBar.frame.maxY,
                            width: self.bounds.width,
                            height: self.bounds.height - self.toolBar.bounds.height)
        view.font = UIFont.systemFont(ofSize: 11)
        view.textColor = .black
        view.backgroundColor = .clear
        view.isEditable = false
        return view
    }()
    
    //MARK: - Super Methods
    public init() {
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - Misc.ConsViewHeight, width: UIScreen.main.bounds.width, height: Misc.ConsViewHeight))
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(toolBar)
        addSubview(outputTextView)
        
        backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        
        toolBar.touchMove = { [weak self] vertical in
            guard let `self` = self else { return }
            
            if self.frame.origin.y + vertical < Misc.toolBarHeight { return }
            if self.frame.origin.y + vertical > UIScreen.main.bounds.height - Misc.toolBarHeight { return }
            self.frame.origin.y += vertical
            self.frame.size.height -= vertical
            self.hideBar.image = self.frame.size.height <= Misc.toolBarHeight ? Misc.showImage : Misc.hideImage
            self.outputTextView.frame.size.height = self.frame.size.height - Misc.toolBarHeight
        }
        
        SKLog.didAddLog = { [weak self] in
            self?.outputTextView.attributedText = SKLog.logAttrString
            self?.scrollToBottom()
        }
    }
    
    //MARK: - Private Methods
    @objc private func clearOutputAction() {
        SKLog.logAttrString = NSMutableAttributedString()
        outputTextView.attributedText = SKLog.logAttrString
    }
    
    @objc private func hideBarClickAction() {
        UIView.animate(withDuration: 0.25) {
            let hideY = UIScreen.main.bounds.height - self.toolBar.bounds.height
            self.frame.origin.y = self.frame.origin.y == hideY ? UIScreen.main.bounds.height - Misc.ConsViewHeight : hideY
            self.hideBar.image = self.frame.origin.y == hideY ? Misc.showImage : Misc.hideImage
            self.frame.size.height = self.frame.origin.y == hideY ? Misc.toolBarHeight : Misc.ConsViewHeight
            self.outputTextView.frame.size.height = self.frame.size.height - Misc.toolBarHeight
        }
    }
    
    func scrollToBottom() {
        guard outputTextView.frame.size.height <= outputTextView.sizeThatFits(outputTextView.frame.size).height else { return }
        let bottomOffsetY = self.outputTextView.contentSize.height - self.outputTextView.frame.size.height
        self.outputTextView.setContentOffset(CGPoint(x: 0, y: bottomOffsetY), animated: true)
    }
}
