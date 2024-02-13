package com.example.doormster;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;
import android.window.SplashScreenView;

import androidx.annotation.NonNull;
import androidx.core.view.WindowCompat;

import com.intelligoo.sdk.AutoOpenService;
import com.intelligoo.sdk.LibDevModel;
import com.intelligoo.sdk.LibInterface;
import com.intelligoo.sdk.ScanCallBackSort;

import java.util.ArrayList;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            getSplashScreen()
                .setOnExitAnimationListener(
                    (SplashScreenView splashScreenView) -> {
                        splashScreenView.remove();
                    });
        }

        super.onCreate(savedInstanceState);
    }

     private static final String CHANNEL = "samples.flutter.dev/autoDoor";
     private boolean pressed = true;
     // private static ArrayList<DeviceBean> devList = new ArrayList<DeviceBean>();

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

                                 LibDevModel device = new LibDevModel();
                                 device.devSn = devSn;
                                 device.devMac = devMac;
                                 device.devType = 1;
                                 device.eKey = appEkey;

                                 System.out.print(device.devSn);

                                 openAutodoor(value, device);
                                 result.success(arguments);

                             } else {
                                 result.notImplemented();
                             }
                         }

                 );
     }

     public void openAutodoor(boolean value, LibDevModel getLib) {
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
                     pressed = true;
                     LibDevModel.openDoor(MainActivity.this, getLib, callback); // Open
                 }
             };
             // AutoOpenService.startBackgroudMode(MainActivity.this, scancallBack);
             AutoOpenService.startBackgroundModeWithBrightScreen(MainActivity.this,
                     scancallBack);
         } else {
             getApplicationContext().stopService(autoService);
         }

     }

     final LibInterface.ManagerCallback callback = new LibInterface.ManagerCallback() {
         @Override
         public void setResult(final int result, Bundle bundle) {
             runOnUiThread(new Runnable() {
                 public void run() {
                     pressed = false; // 二次点击处理（避免重复点击）
                     // mHandler.sendEmptyMessage(OPEN_AGAIN);
                     if (result == 0x00) {
                         System.out.print("เปิดสำเร็จ");
                         Toast.makeText(MainActivity.this, "เปิดสำเร็จ",
                                 Toast.LENGTH_SHORT).show();
                     } else {
                         if (result == 48) {
                             System.out.print("ไม่พบอุปกรณ์");
                             Toast.makeText(getApplicationContext(), "ไม่พบอุปกรณ์",
                                     Toast.LENGTH_SHORT)
                                     .show();
                         } else {
                             System.out.print("ผิดพลาด:" + result);
                             Toast.makeText(MainActivity.this, "ผิดพลาด:" + result,
                                     Toast.LENGTH_SHORT).show();
                         }
                     }
                 }
             });
         }
     };

}
