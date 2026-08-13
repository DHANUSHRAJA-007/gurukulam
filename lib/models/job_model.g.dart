// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobsModel _$JobsModelFromJson(Map<String, dynamic> json) => JobsModel(
  id: int.parse(json['id'].toString()),
  jobStatus: json['job_status'].toString(),
  jobRoleId: int.parse(json['job_role_id'].toString()),
  industryId: int.parse(json['industry_id'].toString()),
  workMode: json['work_mode'].toString(),
  location: json['location'].toString(),
  salaryMin: double.parse(
    json['salary_min'].toString() == 'null'
        ? '0.0'
        : json['salary_min'].toString(),
  ),
  salaryMax: double.parse(
    json['salary_max'].toString() == 'null'
        ? '0.0'
        : json['salary_max'].toString(),
  ),
  salaryRange: json['salary_range'].toString(),
  genderPreference: json['gender_preference'].toString(),
  ageLimit: json['age_limit'].toString(),
  minimumQualificationId: int.parse(
    json['minimum_qualification_id'].toString(),
  ),
  experienceRequired: json['experience_required'].toString(),
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e.toString())
      .toList(),
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
  employmentTypeId: int.parse(json['employment_type_id'].toString()),
  workShiftTiming: json['work_shift_timing'].toString(),
  numberOfVacancies: int.parse(json['number_of_vacancies'].toString()),
  jobBenefits: json['job_benefits'].toString(),
  jobDescription: json['job_description'].toString(),
  tagMessage: json['tag_message'].toString(),
  screeningQuestions: (json['screening_questions'] as List<dynamic>?)
      ?.map((e) => e.toString())
      .toList(),
  status: int.parse(json['status'].toString()),
  createdAt: json['created_at'].toString(),
  jobRoleName: json['job_role_name'].toString(),
  industryName: json['industry_name'].toString(),
  qualificationName: json['qualification_name'].toString(),
  employmentTypeName: json['employment_type_name'].toString(),
);

Map<String, dynamic> _$JobsModelToJson(JobsModel instance) => <String, dynamic>{
  'id': instance.id,
  'job_status': instance.jobStatus,
  'job_role_id': instance.jobRoleId,
  'industry_id': instance.industryId,
  'work_mode': instance.workMode,
  'location': instance.location,
  'salary_min': instance.salaryMin,
  'salary_max': instance.salaryMax,
  'salary_range': instance.salaryRange,
  'gender_preference': instance.genderPreference,
  'age_limit': instance.ageLimit,
  'minimum_qualification_id': instance.minimumQualificationId,
  'experience_required': instance.experienceRequired,
  'languages': instance.languages,
  'skills': instance.skills,
  'employment_type_id': instance.employmentTypeId,
  'work_shift_timing': instance.workShiftTiming,
  'number_of_vacancies': instance.numberOfVacancies,
  'job_benefits': instance.jobBenefits,
  'job_description': instance.jobDescription,
  'tag_message': instance.tagMessage,
  'screening_questions': instance.screeningQuestions,
  'status': instance.status,
  'created_at': instance.createdAt,
  'job_role_name': instance.jobRoleName,
  'industry_name': instance.industryName,
  'qualification_name': instance.qualificationName,
  'employment_type_name': instance.employmentTypeName,
};
