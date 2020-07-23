import { NativeModules } from 'react-native';

const { ReverseGecoder } = NativeModules;

export default {
    async getAddressFromLocation(latitude,longitude,language){
        let data = await ReverseGecoder.getAddressFromLocation(latitude,longitude,language);
        return data;
      }
}
