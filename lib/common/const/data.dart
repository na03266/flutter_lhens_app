import 'dart:io';

const BASIC_TOKEN = 'BASIC_TOKEN';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
const AUTO_LOGIN = 'AUTO_LOGIN';
const SAVE_MB_NO = 'SAVE_MB_NO';

// localhost
final defaultIp = '110.10.147.37/app';
final ws = 'http://110.10.147.37';
final emulatorIp = 'http://$defaultIp';
final simulatorIp = 'http://$defaultIp';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;
