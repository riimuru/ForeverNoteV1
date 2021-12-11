import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CertificatePopUp extends StatefulWidget {
  SslCertificate? ssl;
  Uri? url;
  CertificatePopUp(this.ssl, this.url);

  @override
  _CertificatePopUpState createState() =>
      _CertificatePopUpState(this.ssl, this.url);
}

class _CertificatePopUpState extends State<CertificatePopUp> {
  SslCertificate? ssl;
  Uri? url;
  X509Certificate? _selectedCertificate;

  _CertificatePopUpState(this.ssl, this.url);

  String? _findCommonName(
      {required X509Certificate? X509certificate, required bool isSubject}) {
    try {
      return (isSubject
              ? X509certificate!.subject(dn: ASN1DistinguishedNames.COMMON_NAME)
              : X509certificate!
                  .issuer(dn: ASN1DistinguishedNames.COMMON_NAME)) ??
          X509certificate.block1!
              .findOid(oid: OID.commonName)!
              .parent!
              .sub!
              .last
              .value;
    } catch (e) {}
    return null;
  }

  String? _findOrganizationName(
      {required X509Certificate? x509certificate, required bool isSubject}) {
    try {
      return (isSubject
              ? x509certificate!
                  .subject(dn: ASN1DistinguishedNames.ORGANIZATION_NAME)
              : x509certificate!
                  .issuer(dn: ASN1DistinguishedNames.ORGANIZATION_NAME)) ??
          x509certificate.block1!
              .findOid(oid: OID.organizationName)!
              .parent!
              .sub!
              .last
              .value;
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: (ssl?.x509Certificate == null)
                      ? Colors.red
                      : Colors.green,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  (ssl?.x509Certificate == null) ? Icons.lock_open : Icons.lock,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        url!.host,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Flutter Browser has verified that ${ssl?.x509Certificate?.issuer(dn: ASN1DistinguishedNames.COMMON_NAME) ?? "this site"} has ${(ssl?.x509Certificate == null) ? "not emitted" : "emitted"} the web site certificate.",
                              softWrap: true,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Certificate info",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 12.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    List<X509Certificate?> certificates = [
                                      ssl?.x509Certificate
                                    ];

                                    return AlertDialog(
                                      content: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5),
                                          child: StatefulBuilder(
                                            builder: (context, setState) {
                                              List<
                                                      DropdownMenuItem<
                                                          X509Certificate>>
                                                  dropdownMenuItems = [];
                                              certificates
                                                  .forEach((certificate) {
                                                var name = _findCommonName(
                                                        X509certificate:
                                                            certificate,
                                                        isSubject: true) ??
                                                    _findOrganizationName(
                                                        x509certificate:
                                                            certificate,
                                                        isSubject: true) ??
                                                    "";
                                                if (name != "") {
                                                  dropdownMenuItems.add(
                                                      DropdownMenuItem<
                                                          X509Certificate>(
                                                    value: certificate,
                                                    child: Text(name),
                                                  ));
                                                }
                                              });

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Text(
                                                    "Certificate Viewer",
                                                    style: TextStyle(
                                                      fontSize: 24.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15.0,
                                                  ),
                                                  DropdownButton<
                                                      X509Certificate>(
                                                    isExpanded: true,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _selectedCertificate =
                                                            value;
                                                      });
                                                    },
                                                    value: _selectedCertificate,
                                                    items: dropdownMenuItems,
                                                  ),
                                                  const SizedBox(
                                                    height: 15.0,
                                                  ),
                                                  Flexible(
                                                    child:
                                                        SingleChildScrollView(
                                                      child:
                                                          _buildCertificateInfo(
                                                        ssl?.x509Certificate,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          )),
                                    );
                                  },
                                );
                              }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCertificateInfo(X509Certificate? x509certificate) {
    var issuedToSection = _buildIssuedToSection(x509certificate);
    var issuedBySection = _buildIssuedBySection(x509certificate);

    var children = <Widget>[];
    children.addAll(issuedToSection);
    children.addAll(issuedBySection);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  List<Widget> _buildIssuedToSection(X509Certificate? x509certificate) {
    var subjectCountryName =
        _findCountryName(x509certificate: x509certificate, isSubject: true) ??
            "<Not Part Of Certificate>";
    var subjectStateOrProvinceName = _findStateOrProvinceName(
            x509certificate: x509certificate, isSubject: true) ??
        "<Not Part Of Certificate>";
    var subjectCN =
        _findCommonName(X509certificate: x509certificate, isSubject: true) ??
            "<Not Part Of Certificate>";
    var subjectO = _findOrganizationName(
            x509certificate: x509certificate, isSubject: true) ??
        "<Not Part Of Certificate>";
    var subjectU = _findOrganizationUnitName(
            x509certificate: x509certificate, isSubject: true) ??
        "<Not Part Of Certificate>";

    return <Widget>[
      const Text(
        "ISSUED TO",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Common Name (CN)",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        subjectCN,
        style: const TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Organization (O)",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        subjectO,
        style: const TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Organizational Unit (U)",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        subjectU,
        style: const TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Country",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        subjectCountryName,
        style: const TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "State/Province",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        subjectStateOrProvinceName,
        style: const TextStyle(fontSize: 14.0),
      ),
    ];
  }

  String? _findCountryName(
      {required X509Certificate? x509certificate, required bool isSubject}) {
    try {
      return (isSubject
              ? x509certificate!
                  .subject(dn: ASN1DistinguishedNames.COUNTRY_NAME)
              : x509certificate!
                  .issuer(dn: ASN1DistinguishedNames.COUNTRY_NAME)) ??
          x509certificate.block1!
              .findOid(oid: OID.countryName)!
              .parent!
              .sub!
              .last
              .value;
    } catch (e) {}
    return null;
  }

  String? _findStateOrProvinceName(
      {required X509Certificate? x509certificate, required bool isSubject}) {
    try {
      return (isSubject
              ? x509certificate!
                  .subject(dn: ASN1DistinguishedNames.STATE_OR_PROVINCE_NAME)
              : x509certificate!
                  .issuer(dn: ASN1DistinguishedNames.STATE_OR_PROVINCE_NAME)) ??
          x509certificate.block1!
              .findOid(oid: OID.stateOrProvinceName)!
              .parent!
              .sub!
              .last
              .value;
    } catch (e) {}
    return null;
  }

  String? _findOrganizationUnitName(
      {required X509Certificate? x509certificate, required bool isSubject}) {
    try {
      return (isSubject
              ? x509certificate!
                  .subject(dn: ASN1DistinguishedNames.ORGANIZATIONAL_UNIT_NAME)
              : x509certificate!.issuer(
                  dn: ASN1DistinguishedNames.ORGANIZATIONAL_UNIT_NAME)) ??
          x509certificate.block1!
              .findOid(oid: OID.organizationalUnitName)!
              .parent!
              .sub!
              .last
              .value;
    } catch (e) {}
    return null;
  }

  List<Widget> _buildIssuedBySection(X509Certificate? x509certificate) {
    var issuerCountryName =
        _findCountryName(x509certificate: x509certificate, isSubject: false) ??
            "<Not Part Of Certificate>";
    var issuerStateOrProvinceName = _findStateOrProvinceName(
            x509certificate: x509certificate, isSubject: false) ??
        "<Not Part Of Certificate>";
    var issuerCN =
        _findCommonName(X509certificate: x509certificate, isSubject: false) ??
            "<Not Part Of Certificate>";
    var issuerO = _findOrganizationName(
            x509certificate: x509certificate, isSubject: false) ??
        "<Not Part Of Certificate>";
    var issuerU = _findOrganizationUnitName(
            x509certificate: x509certificate, isSubject: false) ??
        "<Not Part Of Certificate>";
    var serialNumber = x509certificate?.serialNumber
            ?.map((byte) {
              var hexValue = byte.toRadixString(16);
              if (byte == 0 || hexValue.length == 1) {
                hexValue = "0" + hexValue;
              }
              return hexValue.toUpperCase();
            })
            .toList()
            .join(":") ??
        "<Not Part Of Certificate>";
    var version =
        x509certificate?.version.toString() ?? "<Not Part Of Certificate>";
    var sigAlgName = x509certificate?.sigAlgName ?? "<Not Part Of Certificate>";

    return <Widget>[
      const SizedBox(
        height: 15.0,
      ),
      const Text(
        "ISSUED BY",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Common Name (CN)",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        issuerCN,
        style: TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Organization (O)",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        issuerO,
        style: TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Organizational Unit (U)",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        issuerU,
        style: TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Country",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        issuerCountryName,
        style: TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "State/Province",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        issuerStateOrProvinceName,
        style: TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Serial Number",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        serialNumber,
        style: const TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Version",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        version,
        style: const TextStyle(fontSize: 14.0),
      ),
      const SizedBox(
        height: 5.0,
      ),
      const Text(
        "Signature Algorithm",
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      Text(
        sigAlgName,
        style: const TextStyle(fontSize: 14.0),
      ),
    ];
  }
}
