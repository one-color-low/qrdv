import SwiftUI

struct SecondView: View {
    @ObservedObject var viewModel : ScannerViewModel

    var body: some View {
        Text("SecondView")

        ZStack {
            // QRコード読み取りView
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .interval(delay: self.viewModel.scanInterval)

            VStack {
                VStack {
                    Text("Keep scanning for QR-codes")
                        .font(.subheadline)

                    Text("QRコード読み取り結果 = [ " + self.viewModel.lastQrCode + " ]")
                        .bold()
                        .lineLimit(5)
                        .padding()

                    Button("Close") {
                        self.viewModel.isShowing = false
                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }.padding()
        }
    }
}
