import 'package:at_client/at_client.dart';
import 'package:at_utils/at_utils.dart';
import 'package:flutter/material.dart';
import 'package:atsign_protocol_demo/globals.dart' as globals;
import 'package:atsign_protocol_demo/atUtils/at_config.dart' as at_config;
import 'package:encrypt/encrypt.dart';

class AtLookupWidget extends StatefulWidget {

  static String title = "demo_app_route";

  @override
  _AtLookupWidgetState createState() => _AtLookupWidgetState();
}

class _AtLookupWidgetState extends State<AtLookupWidget> {
  String _result = '';

  final _atsignController = TextEditingController();

  String _decorationText = 'Syntax service@atsign (e.g. email@bob)';

  String _inputText = 'Enter service@atsign';

  String _buttonText = 'Lookup';

  String _pullDownHint = 'Select an @atsign';

  var _title = '@ Protocol Demo';

  var _onPressed;

  var _userChanged;

  var _userSelected;

  void _setResponse(response)
  {
    if(at_config.debug) print('_AtLookupWidgetState _setResponse received: $response');

    if(response == null || response == '')
    {
      if(at_config.debug) print('_AtLookupWidgetState _setResponse no response recevied');
      setState(() => _result = 'null');
    }

    else
    {
      if(at_config.debug) print('_AtLookupWidgetState _setResponse to: $response');
      setState(() => _result = response);
    }
  }

  void _setUser(atsign)
  {
    if(at_config.debug) print('_AtLookupWidgetState _setUser received: '+atsign+'');

    if(atsign == null || atsign == '')
    {
      setState(() => _userSelected = 'anonymous');
      if(at_config.debug) print('_AtLookupWidgetState _setUser setState _userSelected: anonymous');

    }

    else
    {
      if(at_config.debug) print('_AtLookupWidgetState _setUser setting _userSelected to: '+atsign+'');
      setState(() => _userSelected = atsign);
      if(at_config.debug) print('_AtLookupWidgetState _setUser setState() _userSelected: '+atsign);

    }
  }

  @protected
  @mustCallSuper
  initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    if(globals.atsignSet)
    {
      _userSelected = globals.atsign;
    }

    else
    {
      _userSelected = at_config.allAtsigns[0];
    }

    _userChanged = (String atsign) async
    {
      try
      {
        globals.atsign = atsign;
        globals.atsignSet = true;
        if(at_config.debug) print('_AtLookupWidgetState _userChanged to: '+atsign+'');

        var secret = at_config.secretMap[atsign];

        if(secret == null) {
          throw new Exception('_AtLookupWidgetState _userChanged no secret found for: '+atsign);

        }

        else
        {

          if(at_config.debug) print('_AtLookupWidgetState _userChanged changed atsign to: '+atsign+'');
          await AtClient().storeCredentialToKeychain(atsign, secret);

          bool ready = await AtClient().setAtsign(atsign);
          if(ready)
            if(at_config.debug) print('_AtLookupWidgetState _userChanged setting user to: $atsign');

            else throw new Exception('] _AtLookupWidgetState _userChanged problem with AtClient.setAtAtSign.');

          _setUser(atsign);
        }
      }

      on Exception catch(exception)
      {
        AtUtils.logPrint('_AtLookupWidgetState _userChanged exception: '+exception.toString());
      }

      catch(error)
      {
        AtUtils.logPrint('_AtLookupWidgetState _userChanged error: '+error.toString());
      }

    };

    _onPressed = () async
    {
      _atsignController.text = _atsignController.text.trim().toLowerCase().replaceAll(' ', '');
      var query = _atsignController.text;

      var user = globals.atsign;
      if(at_config.debug) print('_AtLookupWidgetState _onPressed found query '+query+'');

      _setResponse('searching...');

      if(user == 'anonymous' || user == 'public') {
        if(at_config.debug) print('_AtLookupWidgetState user is $user, using atClient.lookup for: '+query+'');

        AtClient().lookup(query).then((response)
        {
          _setResponse(response);
        });

      } else
      {
        query = user+':'+query;
        if(at_config.debug) print('_AtLookupWidgetState user is $user, using atClient.resolve for: '+query+'');

        AtClient().resolve(query).then((response)
        {
          _setResponse(response);
        });

      }
    };

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the AtLookupWidget object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_title),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child:
        SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lookup',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'I am:',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.deepPurple,
                ),
              ),
              Center(
                child:
                DropdownButton<String>(
                  hint:  Text(_pullDownHint),
                  value: _userSelected,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _userChanged(newValue);
                    });
                  },
                  items: at_config.allAtsigns
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'and I want to lookup:',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                autofocus: false,
                obscureText: false,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black, fontSize: 24),
                controller: _atsignController,
                decoration: InputDecoration(
                    labelText: _decorationText,
                    hintText: _inputText,
                    labelStyle: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.green,
                            style: BorderStyle.solid))),
              ),
              SizedBox(
                height: 15,
              ),
              ButtonTheme(
                //elevation: 4,
                //color: Colors.green,
                minWidth: double.infinity,
                child: MaterialButton(
                  onPressed: _onPressed,
                  textColor: Colors.white,
                  color: Colors.green,
                  height: 50,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                  child: Text(
                    _buttonText,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Result:',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Flexible(
                child:
                Center(
                  child:
                  Text(
                    _result,
                    style: TextStyle(
//                      fontFamily: 'NotoEmoji',
                      fontSize: 24.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}