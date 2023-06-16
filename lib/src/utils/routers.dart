import 'dart:io';

import 'package:go_router/go_router.dart';

import '../view/form-person/form_person_page.dart';
import '../view/form-transaction/form_transaction_page.dart';
import '../view/person/person-detail/person_detail_page.dart';
import '../view/preview-pdf/preview_pdf_page.dart';
import '../view/splash_page.dart';
import '../view/transaction/transaction-detail/payment/form_page_payment.dart';
import '../view/transaction/transaction-detail/transaction_detail_page.dart';
import '../view/welcome_page.dart';

const splashRoute = 'splash';
const welcomeRoute = 'welcome';
const formTransactionRoute = 'form-transaction';
const transactionDetailRoute = 'transaction-detail';
const paymentRoute = 'payment';
const personDetailRoute = 'person-detail';
const formPersonRoute = 'form-person';

const previewPDFRoute = 'preview-pdf';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: splashRoute,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/welcome',
      name: welcomeRoute,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/form-transaction/:id',
      name: formTransactionRoute,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? "0";
        return FormTransactionPage(id: int.parse(id));
      },
    ),
    GoRoute(
      path: '/transaction/:id',
      name: transactionDetailRoute,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? "0";
        return TransactionDetailPage(id: int.parse(id));
      },
    ),
    GoRoute(
      path: '/transaction/:transactionId/payment/:id',
      name: paymentRoute,
      builder: (context, state) {
        final transactionId = state.pathParameters['transactionId'] ?? "0";
        final paymentId = state.pathParameters['id'] ?? "0";
        return FormPagePayment(
          transactionId: int.parse(transactionId),
          paymentId: int.parse(paymentId),
        );
      },
    ),
    GoRoute(
      path: '/person/:id',
      name: personDetailRoute,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? "0";
        return PersonDetailPage(id: int.parse(id));
      },
    ),
    GoRoute(
      path: '/form-person/:id',
      name: formPersonRoute,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? "0";
        return FormPersonPage(id: int.parse(id));
      },
    ),
    GoRoute(
      path: '/preview-pdf',
      name: previewPDFRoute,
      builder: (context, state) {
        final file = state.extra as File;
        return PreviewPDFPage(file: file);
      },
    ),
  ],
);
