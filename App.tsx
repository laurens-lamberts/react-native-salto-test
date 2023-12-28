/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useState} from 'react';
import {
  NativeEventEmitter,
  NativeModules,
  SafeAreaView,
  Text,
  View,
} from 'react-native';
import {Header} from 'react-native/Libraries/NewAppScreen';

const {RNSaltoKS} = NativeModules;

let eventEmitter = new NativeEventEmitter(RNSaltoKS);
function isModuleAvailable() {
  if (!RNSaltoKS) {
    throw new Error(
      'SaltoKS native module not available, did you forget to link the library?',
    );
  }
  return true;
}

function App(): React.JSX.Element {
  const [publicKey, setPublicKey] = useState('');

  const getPublicKey = async () => {
    const _publicKey = await RNSaltoKS.getPublicKey(null);
    setPublicKey(_publicKey);
  };
  useEffect(() => {
    if (!isModuleAvailable()) {
      alert('no module available');
      return;
    }

    eventEmitter.addListener('openDoorEvent', () => {});
    getPublicKey();
  }, []);

  return (
    <SafeAreaView>
      <Header />
      <View style={{padding: 20}}>
        <Text style={{marginBottom: 8}}>Minimal example to test ClaySDK</Text>
        <Text>Public key: {publicKey}</Text>
      </View>
    </SafeAreaView>
  );
}

export default App;
