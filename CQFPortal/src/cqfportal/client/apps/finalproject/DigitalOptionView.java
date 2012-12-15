package cqfportal.client.apps.finalproject;

import com.google.gwt.user.client.ui.FlowPanel;
import com.google.gwt.user.client.ui.HTML;

import cqfportal.client.IViewRenderer;


public class DigitalOptionView implements IViewRenderer {

	@Override
	public void renderFirstTime(FlowPanel rootFlowPanel) {
		rootFlowPanel.add(new HTML("I am digital option viw in UVM"));
	}
}
