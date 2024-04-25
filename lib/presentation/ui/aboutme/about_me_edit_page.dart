import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/data/remote/model/request/create_job_request.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/aboutme/bloc/about_me_bloc.dart';
import 'package:job_baraka/presentation/ui/main/main_page.dart';

class AboutMeEditPage extends StatefulWidget {
  final int serviceId;

  const AboutMeEditPage({super.key, required this.serviceId});

  @override
  State<AboutMeEditPage> createState() => _AboutMeEditPageState();
}

class _AboutMeEditPageState extends State<AboutMeEditPage> {
  final TextEditingController _controller = TextEditingController();
  final _bloc = AboutMeBloc();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(LocaleKeys.about_us_text_title.tr(),
              style: TextStyle(fontFamily: 'Mulish', fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(42, 50, 75, 1))),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    _bloc.add(CreateJobEvent(request: CreateJobRequest(description: _controller.text, serviceId: widget.serviceId)));
                  },
                  icon: const Icon(Icons.check)),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocListener<AboutMeBloc, AboutMeState>(
            listener: (context, state) {
              if (state is CreateJobState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                    (route) => false);
              }
            },
            child: BlocBuilder<AboutMeBloc, AboutMeState>(
              builder: (context, state) {
                if (state is AboutMeLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.blue, fontFamily: 'Mulish'),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Color.fromRGBO(42, 50, 75, 1)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: -10),
                  ),
                  style:
                      const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
