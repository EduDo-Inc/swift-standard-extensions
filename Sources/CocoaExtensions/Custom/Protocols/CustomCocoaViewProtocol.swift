#if !os(watchOS)
import CocoaAliases

public protocol CustomCocoaViewProtocol: CocoaView, CustomNSObjectProtocol {}
#endif
