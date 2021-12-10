import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key : key);

  @override
  State<SearchBar> createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar>{
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
      child: AnimSearchBar(
        width: 300,
        textController: _controller,
        onSuffixTap: () {
          setState(() {
            _controller.clear();
          });
        },
        suffixIcon: const Icon(Icons.note_alt),
        prefixIcon: const Icon(Icons.search),
      )
    );
  }
}