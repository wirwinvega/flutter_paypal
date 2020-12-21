class PayPalResponse {
  Client client;
  Response response;
  String responseType;
  String paymentAmount;

  PayPalResponse(
      {this.client, this.response, this.responseType, this.paymentAmount});

  PayPalResponse.fromJson(Map<String, dynamic> json) {
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    responseType = json['response_type'];
    paymentAmount = json['paymentAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.client != null) {
      data['client'] = this.client.toJson();
    }
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    data['response_type'] = this.responseType;
    data['paymentAmount'] = this.paymentAmount;
    return data;
  }
}

class Client {
  String environment;
  String paypalSdkVersion;
  String platform;
  String productName;

  Client(
      {this.environment,
      this.paypalSdkVersion,
      this.platform,
      this.productName});

  Client.fromJson(Map<String, dynamic> json) {
    environment = json['environment'];
    paypalSdkVersion = json['paypal_sdk_version'];
    platform = json['platform'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['environment'] = this.environment;
    data['paypal_sdk_version'] = this.paypalSdkVersion;
    data['platform'] = this.platform;
    data['product_name'] = this.productName;
    return data;
  }
}

class Response {
  String createTime;
  String id;
  String intent;
  String state;

  Response({this.createTime, this.id, this.intent, this.state});

  Response.fromJson(Map<String, dynamic> json) {
    createTime = json['create_time'];
    id = json['id'];
    intent = json['intent'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_time'] = this.createTime;
    data['id'] = this.id;
    data['intent'] = this.intent;
    data['state'] = this.state;
    return data;
  }
}