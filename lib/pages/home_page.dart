import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_task_webspark/api/webspark_api.dart';
import 'package:test_task_webspark/config/routes.dart';
import 'package:test_task_webspark/controllers/gateway_controller.dart';
import 'package:test_task_webspark/shared_widgets/custom_button.dart';
import 'package:test_task_webspark/utils/is_url.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController()
    ..text = "https://flutter.webspark.dev/flutter/api/";
  final gatewayController = GatewayController();

  bool isLoading = false;

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("Set valid Api base URL in order to continue",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.swap_horiz),
                const SizedBox(width: 10),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Expanded(
                    child: TextFormField(
                      controller: _textFieldController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'URL cannot be empty';
                        }
                        if (!isValidUrl(value.trim())) {
                          return 'Enter a valid URL';
                        }
                        return null;
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            !isLoading
                ? CustomButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      gatewayController
                          .setGatewayUrl(_textFieldController.text.trim());
                      final WebsparkApi websparkApi = WebsparkApi(
                        baseUrl: gatewayController.gatewayUrl,
                      );
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final tasks = await websparkApi.getTasks();
                        // ignore: use_build_context_synchronously
                        context.pushNamed(RoutesNames.process, extra: tasks);
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    text: 'Start counting process',
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
