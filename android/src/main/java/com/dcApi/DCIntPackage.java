package com.dcApi;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import dcapi.Dcapi_;

public class DCIntPackage implements ReactPackage {
    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<NativeModule> createNativeModules(
            ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        Dcapi_ dcClass = new Dcapi_();

        modules.add(new AccountModule(reactContext, dcClass));
        modules.add(new BCModule(reactContext, dcClass));
        modules.add(new DBModule(reactContext, dcClass));
        modules.add(new DCModule(reactContext, dcClass));
        modules.add(new FileModule(reactContext, dcClass));

        return modules;
    }

}
