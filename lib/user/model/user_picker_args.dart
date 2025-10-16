enum UserPickerMode { generic, chatCreate, chatInvite, boardNotify }

class UserPickerArgs {
  final UserPickerMode mode;

  const UserPickerArgs(this.mode);
}
