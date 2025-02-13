import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class UsdtTronScreen extends StatefulWidget {
  final String? platformId;
  final String? message;
  const UsdtTronScreen({super.key, this.platformId, this.message});

  @override
  State<UsdtTronScreen> createState() => _UsdtTronScreenState();
}

class _UsdtTronScreenState extends State<UsdtTronScreen> {
  final TextEditingController transactionIdController = TextEditingController();
 late final TextEditingController messageController = TextEditingController(text: widget.message);
  final String walletAddress = "TTe1r2AzVMrFPthUDTxVAJmGGyJjWNSWDD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nạp USDT qua TRON'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: QrImageView(
                data: walletAddress,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hướng dẫn nạp USDT:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Vui lòng nạp USDT vào địa chỉ ví dưới đây:',
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(walletAddress),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: walletAddress));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã sao chép địa chỉ ví')),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: transactionIdController,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                verifyTransactionId(transactionIdController.text);
              },
              child: Text('Xác minh Transaction ID'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyTransactionId(String transactionId) async {
    try {
      print('Bắt đầu kiểm tra giao dịch với ID: $transactionId');
      final url = 'https://apilist.tronscan.org/api/transaction-info?hash=$transactionId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['confirmed'] == true) {
          // Kiểm tra địa chỉ ví nhận có đúng không
          final toAddress = data['trc20TransferInfo']?[0]?['to_address'];
          if (toAddress != walletAddress) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Địa chỉ ví nhận không đúng')),
            );
            return;
          }

          // Kiểm tra trạng thái và hiển thị thông tin
          if (data['contractRet'] == 'SUCCESS') {
            final amount = int.parse(data['trc20TransferInfo'][0]['amount_str']) / 1000000;
            final fromAddress = data['trc20TransferInfo'][0]['from_address'];
            final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                'Giao dịch hợp lệ\n'
                'Số tiền: $amount USDT\n'
                'Từ ví: $fromAddress\n'
                'Thời gian: ${timestamp.toString()}'
              )),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Giao dịch thất bại')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Giao dịch chưa được xác nhận')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi kiểm tra giao dịch')),
        );
      }
    } catch (e) {
      print('Lỗi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

}
