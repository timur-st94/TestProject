import Foundation

class Logs {
    
    /// Format response to pretty printed string
    public static func formatResponse(_ response: URLResponse?, request: URLRequest?, method: String?, data: Data? = nil) {
        guard let response = response else { return }
        var s = ""
        s += "⬇️ "
        
        if let method = method {
            s += "\(method)"
        } else if let method = request?.httpMethod {
            s += "\(method) "
        }
        
        if let url = response.url?.absoluteString {
            s += "'\(url)' "
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            s += "("
            let iconNumber = Int(floor(Double(httpResponse.statusCode) / 100.0))
            if let iconString = statusIconsForLogs[iconNumber] {
                s += "\(iconString) "
            }
            
            s += "\(httpResponse.statusCode)"
            if let statusString = statusStringsForLogs[httpResponse.statusCode] {
                s += " \(statusString)"
            }
            s += ")"
            
            if let startDate = request.flatMap({ URLProtocol.property(forKey: "ReqresRequestTimeKey", in: $0) }) as? Date {
                let difference = fabs(startDate.timeIntervalSinceNow)
                s += String(format: " [time: %.5f s]", difference)
            }
        }
        
        if let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: AnyObject], headers.count > 0 {
            s += "\n" + formatHeaders(headers)
        }
        
        s += "\nBody: \(formatBody(data))"
        print(s)
    }
    
    /// Format data from body to pretty printed string
    public static func formatBody(_ body: Data?) -> String {
        if let body = body {
            if let prettyPrint = body.prettyPrintedJSONString {
                return prettyPrint
            } else if let string = String(data: body, encoding: String.Encoding.utf8) {
                return string
            } else {
                return body.description
            }
        } else {
            return "nil"
        }
    }
    
    public static func formatHeaders(_ headers: [String: AnyObject]) -> String {
        var s = "Headers: [\n"
        for (key, value) in headers {
            s += "\t\(key) : \(value)\n"
        }
        s += "]"
        return s
    }
    
    public static func formatError(_ request: URLRequest, error: NSError) {
        var s = ""
        
        s += "⚠️ "
        
        if let method = request.httpMethod {
            s += "\(method) "
        }
        
        if let url = request.url?.absoluteString {
            s += "\(url) "
        }
        
        if let headers = request.allHTTPHeaderFields, headers.count > 0 {
            s += "\n" + formatHeaders(headers as [String : AnyObject])
        }
        
        //        s += "\nBody: \(formatBody(request.httpBodyData))"
        
        s += "ERROR: \(error.localizedDescription)"
        
        if let reason = error.localizedFailureReason {
            s += "\nReason: \(reason)"
        }
        
        if let suggestion = error.localizedRecoverySuggestion {
            s += "\nSuggestion: \(suggestion)"
        }
        
        print(s)
    }
    
    /// Format request to pretty printed string
    public static func formatRequest(_ request: URLRequest) {
        
        var s = ""
        
        s += "⬆️ "
        
        if let method = request.httpMethod {
            s += "\(method) "
        }
        
        if let url = request.url?.absoluteString {
            s += "'\(url)' "
        }
        
        if let headers = request.allHTTPHeaderFields, headers.count > 0 {
            s += "\n" + formatHeaders(headers as [String : AnyObject])
        }
        
        s += "\nBody: \(formatBody(request.httpBodyData))"
        
        print(s)
    }
    
    static let statusIconsForLogs = [
        1: "ℹ️",
        2: "✅",
        3: "⤴️",
        4: "⛔️",
        5: "❌"
    ]
    
    static let statusStringsForLogs = [
        // 1xx (Informational)
        100: "Continue",
        101: "Switching Protocols",
        102: "Processing",
        
        // 2xx (Success)
        200: "OK",
        201: "Created",
        202: "Accepted",
        203: "Non-Authoritative Information",
        204: "No Content",
        205: "Reset Content",
        206: "Partial Content",
        207: "Multi-Status",
        208: "Already Reported",
        226: "IM Used",
        
        // 3xx (Redirection)
        300: "Multiple Choices",
        301: "Moved Permanently",
        302: "Found",
        303: "See Other",
        304: "Not Modified",
        305: "Use Proxy",
        306: "Switch Proxy",
        307: "Temporary Redirect",
        308: "Permanent Redirect",
        
        // 4xx (Client Error)
        400: "Bad Request",
        401: "Unauthorized",
        402: "Payment Required",
        403: "Forbidden",
        404: "Not Found",
        405: "Method Not Allowed",
        406: "Not Acceptable",
        407: "Proxy Authentication Required",
        408: "Request Timeout",
        409: "Conflict",
        410: "Gone",
        411: "Length Required",
        412: "Precondition Failed",
        413: "Request Entity Too Large",
        414: "Request-URI Too Long",
        415: "Unsupported Media Type",
        416: "Requested Range Not Satisfiable",
        417: "Expectation Failed",
        418: "I'm a teapot",
        420: "Enhance Your Calm",
        422: "Unprocessable Entity",
        423: "Locked",
        424: "Method Failure",
        425: "Unordered Collection",
        426: "Upgrade Required",
        428: "Precondition Required",
        429: "Too Many Requests",
        431: "Request Header Fields Too Large",
        451: "Unavailable For Legal Reasons",
        
        // 5xx (Server Error)
        500: "Internal Server Error",
        501: "Not Implemented",
        502: "Bad Gateway",
        503: "Service Unavailable",
        504: "Gateway Timeout",
        505: "HTTP Version Not Supported",
        506: "Variant Also Negotiates",
        507: "Insufficient Storage",
        508: "Loop Detected",
        509: "Bandwidth Limit Exceeded",
        510: "Not Extended",
        511: "Network Authentication Required"
    ]
}

extension URLRequest {
    var httpBodyData: Data? {
        
        guard let stream = httpBodyStream else {
            return httpBody
        }
        
        let data = NSMutableData()
        stream.open()
        let bufferSize = 4_096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(buffer, maxLength: bufferSize)
            if bytesRead > 0 {
                let readData = Data(bytes: UnsafePointer<UInt8>(buffer), count: bytesRead)
                data.append(readData)
            } else if bytesRead < 0 {
                print("error occured while reading HTTPBodyStream: \(bytesRead)")
            } else {
                break
            }
        }
        stream.close()
        return data as Data
    }
}

