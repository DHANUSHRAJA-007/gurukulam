// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobsModel _$JobsModelFromJson(Map<String, dynamic> json) => JobsModel(
  id: (json['id'] as num).toInt(),
  jobStatus: json['job_status'] as String?,
  jobRoleId: (json['job_role_id'] as num?)?.toInt(),
  industryId: (json['industry_id'] as num?)?.toInt(),
  workMode: json['work_mode'] as String?,
  location: json['location'] as String?,
  salaryMin: (json['salary_min'] as num?)?.toDouble(),
  salaryMax: (json['salary_max'] as num?)?.toDouble(),
  salaryRange: json['salary_range'] as String?,
  genderPreference: json['gender_preference'] as String?,
  ageLimit: json['age_limit'] as String?,
  minimumQualificationId: (json['minimum_qualification_id'] as num?)?.toInt(),
  experienceRequired: json['experience_required'] as String?,
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
  employmentTypeId: (json['employment_type_id'] as num?)?.toInt(),
  workShiftTiming: json['work_shift_timing'] as String?,
  numberOfVacancies: (json['number_of_vacancies'] as num?)?.toInt(),
  jobBenefits: json['job_benefits'] as String?,
  jobDescription: json['job_description'] as String?,
  tagMessage: json['tag_message'] as String?,
  screeningQuestions: (json['screening_questions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  status: (json['status'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  jobRoleName: json['job_role_name'] as String?,
  industryName: json['industry_name'] as String?,
  qualificationName: json['qualification_name'] as String?,
  employmentTypeName: json['employment_type_name'] as String?,
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
