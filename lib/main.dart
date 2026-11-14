import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff345d87)),
      scaffoldBackgroundColor: const Color(0xfffafafa),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff345d87),
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
      ),
    ),
    home: const AuthScreen(),
  );
}

enum AuthMode { login, signup, reset }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.mode = AuthMode.login});
  final AuthMode mode;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool hidden = true;
  static const validation = true;
  String? requiredValue(String? value) =>
      value == null || value.trim().isEmpty ? 'Обов’язкове поле' : null;
  String? emailValue(String? value) {
    final error = requiredValue(value);
    if (error != null) return error;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())
        ? null
        : 'Введіть коректний email';
  }

  String? passwordValue(String? value) {
    final error = requiredValue(value);
    if (error != null) return error;
    return value!.length >= 7 ? null : 'Щонайменше 7 символів';
  }

  void submit() {
    FocusScope.of(context).unfocus();
    if (validation && !formKey.currentState!.validate()) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Навчальна демонстрація'),
        content: Text(switch (widget.mode) {
          AuthMode.login => 'Форму входу прийнято. Сервер не підключено.',
          AuthMode.signup => 'Форму реєстрації прийнято. Дані не надсилаються.',
          AuthMode.reset =>
            'Запит перевірено. Лист не надсилається без сервера.',
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void open(AuthMode mode) => Navigator.push<void>(
    context,
    MaterialPageRoute(builder: (_) => AuthScreen(mode: mode)),
  );
  Widget field(
    String label,
    String key, {
    bool password = false,
    bool email = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      key: ValueKey(key),
      obscureText: password && hidden,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      autocorrect: !password && !email,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: password
            ? IconButton(
                tooltip: hidden ? 'Показати пароль' : 'Приховати пароль',
                onPressed: () => setState(() => hidden = !hidden),
                icon: Icon(
                  hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
      ),
      validator: validation
          ? (password
                ? passwordValue
                : email
                ? emailValue
                : requiredValue)
          : null,
    ),
  );
  @override
  Widget build(BuildContext context) {
    final login = widget.mode == AuthMode.login;
    final signup = widget.mode == AuthMode.signup;
    final title = login
        ? 'Вхід'
        : signup
        ? 'Реєстрація'
        : 'Відновлення пароля';
    return Scaffold(
      appBar: AppBar(title: Text('Практична №8 • $title')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (box.maxHeight - 48).clamp(0, double.infinity),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/flutter_mark.png',
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Flutter',
                              style: TextStyle(
                                fontSize: 36,
                                color: Color(0xff606060),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        if (!login) ...[
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (signup) field('Ім’я користувача', 'name'),
                        field('Email', 'email', email: true),
                        if (widget.mode != AuthMode.reset)
                          field('Пароль', 'password', password: true),
                        if (login) ...[
                          OutlinedButton(
                            key: const ValueKey('signup'),
                            onPressed: () => open(AuthMode.signup),
                            child: const Text('Зареєструватися'),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  key: const ValueKey('submit'),
                                  onPressed: submit,
                                  child: const Text('Увійти'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextButton(
                                  key: const ValueKey('reset'),
                                  onPressed: () => open(AuthMode.reset),
                                  child: const Text('Забули пароль?'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          ElevatedButton(
                            key: const ValueKey('submit'),
                            onPressed: submit,
                            child: Text(
                              signup ? 'Зареєструватися' : 'Відновити пароль',
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Назад до входу'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
