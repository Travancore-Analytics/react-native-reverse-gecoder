import { NativeModules } from 'react-native';

const { ReverseGecoder } = NativeModules;

export default {
    async reverseGeocodeLocation(latitude,longitude,language){
        let data = await ReverseGecoder.reverseGeocodeLocation(latitude,longitude,language);
        return data;
      }
}
