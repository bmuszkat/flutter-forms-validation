import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/user_provider.dart';
import 'package:formvalidation/src/utils/utils.dart';
//import 'package:formvalidation/src/pages/home_page.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(child: circulo, top: 90.0, left: 30.0),
        Positioned(child: circulo, top: -40.0, right: -30.0),
        Positioned(child: circulo, bottom: -50.0, right: -10.0),
        Positioned(child: circulo, bottom: 120.0, right: 20.0),
        Positioned(child: circulo, bottom: -50.0, left: -20.0),
        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text(
                'Brian Muszkat',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              )
            ],
          ),
        )
      ],
    );
  }

  _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 160.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: (Offset(0.0, 5.0)),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                Text('Create account', style: TextStyle(fontSize: 20.0)),
                SizedBox(
                  height: 60.0,
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(context, bloc)
              ],
            ),
          ),
          TextButton(
              child: Text('¿Already have an account? Log in'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'login')),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Email',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.changeEmail),
        );
      },
    );
  }

  _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.lock_open_outlined, color: Colors.deepPurple),
                labelText: 'Password',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _crearBoton(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: snapshot.hasData
                ? MaterialStateProperty.all<Color>(Colors.deepPurple)
                : MaterialStateProperty.all<Color>(Colors.grey),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Create'),
          ),
          onPressed: snapshot.hasData ? () => _register(context, bloc) : null,
        );
      },
    );
  }

  _register(BuildContext context, LoginBloc bloc) async {
    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showAlert(context, info['message']);
    }
    //Navigator.pushReplacementNamed(context, 'home');
  }
}
