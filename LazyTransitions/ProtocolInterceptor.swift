 final class ProtocolInterceptor: NSObject {
    var interceptedProtocols: [Protocol] { return _interceptedProtocols }
    private var _interceptedProtocols: [Protocol] = []

    weak var receiver: NSObjectProtocol?
    weak var middleMan: NSObjectProtocol?

    private func doesSelectorBelongToAnyInterceptedProtocol(aSelector: Selector) -> Bool {
        for aProtocol in _interceptedProtocols where sel_belongsToProtocol(aSelector, aProtocol) {
            return true
        }

        return false
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if middleMan?.responds(to: aSelector) == true,
            doesSelectorBelongToAnyInterceptedProtocol(aSelector: aSelector) {

            return middleMan
        }

        if receiver?.responds(to: aSelector) == true {
            return receiver
        }

        return super.forwardingTarget(for: aSelector)
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if middleMan?.responds(to: aSelector) == true &&
            doesSelectorBelongToAnyInterceptedProtocol(aSelector: aSelector) {
            return true
        }

        if receiver?.responds(to: aSelector) == true {
            return true
        }

        return super.responds(to: aSelector)
    }

    class func forProtocol(aProtocol: Protocol) -> ProtocolInterceptor {
        return forProtocols(protocols: [aProtocol])
    }

    class func forProtocols(protocols: Protocol ...) -> ProtocolInterceptor {
        return forProtocols(protocols: protocols)
    }

    class func forProtocols(protocols: [Protocol]) -> ProtocolInterceptor {
        let protocolNames = protocols.map { NSStringFromProtocol($0) }
        let sortedProtocolNames = protocolNames.sorted()
        let concatenatedName = sortedProtocolNames.joined(separator: ",")

        let theConcreteClass = concreteClassWithProtocols(protocols: protocols,
                                                          concatenatedName: concatenatedName,
                                                          salt: nil)


        let protocolInterceptor = theConcreteClass.init()
            as! ProtocolInterceptor
        protocolInterceptor._interceptedProtocols = protocols

        return protocolInterceptor
    }

    /**
     Return a subclass of `NSProtocolInterceptor` which conforms to specified
     protocols.

     - Parameter     protocols:          An array of Objective-C protocols. The
     subclass returned from this function will conform to these protocols.

     - Parameter     concatenatedName:   A string which came from concatenating
     names of `protocols`.

     - Parameter     salt:               A UInt number appended to the class name
     which used for distinguishing the class name itself from the duplicated.

     - Discussion: The return value type of this function can only be
     `NSObject.Type`, because if you return with `NSProtocolInterceptor.Type`,
     you can only init the returned class to be a `NSProtocolInterceptor` but not
     its subclass.
     */
    private class func concreteClassWithProtocols(
        protocols: [Protocol],
        concatenatedName: String,
        salt: UInt?
        ) -> NSObject.Type {

        let className: String = {
            let basicClassName = "_" +
                NSStringFromClass(ProtocolInterceptor.self) +
                "_" + concatenatedName

            if let salt = salt { return basicClassName + "_\(salt)" }
            else { return basicClassName }
        }()
        let nextSalt = salt.map {$0 + 1}

        if let theClass = NSClassFromString(className) {
            switch theClass {
            case let anInterceptorClass as ProtocolInterceptor.Type:
                let isClassConformsToAllProtocols: Bool = {
                    // Check if the found class conforms to the protocols
                    for eachProtocol in protocols
                        where !class_conformsToProtocol(anInterceptorClass,
                                                        eachProtocol)
                    {
                        return false
                    }
                    return true
                }()

                if isClassConformsToAllProtocols {
                    return anInterceptorClass
                } else {
                    return concreteClassWithProtocols(protocols: protocols,
                                                      concatenatedName: concatenatedName,
                                                      salt: nextSalt)
                }
            default:
                return concreteClassWithProtocols(protocols: protocols,
                                                  concatenatedName: concatenatedName,
                                                  salt: nextSalt)
            }
        } else {
            let subclass = objc_allocateClassPair(ProtocolInterceptor.self,
                                                  className,
                                                  0)
                as! NSObject.Type

            for eachProtocol in protocols {
                class_addProtocol(subclass, eachProtocol)
            }

            objc_registerClassPair(subclass)

            return subclass
        }
    }
 }

 /**
  Returns true when the given selector belongs to the given protocol.
  */
 func sel_belongsToProtocol(_ aSelector: Selector, _ aProtocol: Protocol) -> Bool {
    for optionBits: UInt in 0..<(1 << 2) {
        let isRequired = optionBits & 1 != 0
        let isInstance = !(optionBits & (1 << 1) != 0)

        var methodDescription = protocol_getMethodDescription(aProtocol, aSelector, isRequired, isInstance)

        if !objc_method_description_isEmpty(methodDescription: &methodDescription) {
            return true
        }
    }

    return false
 }

 func objc_method_description_isEmpty(methodDescription: inout objc_method_description) -> Bool {
    let ptr: UnsafePointer<Int8> = withUnsafePointer(to: &methodDescription) { pointer in
        let copy = pointer as UnsafePointer<objc_method_description>
        let opaque: OpaquePointer = OpaquePointer.init(copy)
        return UnsafePointer<Int8>.init(opaque)
    }
    for offset in 0..<MemoryLayout.size(ofValue: methodDescription) {
        if ptr[offset] != 0 { return false }
    }

    return true
 }
