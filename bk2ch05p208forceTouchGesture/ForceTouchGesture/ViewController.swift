
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let circle = CircleView(frame:CGRect(100,100,100,100))
        self.view.addSubview(circle)
        NotificationCenter.default.addObserver(forName: CircleView.pop, object: nil, queue: .main) {
            n in
            let minW = 50 as UInt32
            let maxW = 150 as UInt32
            let randW = arc4random_uniform(maxW-minW) + minW
            let minX = 0 as UInt32
            let minY = 20 as UInt32
            let maxX = UInt32(self.view.bounds.width) - randW
            let maxY = UInt32(self.view.bounds.height) - randW
            let randX = arc4random_uniform(maxX-minX) + minX
            let randY = arc4random_uniform(maxY-minY) + minY
            let circle = CircleView(frame:CGRect(CGFloat(randX),CGFloat(randY),CGFloat(randW),CGFloat(randW)))
            self.view.addSubview(circle)
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

class CircleView: UIView, UIPreviewInteractionDelegate {
    private var prev : UIPreviewInteraction!
    static let pop = Notification.Name("pop")
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.isOpaque = false // in iOS 12, not needed?
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        p.fill()
    }
    override func didMoveToSuperview() {
        self.prev = UIPreviewInteraction(view: self)
        self.prev.delegate = self
    }
    func previewInteractionDidCancel(_ : UIPreviewInteraction) {
        self.transform = .identity
        self.alpha = 1
    }
    func previewInteraction(_ : UIPreviewInteraction,
                            didUpdatePreviewTransition prog: CGFloat,
                            ended: Bool) {
        let scale = prog + 1
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        let alph = ((1-prog)*0.6) + 0.3
        // print(alph)
        self.alpha = alph
        if ended {
            NotificationCenter.default.post(name: CircleView.pop, object: nil)
            self.removeFromSuperview()
        }
    }
    deinit {
        print("poof")
    }
}

