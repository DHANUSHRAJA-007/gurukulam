import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/utils/config.dart';
import '../models/job_model.dart';

class JobDashboardApiService {
  Future<List<JobsModel>> fetchJobs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_jobs.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final List<dynamic> data = jsonData['data'];
          return data.map((job) => JobsModel.fromJson(job)).toList();
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to fetch jobs');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }

  // Mock data for development/testing
  List<JobsModel> getMockJobs() {
    return [
      JobsModel(
        id: 1,
        jobRoleName: 'Frontend Engineer',
        industryName: 'Technology',
        location: 'Bengaluru',
        workMode: 'Hybrid',
        salaryRange: '₹9–13 LPA',
        experienceRequired: '3–5 years',
        ageLimit: '21–35 years',
        qualificationName: 'B.E./B.Tech in Computer Science',
        languages: ['English — fluent', 'Hindi — professional'],
        skills: ['React', 'TypeScript', 'Next.js', 'REST APIs'],
        workShiftTiming: '10:00 AM–7:00 PM, Mon–Fri',
        numberOfVacancies: 3,
        jobBenefits:
            'Medical cover, ₹30,000 learning budget, flexible leave, home-office allowance',
        jobDescription:
            'Build responsive customer workflows for a B2B analytics platform. Partner with product and design to ship accessible, performant features used by operations teams every day.',
      ),
      JobsModel(
        id: 2,
        jobRoleName: 'Business Analyst',
        industryName: 'Retail',
        location: 'Lower Parel',
        workMode: 'On-site',
        salaryRange: '₹7–10 LPA',
        experienceRequired: '2–4 years',
        ageLimit: '22–32 years',
        qualificationName: 'MBA, BBA, Economics, or Statistics',
        languages: ['English — fluent', 'Hindi — fluent'],
        skills: ['SQL', 'Power BI', 'Excel', 'Stakeholder reporting'],
        workShiftTiming: '9:30 AM–6:30 PM, Mon–Sat',
        numberOfVacancies: 2,
        jobBenefits:
            'Health insurance, performance bonus, commuter support, subsidized meals, quarterly wellness days',
        jobDescription:
            'Turn store, inventory, and sales data into clear operating recommendations. You will create weekly performance dashboards and help regional teams improve availability and customer experience.',
      ),
    ];
  }
}
