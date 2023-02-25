import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUser();
}

class _CreateUser extends State<CreateUser> {
  String value = '';
  bool isButtonDisabled = true;

  // fetch from backend if user already exists and change state
  bool userAlreadyExists = false;

  final formGlobalKey = GlobalKey<FormState>();

  String? validateFormField(String? value) {
    if (userAlreadyExists) {
      return 'A user with that nickname already exists';
    }
    return null;
  }

  onNickNameChanged(value) {
    setState(() {
      this.value = value;
      isButtonDisabled = value.isEmpty;
    });
  }

  handleNext() {
    if (formGlobalKey.currentState!.validate()) {
      // TODO: create user, save to local storage and navigate to Profile creation
      print('User created with nickname: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create nickname'),
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: SafeArea(
              bottom: true,
              child: Column(children: <Widget>[
                Form(
                    key: formGlobalKey,
                    child: TextFormField(
                      validator: validateFormField,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '@nickname',
                      ),
                      onChanged: onNickNameChanged,
                    )),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const <Widget>[
                              Flexible(
                                  child: Text(
                                'Your nickname it’s your ID. It can’t be changed. Make sure to create appropriate nickname to use it forever.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff87899B),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                              ))
                            ]))),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: isButtonDisabled ? null : handleNext(),
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ])),
        ));
  }
}
