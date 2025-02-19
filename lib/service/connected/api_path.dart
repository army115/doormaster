// ignore_for_file: constant_identifier_names

abstract class EstampPath {
  static const UseEstamp = 'use_estamp';
  static const EstampLogs = 'sel_estamp_store_log_pagination';
  static const Parking = 'get_parking_calculate';
  static const EstampDiscounts = 'estamp_dropdown_store';
  static const StoreInfo = 'sel_store_info';
}

abstract class MainPath {
  static const Advert = 'sel_advert_user_table';
  static const Branch = 'Get_Branch_Employee';
  static const ChangePassword = 'reset_password';
  static const Menu = 'Get_Menu_Mobile';
  static const Login = 'login';
  static const RefreshToken = 'refreshTokenenduser';
  static const News = 'get_announcement_table_admin_mobile';
  static const UserInfo = 'Get_Employee_Info';
  static const UpdateInfo = 'Update_Employee';
}

abstract class SecurityPath {
  static const CheckIn = 'Create_guard_check_logs';
  static const AddCheckPoint = 'get/verifycheckpoint';
  static const CheckPoint = 'get/checkpoint';
  static const CheckList = 'get/checkpointdetail';
  static const GaurdLogsAll = 'Get_guard_logs_mobile';
  static const GaurdLogsToday = 'Get_guard_logs_today';
  static const GaurdLogsImage = 'Get_guard_log_image';
  static const Round = 'get_round';
  static const RoundNow = 'get_round_now';
}

abstract class VisitorPath {
  static const CreateVisitor = 'Create_visitor';
  static const RegisterVisitor = 'RegisterVisitor';
  static const GuardDoor = 'sel_door_dd';
  static const GuardOpenDoor = 'guard_open_door';
  static const UserDoor = 'sel_door_permission';
  static const UserOpenDoor = 'button_open_door';
  static const House = 'sel_house_Dropdown';
  static const SearchHouse = 'Get_use_house_Dropdown';
  static const Visitor = 'sel_stamp_visitor';
  static const StampVisitor = 'stamp_visitor';
}

abstract class ComplaintPath {
  static const Complaint = 'Get_complaint_req_Table_mobile';
  static const TypeComplaint = 'sel_complaint_type_both';
  static const AddComplaint = 'add_complaint_req';
  static const EditComplaint = 'edit_req_complaint';
  static const CancelComplaint = 'approve_complaint_req';
}

abstract class SOSPath {
  static const SOS = 'sel_sos_req_Table_mobile';
  static const AddSOS = 'add_sos_req';
  static const EditSOS = 'edit_req_sos';
  static const CancelSOS = 'approve_sos_req';
}
