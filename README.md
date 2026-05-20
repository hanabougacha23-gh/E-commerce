# 🛒 E-Commerce Full-Stack App

Une solution e-commerce complète comprenant une application mobile moderne développée avec **Flutter** et un backend robuste propulsé par **Spring Boot**.

## 🚀 Fonctionnalités

- **Authentification Sécurisée** : Inscription et connexion avec JWT et Firebase.
- **Gestion du Panier** : Ajouter, supprimer et modifier les articles du panier en temps réel.
- **Paiements Stripe** : Intégration complète du processus de paiement sécurisé.
- **Notifications Push** : Alertes en temps réel via Firebase Cloud Messaging (FCM).
- **Catalogue de Produits** : Navigation par catégories, recherche et détails des produits.
- **Historique des Commandes** : Suivi des commandes passées par l'utilisateur.

---

## 🛠 Technologies Utilisées

### Backend (Spring Boot)
- **Framework** : Spring Boot 3.3.0 (Java 17)
- **Sécurité** : Spring Security & JWT
- **Base de données** : MySQL
- **Paiement** : Stripe API
- **Notifications** : Firebase Admin SDK
- **Outils** : JPA/Hibernate, Lombok, Maven

### Frontend (Flutter Mobile)
- **Framework** : Flutter SDK
- **Gestion d'état** : Provider
- **Navigation** : Go Router
- **Réseau** : Dio & HTTP
- **Local Storage** : Flutter Secure Storage
- **UI** : Shimmer, Cached Network Image, SVG support

---

## 📦 Installation et Configuration

### 1. Prérequis
- Java 17+
- Flutter SDK (dernière version stable)
- MySQL Server
- Un compte Stripe (clés de test)
- Un projet Firebase

### 2. Backend (Configuration)
1. Accédez au dossier : `cd backend/backend`
2. Configurez votre base de données MySQL dans `src/main/resources/application.properties`.
3. Définissez vos variables d'environnement ou mettez à jour les clés dans le fichier :
   - `DB_PASSWORD`
   - `JWT_SECRET`
   - `STRIPE_API_KEY`
4. Ajoutez votre fichier `firebase-service-account.json` dans `src/main/resources/`.
5. Lancez l'application :
   ```bash
   ./mvnw spring-boot:run
   ```

### 3. Application Flutter
1. Accédez au dossier : `cd flutter_e_commerce`
2. Installez les dépendances :
   ```bash
   flutter pub get
   ```
3. Configurez l'URL de l'API dans `lib/core/constants/api_constants.dart` (utilisez votre adresse IP locale au lieu de `localhost` pour les tests sur appareil réel).
4. Lancez l'application :
   ```bash
   flutter run
   ```

---

## 📁 Structure du Projet

```text
E_commerce_mobile/
├── backend/                # API REST Spring Boot
│   └── backend/
│       ├── src/
│       └── pom.xml
├── flutter_e_commerce/     # Application Mobile Flutter
│   ├── lib/
│   └── pubspec.yaml
└── README.md
```

## 🤝 Contribution
Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une *Issue* ou à soumettre une *Pull Request*.

## 📄 Licence
Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.
