package cqfportal.client.apps.finalproject;

import com.google.gwt.user.client.rpc.AsyncCallback;

import cqfportal.shared.Caplet;
import cqfportal.shared.HJMCalib;
import cqfportal.shared.ZCB;

public interface HJMServiceAsync {

	void getZCBPrice(ZCB zcb, HJMCalib inputs, int numPaths,
			AsyncCallback<Double> callback);

	void getCapletPrice(Caplet caplet, HJMCalib inputs, int numPaths,
			AsyncCallback<Double> callback);

}
