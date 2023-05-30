import Foundation

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.dateStyle = .none
    return formatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self)}
}
