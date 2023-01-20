package com.example.doormster;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
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
    private static final String CHANNEL = "samples.flutter.dev/autoDoor";

    // private Switch sw_auto_open; // auto open switch
    private boolean pressed = true;
    private static ArrayList<DeviceBean> devList = new ArrayList<DeviceBean>();
    // private static Map<String, DeviceBean> tempDevDict = new HashMap<String,
    // DeviceBean>();
//    private MyAdapter adapter = null;
//    private static LibDevModel curClickDevice = null;
//    private ListView mList = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {

                            if (call.method.equals("openAutoDoor")) {

                                Map<String, Object> arguments = call.arguments();
                                boolean value = (boolean) arguments.get("value");
                                String devSn = (String) arguments.get("devSn");
                                String devMac = (String) arguments.get("devMac");
                                String appEkey = (String) arguments.get("appEkey");

                                openAutodoor(value, devSn);
                                result.success(arguments);

                            } else {
                                result.notImplemented();
                            }
                        }

                );
    }

    public static LibDevModel getLibDev2(DeviceBean dev) {
        LibDevModel device = new LibDevModel();
        device.devSn = "4287064839";
        device.devMac = "34:b4:72:f9:b5:76";
        device.devType = 1;
        device.eKey = "66ca8bc357538b796a66227cb16c8c6e000000000000000000000011111111111000";
        // device.endDate = "2025-01-01 00:00:00";
        // device.openType = 1;
        // device.privilege = 4;
        // device.startDate = "2023-01-01 00:00:00";
        // device.useCount = 0;
        // device.verified = 3;
        // device.cardno = "123";//卡号从服务器获取，此卡号为测试卡号
        return device;
    }

    public void openAutodoor(boolean value, String DevSn) {
         Intent autoService = new Intent(MainActivity.this, AutoOpenService.class);


        if (value) {
             getApplicationContext().startService(autoService);

            ScanCallBackSort scancallBack = new ScanCallBackSort() {

                @Override
                public void onScanResultAtOnce(String devSn, int rssi) {
                    // TODO Auto-generated method stub

                }

                @Override
                public void onScanResult(ArrayList<Map<String, Integer>> devSnRssiList) {

                    Toast.makeText(getApplicationContext(), DevSn, Toast.LENGTH_SHORT).show();
                    Map<String, DeviceBean> devDomMap1 = new HashMap<String, DeviceBean>();

                    for (DeviceBean devBean : devList) {
                        devDomMap1.put(DevSn, devBean);
                    }
                    DeviceBean devDom1 = devDomMap1.get(DevSn);

                    pressed = true;
                    LibDevModel libDev1 = getLibDev2(devDom1);

                    int ret1 = LibDevModel.openDoor(MainActivity.this, libDev1, callback); //Open door
                    Toast.makeText(getApplicationContext(), "ได้", Toast.LENGTH_SHORT).show();
                    if (ret1 != 0) {
                        pressed = false;
                        if (ret1 == -107) {
                            Log.d("MainActivity", "Operationing...");
                        } else {
                            Toast.makeText(getApplicationContext(), "RET：" + ret1,
                                    Toast.LENGTH_SHORT).show();
                        }
                        return;
                    }

                    // TODO Auto-generated method stub
//                    if (devList == null || devList.size() == 0) {
//                        Toast.makeText(getApplicationContext(), "No permitted device or haven't login",
//                                Toast.LENGTH_SHORT).show();
//                        return;
//                    }
//
//                    if (devSnRssiList == null || devSnRssiList.size() == 0) {
//                        Toast.makeText(getApplicationContext(), "No scan device", Toast.LENGTH_SHORT).show();
//                        return;
//                    }
//                    Map<String, DeviceBean> devDomMap = new HashMap<String, DeviceBean>();
//                    for (DeviceBean devBean : devList) {
//                        devDomMap.put(devBean.getDevSn(), devBean);
//                    }
//
//                    int limit = -75; // 限制信号值
//
//                    for (Map<String, Integer> devRssiDict : devSnRssiList) {
//                        for (String devSn : devRssiDict.keySet()) {
//                            if (devDomMap.containsKey(devSn) && devRssiDict.get(devSn) >= limit) {
//                                DeviceBean devDom = devDomMap.get(devSn);
//                                pressed = true;
//                                LibDevModel libDev = MyAdapter.getLibDev(devDom);
//                                int ret = LibDevModel.openDoor(MainActivity.this, libDev, callback); // Open
//                                // door
//                                if (ret != 0) {
//                                    pressed = false;
//                                    if (ret == -107) {
//                                        Log.d("MainActivity", "Operationing...");
//                                    } else {
//                                        Toast.makeText(getApplicationContext(), "RET：" + ret,
//                                                Toast.LENGTH_SHORT).show();
//                                    }
//                                    return;
//                                }
//                            }
//                        }
//
//                    }
                }
            };
//             AutoOpenService.startBackgroudMode(MainActivity.this, scancallBack);
            AutoOpenService.startBackgroundModeWithBrightScreen(MainActivity.this, scancallBack);
        } else {
            getApplicationContext().stopService(autoService);
        }

//        mList.setOnItemClickListener(new AdapterView.OnItemClickListener() // 处理设备交互
//        {
//            @Override
//            public void onItemClick(AdapterView<?> parent, View view,
//                    int position, long id) {
//                if (pressed) {
//                    Toast.makeText(MainActivity.this, "Operationing...",
//                            Toast.LENGTH_SHORT).show();
//                    return;
//                }
//                LibDevModel device = adapter.getDev(position);
//                curClickDevice = device;
//                pressed = true;
//                int ret = LibDevModel.openDoor(MainActivity.this, device, callback); // ViewList click, open the door
//                if (ret == 0) {
//                    return;
//                } else {
//                    pressed = false;
//                    Toast.makeText(getApplicationContext(), "RET：" + ret, Toast.LENGTH_SHORT).show();
//                }
//            }
//        });

    }

    final LibInterface.ManagerCallback callback = new LibInterface.ManagerCallback() {
        @Override
        public void setResult(final int result, Bundle bundle) {
            runOnUiThread(new Runnable() {
                public void run() {
                    pressed = false; // 二次点击处理（避免重复点击）
                    // mHandler.sendEmptyMessage(OPEN_AGAIN);
                    if (result == 0x00) {
                        Toast.makeText(MainActivity.this, "Success",
                                Toast.LENGTH_SHORT).show();
                    } else {
                        if (result == 48) {
                            Toast.makeText(getApplicationContext(), "Result Error Timer Out", Toast.LENGTH_SHORT)
                                    .show();
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
