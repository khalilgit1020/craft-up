import 'package:flutter/material.dart';

import '../../constants.dart';

class AppInformation extends StatelessWidget {
  const AppInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height / 8),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'معلومات التطبيق',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: mainColor,
            ),
          ),
          body: Column(
            children: const [
              SizedBox(
                height: 20,
              ),
              ExpansionTile(
                title: Text(
                  'سياسة الاستخدام ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'يمنع استخدام  خدمات التطبيق باي طريقة تخل بقوانين فلسطين , جميع محتويات التطبيق هيحقوق ملكية فكرية محفوظة ويمنع استخدامها باي شكل من أي اطراف اخرى',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'شروط العضوية:\n اختيار اسم لائق ومناسب خلال عملية التسجيل\n يلتزم العضو بعدم مشاركة معلومات عضويته ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'عن التطبيق',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'تطبيق يختص بفئة الحرفيين وأصحاب المشغولات اليدوية حيث يتم  الإعلان عن الوظائف الشاغرة واستقطاب الموظفين بصورة سهلة وسريعة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'مميزات التطبيق:\n يمكن استخدامه للإعلان او التقدم لوظيفة مباشرة بشكل مجاني\n يلتزم العضو بعدم مشاركة معلومات عضويته ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
