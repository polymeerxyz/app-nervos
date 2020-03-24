
. ./tests/lib.sh


@test "Signing with strict checking and a DAO deposit passes - $LEDGER_PROXY_PORT" {
  run apdu_fixed 8003400015058000002c80000135800000000000000000000000
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")
  run apdu_fixed 8003400015058000002c80000135800000000000000000000000
  [ "$status" -eq 0 ]
  grep -q "<= b''9000" <(echo "$output")

  run sendTransaction 010000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000101000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb020000000000000000000000c399495011b912999dbc72cf54982924e328ae170654ef76c8aba190ca376307000000000000000000000000c317d0b0b2a513ab1206e6d454c1960de7d7b4b80d0748a3e1f9cb197b74b8a501000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000064e5b27317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000520700000000000000000000 --isCtxd
   run sendTransaction 00000000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000102000000327f1fc62c53530c6c27018f1e8cee27c35c0370c3b4d3376daf8fe110e7d8cb4930ba433e606a53f4f283f02dddeb6d51b0dc3e463629b14a27995de9c71eca01000000ba08000000010020b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d500000000690000000800000061000000100000001800000061000000c561436317000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c0000000800000000000000 --isCtxd

  TRANSACTION=0d0200000c000000f9010000ed0100001c000000200000006e00000072000000ce000000d10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000020000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000000000000000000000000000140000000c000000100000000000000000000000

  run sendTransaction "$TRANSACTION"
  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
  txhash_and_witness=67c3c7d31dddd84f834d9ab79cd46da9be8a6218c520fa87bcee9277609638ad5500000000000000550000001000000055000000550000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  run check_signature "$txhash_and_witness" "$rv"
  diff <(echo $output) - <<<"Signature Verified Successfully"
  promptsCheck 4 tests/dao-deposit-prompts.txt
}

# FIXME: This test was failing randomly. It succeeds on some machines
# and not other. Determine why this is and reenable them.

#@test "Signing with strict checking and a DAO prepare passes" {
#  
#  run apdu_fixed 8003400015058000002c80000135800000000000000000000000
#  [ "$status" -eq 0 ]
#  grep -q "<= b''9000" <(echo "$output")
#  run apdu_fixed 8003400015058000002c80000135800000000000000000000000
#  [ "$status" -eq 0 ]
#  grep -q "<= b''9000" <(echo "$output")
#
#
#
#  run sendTransaction 00000000ed0100001c000000200000006e00000072000000ce000000d10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000020000000000000000000000b1b547956a0dfb7ea618231563b3acd23607586e939f88e5a6db5f392b2e78d5010000000000000000000000258e82bab2af21fd8899fc872742f4acea831f5e4c232297816b9bf4a19597a900000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000e91c708e17000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000000000000000000000000000 --isCtxd
#  run sendTransaction 01000000c10100001c000000200000006e00000072000000a2000000a50100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708000000000100000000010000000000000000000000455c8fdbaa43b45a1bbbc1cc9c93b4aa65897b2e443e057f5fd7c4dd23f0735401000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e01000000006100000010000000180000006100000080de02be76000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c0000001800000008000000000000000000000000000000 --isCtxd
#  TRANSACTION=4d0200000c000000190200000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b7080000000001010000006ee4972d1e676e0c921c611d1f3c2d58da3d843492ca60c659dc48d688d7d08102000000000000000000000067c3c7d31dddd84f834d9ab79cd46da9be8a6218c520fa87bcee9277609638ad000000000000000000000000e8f6e0ee550df41b5ed579f0f991758affe5f971bf5d980afdf720e56f7cfcac01000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000409cf3bd76000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000004b0a00000000000000000000340000000c0000002000000010000000100000001000000010000000100000001000000010000000100000001000000010000000
#
#  run sendTransaction "$TRANSACTION"
#  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
#  txhash_and_witness=380bd6a76e0f9715491e2962af2cd6d5e9eeb87ca7192e02423b392746c2a46c550000000000000055000000100000005500000055000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000100000001000000010000000
#  run check_signature "$txhash_and_witness" "$rv"
#  diff <(echo $output) - <<<"Signature Verified Successfully"
#  promptsCheck 7 tests/dao-prepare-prompts.txt
#}
#
#
#@test "Signing with strict checking and a DAO withdrawal passes" {
#  run apdu_fixed 8003400015058000002c80000135800000000000000000000000
#  [ "$status" -eq 0 ]
#  grep -q "<= b''9000" <(echo "$output")
#  run apdu_fixed 8003400015058000002c80000135800000000000000000000000
#  [ "$status" -eq 0 ]
#  grep -q "<= b''9000" <(echo "$output")
#
#  run sendTransaction 000000000d0200001c000000200000006e00000092000000ee000000f10100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b7080000000001010000006ee4972d1e676e0c921c611d1f3c2d58da3d843492ca60c659dc48d688d7d08102000000000000000000000067c3c7d31dddd84f834d9ab79cd46da9be8a6218c520fa87bcee9277609638ad000000000000000000000000e8f6e0ee550df41b5ed579f0f991758affe5f971bf5d980afdf720e56f7cfcac01000000030100000c000000a20000009600000010000000180000006100000000e8764817000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d3500000010000000300000003100000082d76d1b75fe2fd9a27dfbaa65a039221a380d76c926f378d3f81cf3e7e13f2e010000000061000000100000001800000061000000409cf3bd76000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d1c0000000c00000018000000080000004b0a00000000000000000000 --isCtxd
#  TRANSACTION=8b0100000c00000063010000570100001c000000200000006e000000b2000000e20000004b0100000000000002000000a563884b3686078ec7e7677a5f86449b15cf2693f3c1241766c6996f206cc5410200000000ace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b7080000000001020000006ee4972d1e676e0c921c611d1f3c2d58da3d843492ca60c659dc48d688d7d081d72c819927184fdb04e161dc3beea5b6adeba37a0575d2d965de98c1e56e489001000000b30b000000010020380bd6a76e0f9715491e2962af2cd6d5e9eeb87ca7192e02423b392746c2a46c00000000690000000800000061000000100000001800000061000000f0e0b05917000000490000001000000030000000310000009bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce80114000000e5260d839a786ac2a909181df9a423f1efbe863d0c000000080000000000000028000000080000001c0000001c00000010000000100000001c000000080000000000000000000000
#
#  run sendTransaction "$TRANSACTION"
#  rv="$(egrep "<= b'.*'9000" <(echo "$output")|cut -d"'" -f2)"
#  txhash_and_witness=d85e548a9e98e7d19116141600e39274df8588453d3c40da4e23f736876f74d3610000000000000061000000100000005500000061000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000
#  run check_signature "$txhash_and_witness" "$rv"
#  diff <(echo $output) - <<<"Signature Verified Successfully"
#  promptsCheck 6 tests/dao-withdraw-prompts.txt
#}
