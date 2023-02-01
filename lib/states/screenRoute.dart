class Userdata {
  final _name;
  final _imgUrl;
  final _email;
  final _pNum;

  Userdata(this._name, this._imgUrl, this._email, this._pNum);

  get pNum => _pNum;

  get email => _email;

  get imgUrl => _imgUrl;

  get name => _name;
}

class HomeScreenArgs {
  final Userdata _userdata;
  final String _location;

  HomeScreenArgs(this._userdata, this._location);

  String get location => _location;

  Userdata get userdata => _userdata;
}