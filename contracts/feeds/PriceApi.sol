// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceApi {
    function getExchangeRate(address baseAddress, address quoteAddress)
        public
        view
        returns (int256)
    {
        uint8 _decimal = AggregatorV3Interface(baseAddress).decimals();

        // validate the base token decimals
        require(_decimal > uint8(0) && _decimal <= uint8(18), "Unsupported Decimals");

        int256 _decimals = int256(10**uint256(_decimal));

        // extract only the base token price from the returns
        (, int256 basePrice, , , ) = AggregatorV3Interface(baseAddress).latestRoundData();

        // get the base token decimals
        uint8 baseDecimals = AggregatorV3Interface(baseAddress).decimals();

        // get the base token price
        basePrice = scalePrice(basePrice, baseDecimals, _decimal);

        // extract only the quote token price from the returns
        (, int256 quotePrice, , , ) = AggregatorV3Interface(quoteAddress).latestRoundData();

        // get the quote token decimals
        uint8 quoteDecimals = AggregatorV3Interface(quoteAddress).decimals();

        // get the quote token price
        quotePrice = scalePrice(quotePrice, quoteDecimals, _decimal);

        return (basePrice * _decimals) / quotePrice;
    }

    function scalePrice(
        int256 _price,
        uint8 _priceDecimals,
        uint8 _decimals
    ) internal pure returns (int256) {
        // scale the price to ensure a accurate price

        if (_priceDecimals < _decimals) {
            return _price * int256(10**uint256(_decimals - _priceDecimals));
        } else if (_priceDecimals > _decimals) {
            return _price / int256(10**uint256(_priceDecimals - _decimals));
        }

        return _price;
    }
}
