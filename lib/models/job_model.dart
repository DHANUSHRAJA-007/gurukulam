import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

@JsonSerializable()
class JobsModel extends Equatable {
  final int id;
  final String? jobStatus;
  final int? jobRoleId;
  final int? industryId;
  final String? workMode;
  final String? location;
  final double? salaryMin;
  final double? salaryMax;
  final String? salaryRange;
  final String? genderPreference;
  final String? ageLimit;
  final int? minimumQualificationId;
  final String? experienceRequired;
  final List<String>? languages;
  final List<String>? skills;
  final int? employmentTypeId;
  final String? workShiftTiming;
  final int? numberOfVacancies;
  final String? jobBenefits;
  final String? jobDescription;
  final String? tagMessage;
  final List<String>? screeningQuestions;
  final int? status;
  final String? createdAt;
  final String? jobRoleName;
  final String? industryName;
  final String? qualificationName;
  final String? employmentTypeName;

  const JobsModel({
    required this.id,
    this.jobStatus,
    this.jobRoleId,
    this.industryId,
    this.workMode,
    this.location,
    this.salaryMin,
    this.salaryMax,
    this.salaryRange,
    this.genderPreference,
    this.ageLimit,
    this.minimumQualificationId,
    this.experienceRequired,
    this.languages,
    this.skills,
    this.employmentTypeId,
    this.workShiftTiming,
    this.numberOfVacancies,
    this.jobBenefits,
    this.jobDescription,
    this.tagMessage,
    this.screeningQuestions,
    this.status,
    this.createdAt,
    this.jobRoleName,
    this.industryName,
    this.qualificationName,
    this.employmentTypeName,
  });

  factory JobsModel.fromJson(Map<String, dynamic> json) =>
      _$JobsModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobsModelToJson(this);

  @override
  List<Object?> get props => [id];
}
