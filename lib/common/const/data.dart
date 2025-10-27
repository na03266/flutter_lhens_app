import 'dart:io';

const BASIC_TOKEN = 'BASIC_TOKEN';
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// localhost
final emulatorIp = 'http://192.168.0.74:3000';
final simulatorIp = 'http://192.168.0.74:3000';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;
