class Token{

  String access_token;
  String token_type;
  String refresh_token;
  int expires_in;
  String scope;

  Token({
    this.access_token,
    this.token_type,
    this.refresh_token,
    this.expires_in,
    this.scope,

  });

  factory Token.fromJson(Map<String, dynamic> json){
    return new Token(
        access_token: json['access_token'],
        token_type: json['token_type'],
        refresh_token: json['refresh_token'],
        expires_in: json['expires_in'],
        scope: json['scope'],
    );
  }

}