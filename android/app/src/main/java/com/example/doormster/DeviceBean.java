package com.example.doormster;

import java.io.Serializable;

public class DeviceBean implements Serializable  {

	/**
	 * 
	 */
	
	private static final long serialVersionUID = 1L;
	
	
	private String devSn = null;
	private String devMac = null;
	private int devType;
	
	/*设备类型
 	(1, (u'门禁读头')),
    (2, (u'门禁一体机')),
    (3, (u'梯控读头(离线)')),
    (4, (u'无线锁')),
    (5, (u'蓝牙遥控模块')),
    (6, (u'门禁控制器')),
    (7, (u'触摸开关门禁')),
    (8, (u'可视对讲')),
    (9, (u'二维码设备')),
    */
	
	private int privilege;
	private int openType;
	private int verified;
	private String startDate = null;
	private String endDate = null;
	private int useCount;
	private String eKey = null;
	private int encrytion = 0x00;
	private String encryKey = null;

	public String getEncryKey() {
		return encryKey;
	}

	public void setEncryKey(String encryKey) {
		this.encryKey = encryKey;
	}

	public String getDevSn() {
		return devSn;
	}
	public void setDevSn(String devSn) {
		this.devSn = devSn;
	}
	
	public String getDevMac() {
		return devMac;
	}
	public void setDevMac(String devMac) {
		this.devMac = devMac;
	}
	
	public int getDevType() {
		return devType;
	}
	public void setDevType(int devType) {
		this.devType = devType;
	}
	
	public int getPrivilege() {
		return privilege;
	}
	public void setPrivilege(int privilege) {
		this.privilege = privilege;
	}
	
	public int getOpenType() {
		return openType;
	}
	public void setOpenType(int openType) {
		this.openType = openType;
	}
	
	public int getVerified() {
		return verified;
	}
	public void setVerified(int verified) {
		this.verified = verified;
	}
	
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	
	public int getUseCount() {
		return useCount;
	}
	public void setUseCount(int useCount) {
		this.useCount = useCount;
	}
	
	public String geteKey() {
		return eKey;
	}
	public void seteKey(String eKey) {
		this.eKey = eKey;
	}
	
	public int getEncrytion() {
		return encrytion;
	}
	public void setEncrytion(int encrytion) {
		this.encrytion = encrytion;
	}
	
}
