import Flutter
import UIKit
import CoreLocation

public class FlutterZLocationPlugin: NSObject, FlutterPlugin {
    var sysLocationManger: CLLocationManager?
    var locationResult: FlutterResult?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_z_location", binaryMessenger: registrar.messenger())
        let instance = FlutterZLocationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getCoordinate":
            locationResult = result
            loaction()
        default:
            result("notfond method")
            break
        }
    }

    private func loaction() {
        var lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        sysLocationManger = lm
    }
}

extension FlutterZLocationPlugin: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lo = locations.last {
            sysLocationManger?.stopUpdatingLocation()
            sysLocationManger = nil
            let dict: Dictionary<String, Any> = ["code": "00000",
                                                 "message": "定位成功",
                                                 "latitude": lo.coordinate.latitude.roundTo(places: 6),
                                                 "longitude": lo.coordinate.longitude.roundTo(places: 6)]
            locationResult?(dict)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        sysLocationManger?.stopUpdatingLocation()
        sysLocationManger = nil
        let dict: Dictionary<String, Any> = ["code": "A0001",
                                             "message": error.localizedDescription,
        ]
        locationResult?(dict)
    }
}


fileprivate extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))

        return (self * divisor).rounded() / divisor

    }

}
