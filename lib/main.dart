import 'package:flutter/material.dart';

void main() => runApp(
  // BytebankApp(),
  ListaTransferencias(), 
);

class BytebankApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        home: Scaffold(
        body: FormularioTransferencia(),
      ),
  );
  }

}

class FormularioTransferencia extends StatelessWidget {

  final TextEditingController _controllerValor = new TextEditingController();
  final TextEditingController _controllerNumeroConta = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência'),
      ),
      body: Column(
        children: <Widget>[
          Campos(
            controlador: _controllerNumeroConta,  
            dica: '0000',
            rotulo: 'Número da conta',
          ),
          Campos(
            controlador: _controllerValor,  
            dica: '0.00',
            rotulo: 'Valor',
            icone: Icon(Icons.monetization_on),
          ),
          RaisedButton(
            child: Text('Confirmar'),
            onPressed: () => criarTransferencia(context)
            ,
          ),
        ],
      ),
    );
  }

  void criarTransferencia(BuildContext context) {
    
    int numeroConta = int.tryParse(_controllerNumeroConta.text);
    double valor = double.tryParse(_controllerValor.text);

    if (numeroConta != null && valor != null) {
      final novaTransferencia = new Transferencia(valor, numeroConta);
      Navigator.pop(context, novaTransferencia);
    }
  }

}

class Campos extends StatelessWidget {

  final TextEditingController controlador;
  final String dica;
  final String rotulo;
  final Icon icone;

  Campos({this.controlador, this.dica, this.rotulo,this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
          fontSize: 24.0,
        ),
        decoration: InputDecoration(
          icon: icone,
          hintText: dica,
          labelText: rotulo,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

}

class ListaTransferencias extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      home: Lista(),
    );
  }
}

class ListaState extends State<Lista> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, indice) {
            final transferencia = widget._transferencias[indice];
            return ItemTransferencia(transferencia);
          },
        ),
        appBar: AppBar(
          title: Text('Tranferências',),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            final Future<Transferencia> future = 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    return FormularioTransferencia();
                  }
                )
              );
            future.then((transferenciaRecebida) {
              if (transferenciaRecebida != null) {
                widget._transferencias.add(transferenciaRecebida);
              }
            });
          },
        ),
      );
  }

}

class Lista extends StatefulWidget {

  final List<Transferencia> _transferencias = List();
  @override
  State<StatefulWidget> createState() {
    return ListaState();
  }

}

class ItemTransferencia extends StatelessWidget {
  
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return 
      Card(
        child: ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text('R\$${_transferencia.valor.toString()}'),
          subtitle: Text(_transferencia.numeroConta.toString()),
        )
      );
  }

}

class Transferencia {

  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  
}