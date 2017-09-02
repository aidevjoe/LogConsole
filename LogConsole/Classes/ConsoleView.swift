import UIKit

private class MoveToolBar: UIToolbar {
    
    var touchMove: ((CGFloat) -> ())?
    var touchEnd: (() -> ())?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchEvent = touches.first!
        let preDy = touchEvent.previousLocation(in: self.superview).y
        let newDy = touchEvent.location(in: self.superview).y
        let dy = newDy - preDy
        touchMove?(dy)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd?()
    }
}

public class ConsoleView: UIView {
    
    //MARK: - Properties
    public static let shared = ConsoleView()
    
    // Minimum height 130
    public var height: CGFloat = Misc.ConsViewHeight
    
    //Mark: - Struct
    private struct Misc {
        static let ConsViewHeight: CGFloat = 300
        static let toolBarHeight: CGFloat = 40
        static let minHeight: CGFloat = 130
    }
    
    //MARK: - UI
    
    private lazy var hideBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .center
        btn.setImage(UIImage.make(name: "down"), for: .normal)
        btn.setImage(UIImage.make(name: "up"), for: .selected)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(hideBarClickAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var toolBar: MoveToolBar = {
        let view = MoveToolBar()
        view.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: Misc.toolBarHeight)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let btn = UIButton()
        btn.imageView?.contentMode = .center
        btn.setImage(UIImage.make(name: "trash"), for: .normal)
        btn.addTarget(self, action: #selector(clearOutputAction), for: .touchUpInside)
        btn.sizeToFit()
        let trashBar = UIBarButtonItem(customView: btn)
        
        let hideBar = UIBarButtonItem(customView: self.hideBtn)
        
        view.items = [hideBar, flexibleSpace, trashBar]
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
        view.indicatorStyle = .white
        view.showsHorizontalScrollIndicator = true
        return view
    }()
    
    //MARK: - Super Methods
    public init(height: CGFloat = Misc.ConsViewHeight) {
        self.height = height < Misc.minHeight ? Misc.minHeight : height
        super.init(frame: CGRect(x: 0,
                                 y: UIScreen.main.bounds.height - height,
                                 width: UIScreen.main.bounds.width,
                                 height: height))
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
            self.hideBtn.isSelected = self.frame.size.height <= Misc.toolBarHeight
            self.outputTextView.frame.size.height = self.frame.size.height - Misc.toolBarHeight
        }
        
        toolBar.touchEnd = { [weak self] in
            guard let `self` = self, self.frame.size.height < Misc.minHeight else { return }
            self.toggle()
        }
        
        Logger.didAddLog = { [weak self] in
            self?.outputTextView.attributedText = Logger.logAttrString
            self?.scrollToBottom()
        }
    }
    
    //MARK: - Private Methods
    @objc private func clearOutputAction() {
        Logger.logAttrString = NSMutableAttributedString()
        outputTextView.attributedText = Logger.logAttrString
    }
    
    @objc private func hideBarClickAction() {
        self.toggle()
    }
    
    func toggle() {
        UIView.animate(withDuration: 0.25) {
            let hideY = UIScreen.main.bounds.height - self.toolBar.bounds.height
            self.frame.origin.y = self.frame.origin.y == hideY ? UIScreen.main.bounds.height - self.height : hideY
            self.frame.size.height = UIScreen.main.bounds.height - self.frame.origin.y
            self.hideBtn.isSelected = self.frame.height == Misc.toolBarHeight
            self.outputTextView.frame.size.height = self.frame.size.height - Misc.toolBarHeight
        }
    }
    
    func scrollToBottom() {
        guard outputTextView.frame.size.height <= outputTextView.sizeThatFits(outputTextView.frame.size).height else { return }
        let bottomOffsetY = self.outputTextView.contentSize.height - self.outputTextView.frame.size.height
        self.outputTextView.setContentOffset(CGPoint(x: 0, y: bottomOffsetY), animated: true)
    }
}
