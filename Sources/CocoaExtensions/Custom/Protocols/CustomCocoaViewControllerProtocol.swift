import CocoaAliases

public protocol CustomCocoaViewControllerProtocol:
  CocoaViewController,
  CustomNSObjectProtocol
{
  var onDismiss: Handler<Void>.Container { get set }
  var onViewDidLoad: Handler<Void>.Container { get set }
  var onViewWillAppear: Handler<Void>.Container { get set }
  var onViewDidAppear: Handler<Void>.Container { get set }
  var onViewWillDisappear: Handler<Void>.Container { get set }
  var onViewDidDisappear: Handler<Void>.Container { get set }
  var onViewWillLayout: Handler<Void>.Container { get set }
  var onViewDidLayout: Handler<Void>.Container { get set }
}
