import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Métodos de Pago"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Esquinas redondeadas
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nombre del Titular",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "**** **** **** 1234",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fecha de Expiración",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "12/25",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "CVV: ***",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: Colors.grey[200],
                child: ListTile(
                  title: Text(
                    "Editar Tarjeta",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                    },
                  ),
                  onTap: () {
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nombre y Apellidos",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Agregar Nombre y Apellidos',
                    filled: true, // Rellenar el fondo
                    fillColor: Colors.grey[300],
                  ),
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 4),

                Text(
                  "Número de Tarjeta",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Agregar Número de Tarjeta',
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  style: TextStyle(fontSize: 11),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fecha de Vencimiento",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 0),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'MM/AA',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CVV",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 0),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Agregar CVV',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "Correo Electrónico",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Agregar Correo Electrónico',
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  style: TextStyle(fontSize: 11),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004CFF),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      "Pagar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
