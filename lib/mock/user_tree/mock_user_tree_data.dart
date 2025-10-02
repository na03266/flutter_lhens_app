import 'mock_user_tree_models.dart';

const List<Department> kMockDepartments = [
  Department(
    name: '기획조정실',
    teams: [
      Team(
        name: '경영기획팀',
        members: [
          Employee(name: '조예빈', id: '1001599', position: '사원'),
          Employee(name: '박서준', id: '1001600', position: '대리'),
          Employee(name: '강민지', id: '1001601', position: '과장'),
        ],
      ),
      Team(
        name: '인사팀',
        members: [
          Employee(name: '이하늘', id: '1001602', position: '사원'),
          Employee(name: '윤지호', id: '1001603', position: '대리'),
        ],
      ),
    ],
  ),
  Department(
    name: '안전보건팀',
    teams: [
      Team(
        name: '안전1팀',
        members: [
          Employee(name: '김철수', id: '1001200', position: '대리'),
          Employee(name: '최유진', id: '1001201', position: '사원'),
        ],
      ),
      Team(
        name: '안전2팀',
        members: [Employee(name: '오세훈', id: '1001202', position: '과장')],
      ),
    ],
  ),
];
