class StripeCustomResponse {
  final bool ok;
  final String? msg;
  final String? id;

  StripeCustomResponse( {this.id,required this.ok, this.msg});
}
