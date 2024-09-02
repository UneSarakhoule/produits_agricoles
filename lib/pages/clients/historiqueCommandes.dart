import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Historiquecommandes extends StatefulWidget {
  const Historiquecommandes({super.key});

  @override
  State<Historiquecommandes> createState() => _HistoriquecommandesState();
}

class _HistoriquecommandesState extends State<Historiquecommandes> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour récupérer les commandes de l'utilisateur
  Stream<QuerySnapshot> getUserOrders() {
    User? user = _auth.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('commandes')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    } else {
      // Retourner un flux vide si l'utilisateur n'est pas connecté
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Commandes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/acceuilClient');
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des commandes'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune commande trouvée'));
          }

          // Liste des commandes de l'utilisateur
          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Commande du ${order['date'].toDate()}'),
                subtitle: Text('Total: ${order['totalPrice']} FCFA'),
                onTap: () {
                  // Action lorsque l'utilisateur clique sur une commande (détails de la commande)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommandeDetails(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CommandeDetails extends StatelessWidget {
  final Map<String, dynamic> order;

  CommandeDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Commande'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commande passée le : ${order['date'].toDate()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Total de la commande : ${order['totalPrice']} FCFA',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text('Articles :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: (order['items'] as List).length,
                itemBuilder: (context, index) {
                  var item = (order['items'] as List)[index];
                  return ListTile(
                    title: Text(item['nomProduit']),
                    subtitle: Text('Quantité : ${item['quantité']}'),
                    trailing: Text('${item['prix']} FCFA'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
