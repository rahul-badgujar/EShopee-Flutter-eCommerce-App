import 'Model.dart';

class Address extends Model {
  static const String TITLE_KEY = "nickname";
  static const String ADDRESS_LINE_1_KEY = "address_line_1";
  static const String ADDRESS_LINE_2_KEY = "address_line_2";
  static const String CITY_KEY = "city";
  static const String DISTRICT_KEY = "district";
  static const String STATE_KEY = "state";
  static const String LANDMARK_KEY = "landmark";
  static const String PINCODE_KEY = "pincode";
  static const String RECEIVER_KEY = "receiver";
  static const String PHONE_KEY = "phone";

  final String title;
  final String receiver;

  final String addresLine1;
  final String addressLine2;
  final String city;
  final String district;
  final String state;
  final String landmark;
  final String pincode;
  final String phone;

  Address({
    String id,
    this.title,
    this.receiver,
    this.addresLine1,
    this.addressLine2,
    this.city,
    this.district,
    this.state,
    this.landmark,
    this.pincode,
    this.phone,
  }) : super(id);

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      title: "Home",
      receiver: "Rahul Badgujar",
      addresLine1: "Main Road",
      addressLine2: "A/P Malegaon MIDC",
      city: "Sinnar",
      district: "Nashik",
      state: "Maharashtra",
      landmark: "near Mahadev Mandir",
      pincode: "422113",
      phone: "7775919753",
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      TITLE_KEY: title,
      RECEIVER_KEY: receiver,
      ADDRESS_LINE_1_KEY: addresLine1,
      ADDRESS_LINE_2_KEY: addressLine2,
      CITY_KEY: city,
      DISTRICT_KEY: district,
      STATE_KEY: state,
      LANDMARK_KEY: landmark,
      PINCODE_KEY: pincode,
      PHONE_KEY: phone,
    };
  }
}
