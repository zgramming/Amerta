import '../database/helper.dart';
import '../model/person_filter_model.dart';
import '../model/person_model.dart';
import '../model/person_summary_transaction_model.dart';

class PersonService {
  final DatabaseHelper databaseHelper;
  final PersonFilterModel defaultFilter = const PersonFilterModel(
    searchQuery: "",
  );

  const PersonService({
    required this.databaseHelper,
  });

  Future<List<PersonModel>> getAll({
    required PersonFilterModel filter,
  }) async {
    final result = await databaseHelper.getAllPerson(filter: filter);
    return result;
  }

  Future<PersonModel?> getById(int id) async {
    final result = await databaseHelper.getPersonById(id);
    return result;
  }

  Future<PersonSummaryTransactionModel> getSummaryTransaction(
    int personId,
  ) async {
    final result = await databaseHelper.getPersonSummaryTransaction(personId);
    return result;
  }

  Future<List<PersonModel>> save(PersonModel person) async {
    await databaseHelper.savePerson(person);
    return getAll(filter: defaultFilter);
  }

  Future<List<PersonModel>> update(PersonModel person) async {
    await databaseHelper.updatePerson(person);
    return getAll(filter: defaultFilter);
  }

  Future<List<PersonModel>> delete(int id) async {
    await databaseHelper.deletePerson(id);
    return getAll(filter: defaultFilter);
  }
}
