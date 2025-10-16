import 'mock_org_models.dart';

const List<OrgDept> kMockOrg = [
  OrgDept(
    name: '기획조정실',
    units: [
      OrgUnit(
        name: '경영기획팀',
        membersDirect: [Emp(id: '1001599', name: '조예빈', position: '사원')],
      ),
      OrgUnit(
        name: '안전보건팀',
        membersDirect: [Emp(id: '8000037', name: '최민희', position: '사원')],
      ),
    ],
  ),
  OrgDept(
    name: '호남지사',
    units: [
      OrgUnit(
        name: '호남지사',
        sites: [
          OrgSite(
            name: '전북지역본부',
            members: [Emp(id: '1001645', name: '김철기', position: '기술사원')],
          ),
          OrgSite(
            name: '제주지역본부',
            members: [Emp(id: '1001616', name: '김세진', position: '기술사원')],
          ),
        ],
        membersDirect: [
          Emp(id: '8000039', name: '정수희', position: '사원'),
          Emp(id: '8000040', name: '박민호', position: '대리'),
        ],
      ),
    ],
  ),
];
