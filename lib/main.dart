import 'package:figurinhas_copa/telas/ausentes.dart';
import 'package:flutter/material.dart';
import 'telas/estatistica.dart';
import 'telas/todas.dart';
import 'services/database_helper.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Chama a função seed. Se já tiver dados, ela não faz nada
  await DatabaseHelper.instance.popularBancoSeVazio(); 
  
  runApp(const MeuAlbumApp());
}

class MeuAlbumApp extends StatelessWidget {
  const MeuAlbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Álbum da Copa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TelaNavegacao(),
    );
  }
}

class TelaNavegacao extends StatefulWidget {
  const TelaNavegacao({super.key});

  @override
  State<TelaNavegacao> createState() => _TelaNavegacaoState();
}

class _TelaNavegacaoState extends State<TelaNavegacao> {
  int _abaAtual = 0; 

  final List<Widget> _telas = [
    const Estatistica(),
    const Todas(),
    const Ausentes(),  
  ];

  void _aoMudarAba(int indice) {
    setState(() {
      _abaAtual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Meu Álbum', 
          style: TextStyle(
            color: Color(0xFF1E3A8A), 
            fontWeight: FontWeight.w900, 
            letterSpacing: -0.5,
            fontSize: 24,
          )
        ),
        centerTitle: true, 
        backgroundColor: Colors.white, 
        elevation: 0, 
        scrolledUnderElevation: 0,
      ),
      
      body: _telas[_abaAtual], 
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual, 
        onTap: _aoMudarAba, 
        
        selectedItemColor: Colors.blue[800], 
        unselectedItemColor: Colors.grey[500],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Progresso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer_rounded),
            label: 'Todas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grading_rounded),
            label: 'Faltantes',
          ),
        ],
      ),
    );
  }
}