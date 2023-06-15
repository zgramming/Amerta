import '../database/helper.dart';
import '../model/person_model.dart';
import '../model/person_summary_transaction_model.dart';

class PersonService {
  final DatabaseHelper databaseHelper;
  const PersonService({
    required this.databaseHelper,
  });

  Future<List<PersonModel>> getAll() async {
    final result = await databaseHelper.getAllPerson();
    return result;
  }

  Future<PersonModel?> getById(int id) async {
    final result = await databaseHelper.getPersonById(id);
    return result;
  }

  Future<PersonSummaryTransactionModel> getSummaryTransaction(
      int personId) async {
    final result = await databaseHelper.getPersonSummaryTransaction(personId);
    return result;
  }

  Future<List<PersonModel>> save(PersonModel person) async {
    await databaseHelper.savePerson(person);
    return getAll();
  }

  Future<List<PersonModel>> update(PersonModel person) async {
    await databaseHelper.updatePerson(person);
    return getAll();
  }

  Future<List<PersonModel>> delete(int id) async {
    await databaseHelper.deletePerson(id);
    return getAll();
  }
}
