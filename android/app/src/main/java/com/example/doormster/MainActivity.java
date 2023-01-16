package com.example.doormster;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.ListView;
import android.widget.Switch;
import android.widget.Toast;

import com.intelligoo.sdk.AutoOpenService;
import com.intelligoo.sdk.LibDevModel;
import com.intelligoo.sdk.LibInterface;
import com.intelligoo.sdk.ScanCallBackSort;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/battery";

//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//                .setMethodCallHandler(
//                        (call, result) -> {
//                            // This method is invoked on the main thread.
//                            if (call.method.equals("getBatteryLevel")) {
//                                int batteryLevel = getBatteryLevel();
//
//                                if (batteryLevel != -1) {
//                                    result.success(batteryLevel);
//                                } else {
//                                    result.error("UNAVAILABLE", "Battery level not available.", null);
//                                }
//                            } else {
//                                result.notImplemented();
//                            }
//                        }
//
//                );
//    }

//    private int getBatteryLevel() {
//        int batteryLevel = -1;
//        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
//            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
//        } else {
//            Intent intent = new ContextWrapper(getApplicationContext()).registerReceiver(null,
//                    new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
//            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
//                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
//        }
//
//        return batteryLevel;
//    }


    private Switch sw_auto_open; //auto open switch
    private boolean pressed = false;
    private static ArrayList<DeviceBean> devList = new ArrayList<DeviceBean>();
    private static Map<String, DeviceBean> tempDevDict = new HashMap<String, DeviceBean>();
    private MyAdapter adapter = null;
    private static LibDevModel curClickDevice = null;
    private ListView mList = null;

    private void initEvent() {
//        if (username != null) {
//            mUsername.setText(username);
//        }
//        if (password != null) {
//            mPwd.setText(password);
//        }
////        mDrawerLoginBt.setOnClickListener(this);
//        mWifiSet.setOnClickListener(this);
//        settingBt.setOnClickListener(this);
//        openBt.setOnClickListener(this);
//        scanOnceBt.setOnClickListener(this);
//        scanAllBt.setOnClickListener(this);
//        deleteTest.setOnClickListener(this);
//        writeTest.setOnClickListener(this);
//        setReadSectorKeyBt.setOnClickListener(this);
//        configWifiBt.setOnClickListener(this);
//        cleanCardBt.setOnClickListener(this);
//        setDeviceConfigBt.setOnClickListener(this);
//        getDeviceConfigBt.setOnClickListener(this);
//        deleteDeviceConfigBt.setOnClickListener(this);
//        resetDeviceConfigBt.setOnClickListener(this);
////        addDevice.setOnClickListener(this);
//        saveDevice.setOnClickListener(this);
//        deleteDeviceDbBt.setOnClickListener(this);
//
        adapter = new MyAdapter(MainActivity.this, devList);
        mList.setAdapter(adapter);

        /***********************************操作设备 begin***********************************/

        sw_auto_open.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(CompoundButton buttonView,
                                         boolean isChecked) {
                // TODO Auto-generated method stub;

                //start auto open service
                Intent autoService = new Intent(MainActivity.this, AutoOpenService.class);
                if (isChecked) {
                    getApplicationContext().startService(autoService);

                    ScanCallBackSort scancallBack = new ScanCallBackSort() {

                        @Override
                        public void onScanResultAtOnce(String devSn, int rssi) {
                            // TODO Auto-generated method stub

                        }

                        @Override
                        public void onScanResult(ArrayList<Map<String, Integer>> devSnRssiList) {
                            // TODO Auto-generated method stub
                            if (devList == null || devList.size() == 0) {
                                Toast.makeText(getApplicationContext(), "No permitted device or haven't login", Toast.LENGTH_SHORT).show();
                                return;
                            }

                            if (devSnRssiList == null || devSnRssiList.size() == 0) {
                                Toast.makeText(getApplicationContext(), "No scan device", Toast.LENGTH_SHORT).show();
                                return;
                            }
                            Map<String, DeviceBean> devDomMap = new HashMap<String, DeviceBean>();
                            for (DeviceBean devBean : devList) {
                                devDomMap.put(devBean.getDevSn(), devBean);
                            }

                            int limit = -75; //限制信号值

                            for (Map<String, Integer> devRssiDict : devSnRssiList) {
                                for (String devSn : devRssiDict.keySet()) {
                                    if (devDomMap.containsKey(devSn) && devRssiDict.get(devSn) >= limit) {
                                        DeviceBean devDom = devDomMap.get(devSn);
                                        pressed = true;
                                        LibDevModel libDev = MyAdapter.getLibDev(devDom);
                                        int ret = LibDevModel.openDoor(MainActivity.this, libDev, callback); //Open door
                                        if (ret != 0) {
                                            pressed = false;
                                            if (ret == -107) {
                                                Log.d("MainActivity", "Operationing...");
                                            } else {
                                                Toast.makeText(getApplicationContext(), "RET：" + ret, Toast.LENGTH_SHORT).show();
                                            }
                                            return;
                                        }
                                    }
                                }


                            }
                        }
                    };
//					AutoOpenService.startBackgroudMode(MainActivity.this, scancallBack);
                    AutoOpenService.startBackgroundModeWithBrightScreen(MainActivity.this, scancallBack);
                } else {
                    getApplicationContext().stopService(autoService);
                }
            }
        });

        mList.setOnItemClickListener(new AdapterView.OnItemClickListener() // 处理设备交互
        {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                if (pressed) {
                    Toast.makeText(MainActivity.this, "Operationing...",
                            Toast.LENGTH_SHORT).show();
                    return;
                }
                LibDevModel device = adapter.getDev(position);
                curClickDevice = device;
                pressed = true;
                int ret = LibDevModel.openDoor(MainActivity.this, device, callback);  // ViewList click, open the door
                if (ret == 0) {
                    return;
                } else {
                    pressed = false;
                    Toast.makeText(getApplicationContext(), "RET：" + ret, Toast.LENGTH_SHORT).show();
                }
            }
        });
        /***********************************操作设备finish***********************************/

    }

    final LibInterface.ManagerCallback callback = new LibInterface.ManagerCallback() {
        @Override
        public void setResult(final int result, Bundle bundle) {
            runOnUiThread(new Runnable() {
                public void run() {
                    pressed = false; // 二次点击处理（避免重复点击）
//					mHandler.sendEmptyMessage(OPEN_AGAIN);
                    if (result == 0x00) {
                        Toast.makeText(MainActivity.this, "Success",
                                Toast.LENGTH_SHORT).show();
                    } else {
                        if (result == 48) {
                            Toast.makeText(getApplicationContext(), "Result Error Timer Out", Toast.LENGTH_SHORT).show();
                        } else {
                            Toast.makeText(MainActivity.this, "Failure:" + result,
                                    Toast.LENGTH_SHORT).show();
                        }
                    }
                }
            });
        }
    };

}
