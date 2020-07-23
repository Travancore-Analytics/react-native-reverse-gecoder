package com.reactlibrary;

import android.location.Address;
import android.location.Geocoder;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

public class ReverseGecoderModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public ReverseGecoderModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ReverseGecoder";
    }

    @ReactMethod
    public void reverseGeocodeLocation(final double latitude, final double longitude, final String language, final Promise promise) {

        Geocoder geocoder = new Geocoder(reactContext, Locale.forLanguageTag(language));
        try {
            List<Address> addressList = geocoder.getFromLocation(latitude, longitude, 1);
            if (addressList != null && addressList.size() > 0) {
                Address address = addressList.get(0);
                WritableMap addressData = new WritableNativeMap();
                addressData.putString("State",address.getAdminArea());
                addressData.putString("City",address.getLocality());
                addressData.putString("Name",address.getFeatureName());
                addressData.putDouble("Latitude", address.getLatitude());
                addressData.putDouble("Longitude", address.getLongitude());
                addressData.putString("Country",address.getCountryName());
                addressData.putString("PostalCode",address.getPostalCode());
                addressData.putString("Street",address.getThoroughfare());
                addressData.putString("StreetNumber",address.getSubThoroughfare());
                promise.resolve(addressData);
            } else {
                promise.reject("error","Location not available");
            }
        } catch (IOException e) {
            promise.reject(e);
        }
    }
}
