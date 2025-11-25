import 'dart:io';

const BASIC_TOKEN = 'BASIC_TOKEN';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
const AUTO_LOGIN = 'AUTO_LOGIN';
const SAVE_MB_NO = 'SAVE_MB_NO';

// localhost
final defaultIp = '192.168.0.74:3000';
final ws = 'ws://$defaultIp';
final emulatorIp = 'http://$defaultIp';
final simulatorIp = 'http://$defaultIp';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;
