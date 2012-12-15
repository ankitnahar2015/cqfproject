package cqfportal.client.apps.finalproject;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

import cqfportal.shared.Caplet;
import cqfportal.shared.HJMCalib;
import cqfportal.shared.ZCB;

@RemoteServiceRelativePath("hjm")
public interface HJMService extends RemoteService {
	double getZCBPrice(ZCB zcb, HJMCalib inputs, int numPaths);
	double getCapletPrice(Caplet caplet, HJMCalib inputs, int numPaths);
}
