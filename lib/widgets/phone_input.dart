import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/country.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class PhoneInput extends StatefulWidget {
  final void Function(String)? onChanged;
  const PhoneInput({super.key, this.onChanged});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  Country _selectedCountry = countryList.first;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() {
      _emitFullPhoneNumber();
    });
  }

  void _showCountryPicker() async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: AppColors.background,
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: countryList.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final country = countryList[index];
            return ListTile(
              leading: Image.asset(
                country.flagAsset,
                width: 24,
                height: 16,
                fit: BoxFit.cover,
              ),
              title: Text(
                country.dialCode,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Text(country.name),
              onTap: () => Navigator.pop(context, country),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedCountry = selected);
      _emitFullPhoneNumber();
    }
  }

  void _emitFullPhoneNumber() {
    final fullPhone =
        '${_selectedCountry.dialCode}${_phoneController.text.trim()}';
    widget.onChanged?.call(fullPhone);
  }

  @override
  Widget build(BuildContext context) {
    final height = SizeConfig.scaleHeight(56);
    final dividerHeight = SizeConfig.scaleHeight(24);
    final flagWidth = SizeConfig.scaleWidth(24);
    final flagHeight = SizeConfig.scaleWidth(16);
    final iconSize = SizeConfig.scaleWidth(16);

    return Container(
      width: SizeConfig.scaleWidth(327),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF5F5F5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          SizedBox(width: SizeConfig.scaleWidth(16)),
          SizedBox(
            height: SizeConfig.scaleWidth(24),
            width: SizeConfig.scaleWidth(87),
            child: InkWell(
              onTap: _showCountryPicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _selectedCountry.flagAsset,
                    width: flagWidth,
                    height: flagHeight,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(8)),
                  Text(
                    _selectedCountry.dialCode,
                    style: TextStyle(
                      fontSize: SizeConfig.scaleFont(14),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF39434F),
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(4)),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    size: iconSize,
                    color: const Color(0xFF9E9E9E),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: dividerHeight,
            color: const Color(0xFFDADADA),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: SizeConfig.scaleWidth(16)),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '988543358',
                  hintStyle: TextStyle(
                    fontSize: SizeConfig.scaleFont(14),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7B7B8D),
                  ),
                ),
                style: TextStyle(
                  fontSize: SizeConfig.scaleFont(14),
                  color: const Color(0xFF39434F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
