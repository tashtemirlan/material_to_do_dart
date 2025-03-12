String mainPath = "http://localhost:2525";

/**
 * just standart commit
 * ! important commit
 * TODO: todo commit
 * ? Question commit
 */


/**
 * ! login & sign up section
 */
String loginPostEndpoint = "$mainPath/api/auth/login";
String signUpPostEndpoint = "$mainPath/api/auth/signup";
String forgetPasswordGenerateCodePostEndpoint = "$mainPath/api/auth/forget-password/generateCode";
String forgetPasswordChangePasswordPostEndpoint = "$mainPath/api/auth/forget-password/changePassword";

String policyGetEndpoint = "$mainPath/api/documents/getPolicy";
String privacyGetEndpoint = "$mainPath/api/documents/getPrivacy";
String validateTokenPostEndpoint = "$mainPath/api/auth/validate-token";
/**
 * ! user section
 */
String userInfoGetEndpoint = "$mainPath/api/user/getUserInfo";
String updateUserInfoPutEndpoint = "$mainPath/api/user/updateUserInfo";

/**
 * ! notes  section
 */
String createNotePostEndpoint = "$mainPath/api/notes/createNote";
String allNotesGetEndpoint = "$mainPath/api/notes/getAllNotes";
String noteGetEndpoint = "$mainPath/api/notes/getNote/";
String updateNotePutEndpoint = "$mainPath/api/notes/updateNote/";
String deleteNoteDeleteEndpoint = "$mainPath/api/notes/deleteNote/";

/**
 * !tasks group  section
 */
String createTaskGroupPostEndpoint = "$mainPath/api/tasks_groups/createTaskGroup";
String allTaskGroupsGetEndpoint = "$mainPath/api/tasks_groups/getTasksGroup";
String taskGroupGetEndpoint = "$mainPath/api/tasks_groups/getTaskGroup/";
String updateTaskGroupPutEndpoint = "$mainPath/api/tasks_groups/updateTaskGroup/";
String deleteTaskGroupDeleteEndpoint = "$mainPath/api/tasks_groups/deleteTaskGroup/";

/**
 * !tasks section
 */
String createTaskPostEndpoint = "$mainPath/api/tasks/createTask";
String allTasksGetEndpoint = "$mainPath/api/tasks/getAllTasks";
String taskGetEndpoint = "$mainPath/api/tasks/getTask/";
String updateTaskPutEndpoint = "$mainPath/api/tasks/updateTask/";
String deleteTaskDeleteEndpoint = "$mainPath/api/tasks/deleteTask/";
String toDOTasksGroupGetEndpoint = "$mainPath/api/tasks/getTasks/todo";
String inProgressTasksGroupGetEndpoint = "$mainPath/api/tasks/getTasks/in_progress";
String taskByDateGetEndpoint = "$mainPath/api/tasks/getTask/finish-date";
String tasksByGroupIdGetEndpoint = "$mainPath/api/tasks/getTaskByGroupId/";