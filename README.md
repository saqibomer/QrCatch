# QrCatch
QR code or Quick Response)code is a kind of 2d bar code which can be used to track various products/ identities. `QrCatch` can be used to catch and decode QR code of following types.

1. UPC-E (AVMetadataObjectTypeUPCECode)
2. Code 39 (AVMetadataObjectTypeCode39Code)
3. Code 39 mod 43 (AVMetadataObjectTypeCode39Mod43Code)
4. Code 93 (AVMetadataObjectTypeCode93Code)
5. Code 128 (AVMetadataObjectTypeCode128Code)
6. EAN-8 (AVMetadataObjectTypeEAN8Code)
7. EAN-13 (AVMetadataObjectTypeEAN13Code)
8. Aztec (AVMetadataObjectTypeAztecCode)
9. PDF417 (AVMetadataObjectTypePDF417Code)


## Demo
[View Demo](http://i.imgur.com/bmm3dXP.gifv)

<blockquote class="imgur-embed-pub" lang="en" data-id="a/AUjW0"><a href="//imgur.com/AUjW0"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>


## Usage
Using QrCatcher is very simple. 

1. Add `QRCatcher.Swift` in your project. 
2. In your `viewController` conform to `QrCatchedCodeDelegate` delegate as

`class ViewController: UIViewController, QrCatchedCodeDelegate {`
3. Create Instance of `QrCatch`

`let qrCatch = QRCatcher()`
4. Assign Delegate in your `viewController`

`qrCatch.delegate = self`
5. Add Delegate Method

`func fetchecodedString(code: String){`
  `print(code)`
`}`
