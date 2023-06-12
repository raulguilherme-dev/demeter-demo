import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'constantes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _height = 500;
  bool isVisible = true;
  bool isVisibleForm = false;
  bool isButtonEnable = false;
  List<String> _options = ['Válvula', 'Bomba'];
  late String _selectedOption = 'Bomba';
  Map<String, List<String>> _selectedOptionRelated = {
    'Válvula': ['Litro', 'fluxo'],
    'Bomba': ['Minutos', 'tempo']
  };
  TextEditingController _valor = TextEditingController();
  final TextEditingController _timeController =
      MaskedTextController(mask: '00:00');

  void initState() {
    super.initState();

    _timeController.addListener(handleEnableButton);
    _valor.addListener(handleEnableButton);
  }

  void showIrrigatePage() {
    setState(() {
      _height = 700;
      isVisible = false;
      isVisibleForm = !isVisible;
    });
  }

  void closeIrrigatePage() {
    setState(() {
      _height = 500;
      isVisible = true;
      isVisibleForm = !isVisibleForm;
    });
  }

  void handleEnableButton() {
    setState(() {
      isButtonEnable =
          _timeController.text.length == 5 && _valor.text.isNotEmpty;
    });
  }

  Future<String> postData() async {
    try {
      var response = await http
          .post(Uri.parse("https://api-demeter.herokuapp.com/reqCultura"),
              body: json.encode({
                "valor": double.parse(_valor.text),
                "tipo": _selectedOptionRelated[_selectedOption]?[1].toString(),
                "horario": _timeController.text.toString()
              }),
              headers: {"content-type": "application/json"});

      Map jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['message'];
    } catch (e) {
      print(e);
      return "Falha ao enviar";
    }
  }

  Future<Map<String, dynamic>> getData(String uri) async {
    try {
      var response = await http.get(
        Uri.parse(uri),
      );
      print(response);
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      print(e);
      return {'message': 'Falha'};
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constantes.cor1, // Cor de fundo da barra de notificações
      statusBarBrightness:
          Brightness.light, // Brilho do texto na barra de notificações
    ));

    return Scaffold(
      backgroundColor: Constantes.cor1,
      body: SingleChildScrollView(
        child: SizedBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 15),
              child: Center(
                child: Text(
                  "Alface",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'assets/images/alface.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedOpacity(
                            opacity: isVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Opacity(
                              opacity: 0.67,
                              child: Container(
                                height: 91,
                                width: 91,
                                decoration: BoxDecoration(
                                    color: Constantes.cor3,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Temperatura',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: FutureBuilder<Map>(
                                        future: getData(
                                            'https://api-demeter.herokuapp.com/getClima'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text('Null'),
                                            );
                                          }

                                          if (snapshot.hasData) {
                                            return Center(
                                              child: Text(
                                                  '${snapshot.data!['temperatura'].toString().substring(0, 2)}°c',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                            );
                                          }

                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: Constantes.cor5,
                                                strokeWidth: 3),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedOpacity(
                            opacity: isVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Opacity(
                              opacity: 0.67,
                              child: Container(
                                height: 91,
                                width: 91,
                                decoration: BoxDecoration(
                                    color: Constantes.cor3,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Umidade',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: FutureBuilder<Map>(
                                        future: getData(
                                            'https://api-demeter.herokuapp.com/getClima'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text('Null'),
                                            );
                                          }

                                          if (snapshot.hasData) {
                                            return Center(
                                              child: Text(
                                                  '${snapshot.data!["umidade"].toString()}%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  )),
                                            );
                                          }

                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: Constantes.cor5,
                                                strokeWidth: 3),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70, left: 8),
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: isVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Opacity(
                              opacity: 0.3,
                              child: Container(
                                height: 73,
                                width: 179,
                                decoration: BoxDecoration(
                                    color: Constantes.cor4,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Opacity(
                              opacity: 0.67,
                              child: Container(
                                height: 73,
                                width: 179,
                                decoration: BoxDecoration(
                                    color: Constantes.cor3,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Proxima Irrigação:'),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: FutureBuilder<Map>(
                                        future: getData(
                                            'https://api-demeter.herokuapp.com/reqCultura'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text('Null'),
                                            );
                                          }

                                          if (snapshot.hasData) {
                                            return Center(
                                              child: Text(
                                                  snapshot.data!['horario']
                                                      .toString()
                                                      .substring(0, 5),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                            );
                                          }

                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: Constantes.cor5,
                                                strokeWidth: 3),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.maxFinite,
                      height: _height,
                      decoration: BoxDecoration(
                          color: Constantes.cor1,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: isVisibleForm ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Visibility(
                              visible: isVisibleForm,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Constantes.cor1,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(2, 2),
                                                    blurRadius: 1,
                                                    spreadRadius: .2)
                                              ],
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: .3)),
                                          child: IconButton(
                                              icon: Icon(Icons
                                                  .arrow_back_ios_new_rounded),
                                              iconSize: 40,
                                              onPressed: closeIrrigatePage),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                          "Selecione o tipo de Irrigação:"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: SizedBox(
                                      width: 190,
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Constantes.cor5))),
                                        value: _selectedOption,
                                        items: _options
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ))
                                            .toList(),
                                        onChanged: (item) => setState(
                                            () => _selectedOption = item!),
                                      ),
                                    ),
                                  ),
                                  if (_selectedOption == "Bomba")
                                    Text(
                                        'Informe o tempo da irrigação em minutos:')
                                  else if (_selectedOption == "Válvula")
                                    Text(
                                        'Informe a quantide de água que deseja irrigar em litros:'),
                                  Container(
                                    width: 190,
                                    child: TextField(
                                      controller: _valor,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: _selectedOptionRelated[
                                              _selectedOption]?[0]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                        'Informe o horário que deseja realizar a irrigação: '),
                                  ),
                                  Container(
                                    width: 190,
                                    child: TextField(
                                      controller: _timeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText: 'Horário',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: ElevatedButton(
                                      onPressed: isButtonEnable
                                          ? () {
                                              postData().then((response) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(response),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              });
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          fixedSize: Size(200, 45),
                                          backgroundColor: Constantes.cor5),
                                      child: Text("Agendar"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: AnimatedOpacity(
                              opacity: isVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: Visibility(
                                visible: isVisible,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: isVisible ? 200 : 0),
                                  child: ElevatedButton(
                                      onPressed: showIrrigatePage,
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          fixedSize: Size(200, 45),
                                          backgroundColor: Constantes.cor5),
                                      child: Text("Agendar Irrigação")),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
