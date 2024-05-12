import 'package:flutter/material.dart';

class searchBar extends StatelessWidget {
  const searchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: Icon(Icons.close),
          suffixIconColor: Colors.grey,
          prefixIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 216, 199),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Icon(Icons.search)),
          prefixIconColor: const Color.fromARGB(255, 221, 136, 75),
          contentPadding: EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          hintText: "    Search by name",
          hintStyle: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

class InputField extends StatelessWidget {
  TextEditingController inputController = new TextEditingController();

  String? text;
  double size;
  InputField(
      {super.key,
      required this.inputController,
      this.text,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(size),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          hintText: text ?? "",
          hintStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
