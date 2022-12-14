// // calls in the constructor
// function testnetHelper() private onlyDeployer {
//     updateNativePair(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
//     updateUSDTPair(0xa90058c81Ce72946526acb37c444a1Cd640CCC21);
//     updateFleepPair(0x69C02513F5Af6651B80207003a4bcAA530605a03);

//     // FLP
//     createPair(
//         0x69C02513F5Af6651B80207003a4bcAA530605a03,
//         0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408
//     );

//     // WBTC
//     createPair(
//         0xfcd9eB765936D608C6f9a4cC3C9080190e3A2566,
//         0x007A22900a3B98143368Bd5906f8E17e9867581b
//     );

//     // DAI
//     createPair(
//         0xac2003580BD6329D1CbE5c492D523fC5b8004d56,
//         0x0FCAa9c899EC5A91eBc3D5Dd869De833b06fB046
//     );

//     // WETH
//     createPair(
//         0x5b9228d432B21e5Faf6c07792149bEaa0A650032,
//         0x0715A7794a1dc8e42615F059dD6e406A6594651A
//     );

//     // MATIC
//     createPair(NATIVE_PAIR, NATIVE_PAIR);

//     // SAND
//     createPair(
//         0x87714Bba938f16C852E91847c0bC95DA3609A2EA,
//         0x9dd18534b8f456557d11B9DDB14dA89b2e52e308
//     );

//     // USDC
//     createPair(
//         0x934253c5B9455F4694F49163E4D132f3de5A5666,
//         0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0
//     );

//     // USDT
//     createPair(
//         0xa90058c81Ce72946526acb37c444a1Cd640CCC21,
//         0x92C09849638959196E976289418e5973CC96d645
//     );
// }

// // called by any provider
// function testnetHelper2() public {
//     createPool(
//         0xfcd9eB765936D608C6f9a4cC3C9080190e3A2566,
//         0xac2003580BD6329D1CbE5c492D523fC5b8004d56
//     ); // WBTC => DAI : 1
//     createPool(
//         0xfcd9eB765936D608C6f9a4cC3C9080190e3A2566,
//         0x5b9228d432B21e5Faf6c07792149bEaa0A650032
//     ); // WBTC => WETH : 2
//     createPool(
//         0xfcd9eB765936D608C6f9a4cC3C9080190e3A2566,
//         0x87714Bba938f16C852E91847c0bC95DA3609A2EA
//     ); // WBTC => SAND : 3
//     createPool(
//         0xfcd9eB765936D608C6f9a4cC3C9080190e3A2566,
//         0x934253c5B9455F4694F49163E4D132f3de5A5666
//     ); // WBTC => USDC : 4
//     createPool(
//         0xfcd9eB765936D608C6f9a4cC3C9080190e3A2566,
//         0xa90058c81Ce72946526acb37c444a1Cd640CCC21
//     ); // WBTC => USDT : 5
//     createPool(
//         0x5b9228d432B21e5Faf6c07792149bEaa0A650032,
//         0xa90058c81Ce72946526acb37c444a1Cd640CCC21
//     ); // WETH => USDT : 6
//     createPool(
//         0x5b9228d432B21e5Faf6c07792149bEaa0A650032,
//         0x87714Bba938f16C852E91847c0bC95DA3609A2EA
//     ); // WETH => SAND : 7
//     createPool(
//         0x87714Bba938f16C852E91847c0bC95DA3609A2EA,
//         0xa90058c81Ce72946526acb37c444a1Cd640CCC21
//     ); // SAND => USDT : 8
//     createPool(
//         0x87714Bba938f16C852E91847c0bC95DA3609A2EA,
//         0xac2003580BD6329D1CbE5c492D523fC5b8004d56
//     ); // SAND => DAI : 9
//     createPool(
//         0xac2003580BD6329D1CbE5c492D523fC5b8004d56,
//         0x5b9228d432B21e5Faf6c07792149bEaa0A650032
//     ); // DAI => WETH : 10
//     createPool(NATIVE_PAIR, 0xa90058c81Ce72946526acb37c444a1Cd640CCC21); // MATIC => USDT : 11
// }
