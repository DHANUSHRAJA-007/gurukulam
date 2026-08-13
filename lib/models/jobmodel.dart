import 'package:gurukulam/models/master_model.dart';

class JobModel {
  final int? id;

  final String jobStatus;

  final int jobRoleId;
  final String jobRoleName;

  final int industryId;
  final String industryName;

  final String workMode;
  final String location;

  final double? salaryMin;
  final double? salaryMax;

  final String genderPreference;
  final int? ageLimit;

  final int? minimumQualificationId;
  final String minimumQualificationName;

  final String experienceRequired;

  final List<MasterModel> languages;
  final List<String> skills;

  final int? employmentTypeId;
  final String employmentTypeName;

  final String workShiftTiming;
  final int numberOfVacancies;

  final String jobBenefits;
  final String jobDescription;
  final String tagMessage;

  final List<String> screeningQuestions;

  final int status;

  JobModel({
    this.id,
    required this.jobStatus,
    required this.jobRoleId,
    required this.jobRoleName,
    required this.industryId,
    required this.industryName,
    required this.workMode,
    required this.location,
    this.salaryMin,
    this.salaryMax,
    required this.genderPreference,
    this.ageLimit,
    this.minimumQualificationId,
    required this.minimumQualificationName,
    required this.experienceRequired,
    required this.languages,
    required this.skills,
    this.employmentTypeId,
    required this.employmentTypeName,
    required this.workShiftTiming,
    required this.numberOfVacancies,
    required this.jobBenefits,
    required this.jobDescription,
    required this.tagMessage,
    required this.screeningQuestions,
    required this.status,
  });
}