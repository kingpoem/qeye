import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // 无状态组件
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { // 返回整个页面
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "科技赋能 智慧诊断",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "做题全队工作室",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                    width: 220,
                    height: 220,
                    child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.contain,
                    ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50), // 控制左右的间距，随你调节
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton("智能报告"),
                      _buildButton("专家会诊"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton("AI 问答"),
                      _buildButton("个性医疗"),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {},
                  child: const Text("进入"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildButton(String text) {
    return SizedBox(
      width: 140,   // 你可以调整，比如 160 / 180
      height: 50,   // 控制高度
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}
