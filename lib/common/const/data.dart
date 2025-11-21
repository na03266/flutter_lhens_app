import 'dart:io';

const BASIC_TOKEN = 'BASIC_TOKEN';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
const AUTO_LOGIN = 'AUTO_LOGIN';
const SAVE_MB_NO = 'SAVE_MB_NO';

// localhost
final ws = 'ws://192.168.0.125:3000';
final emulatorIp = 'http://192.168.0.125:3000';
final simulatorIp = 'http://192.168.0.125:3000';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;
