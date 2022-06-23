import 'package:flutter/material.dart';

class ActionBar extends StatefulWidget {
  final String hintMessage;
  const ActionBar({Key? key, required this.hintMessage}) : super(key: key);

  @override
  State<ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 70,
        // width: 50,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                ),
                child: TextFormField(
                  controller: _textEditingController,
                  maxLines: 5,
                  minLines: 1,
                  // focusNode: focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintMessage,
                    hintMaxLines: 1,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF54656F),
                  ),
                  onPressed: () {
                    if (_textEditingController.text != '') {
                      // sendMessage(_textEditingController.text);
                      _textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
