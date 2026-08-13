import '../services/job_service.dart';

class JobRepository {
  final JobService _service;

  JobRepository({
    JobService? service,
  }) : _service =
            service ?? JobService();

  Future<bool> createJob(
    Map<String, dynamic> data,
  ) {
    return _service.createJob(data);
  }

  Future<List<dynamic>> getJobs() {
    return _service.getJobs();
  }
}