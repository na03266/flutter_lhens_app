import 'mock_user_tree_models.dart';
import 'mock_org_data.dart';
import 'mock_org_adapter.dart';

// 실제 조직(MockOrg)을 UI용 구조로 변환
final List<Department> kMockDepartments = adaptOrgToUserTree(kMockOrg);
