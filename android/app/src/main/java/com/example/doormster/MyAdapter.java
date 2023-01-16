package com.example.doormster;

import android.app.Activity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.intelligoo.sdk.LibDevModel;

import java.util.ArrayList;

public class MyAdapter extends BaseAdapter {
	private ArrayList<SortDev> devList = new ArrayList<SortDev>();
	private LayoutInflater mInflater = null;
	private static final boolean SCANED = true;
	private static final boolean SCANED_NULL = false;

	public MyAdapter(Activity activity, ArrayList<DeviceBean> data)
	{
		mInflater = LayoutInflater.from(activity);
		for (DeviceBean device : data)
		{
			SortDev sortDev = new SortDev(device, SCANED_NULL);
			devList.add(sortDev);
		}
	}

	public void refreshList (ArrayList<DeviceBean> list)
	{
		devList.clear();
		for (int i = 0;i < list.size(); i++)
		{
			SortDev sortDev = new SortDev(list.get(i), SCANED_NULL);
			devList.add(sortDev);
		}
		notifyDataSetChanged();
	}

	//高亮显示
	public void sortList (DeviceBean device)
	{
		if (device == null || device.getDevSn() == null
				|| devList == null || devList.isEmpty())
		{
			Log.e("doormaster ","sortList null");
			return;
		}
		SortDev scanDoor = new SortDev(device, SCANED);
		ArrayList<SortDev> temp_list = new ArrayList<SortDev>();

		for (SortDev door : devList) {    //之前扫描到的先添加
			if (door.scaned == SCANED &&
					(!door.device.getDevSn().equals(device.getDevSn()))) {
				temp_list.add(door);
			}
		}
		temp_list.add(scanDoor);    //加入新扫描的设备

		for (SortDev door : devList )  //加入未扫描的设备
		{
			if ((!door.device.getDevSn().equals(device.getDevSn())) && door.scaned == SCANED_NULL  ) {
				temp_list.add(door);
			}
		}

		devList = new ArrayList<SortDev>(temp_list);    //更新列表
		notifyDataSetChanged();
	}


	@Override
	public int getCount()
	{
		return devList.size();
	}

	@Override
	public Object getItem(int arg0)
	{
		return null;
	}

	public LibDevModel getDev(int position)
	{
		DeviceBean device = devList.get(position).device;
		LibDevModel libDev = getLibDev(device);
		return libDev;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent)
	{
		ViewHolder viewHolder=null;
//		if(convertView ==null)
//		{
//			convertView = mInflater.inflate(R.layout.item_list,null);
//			viewHolder = new ViewHolder();
//			viewHolder.devName = (TextView) convertView.findViewById(R.id.item_text);
//			viewHolder.item = (LinearLayout) convertView.findViewById(R.id.frag_item);
//			viewHolder.image = (ImageView) convertView.findViewById(R.id.item_img);
//			convertView.setTag(viewHolder);
//		}
//		else
//		{
//			viewHolder = (ViewHolder) convertView.getTag();
//		}
		LibDevModel libDev = getDev(position);

		viewHolder.devName.setText(libDev.devSn);
//		if (devList.get(position).scaned )
//		{
//			viewHolder.image.setImageResource(R.mipmap.lock_scaned);
//		}
//		else
//		{
//			viewHolder.image.setImageResource(R.mipmap.lock_not_scaned);
//		}

		return convertView;
	}



	public static LibDevModel getLibDev(DeviceBean dev) {
		LibDevModel device = new LibDevModel();
		device.devSn = dev.getDevSn();
		device.devMac = dev.getDevMac();
		device.devType = dev.getDevType();
		device.eKey = dev.geteKey();
		device.endDate = dev.getEndDate();
		device.openType = dev.getOpenType();
		device.privilege = dev.getPrivilege();
		device.startDate = dev.getStartDate();
		device.useCount = dev.getUseCount();
		device.verified = dev.getVerified();
		device.cardno = "123";//卡号从服务器获取，此卡号为测试卡号
		return device;
	}

	class ViewHolder
	{
		TextView devName;
		LinearLayout item;
		ImageView image;
	}

	public class SortDev
	{
		DeviceBean device = null;
		boolean scaned = false;
		public SortDev(DeviceBean device, boolean scaned)
		{
			this.device = device;
			this.scaned = scaned;
		}
	}
}
