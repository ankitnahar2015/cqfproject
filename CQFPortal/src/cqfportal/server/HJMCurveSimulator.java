package cqfportal.server;

import java.util.ArrayList;
import java.util.Random;
import java.util.logging.Logger;

import cqfportal.shared.HJMCalib;
import cqfportal.shared.IntRate;
import cqfportal.shared.TermStructure;

public class HJMCurveSimulator {	
	private Random rand = new Random(System.nanoTime());
	
	private static Logger logger = 
			Logger.getLogger(HJMCurveSimulator.class.getName()); 
		
	public YieldCurveSet getCurveSet(HJMCalib calib, HJMVols vols, double maturity) {
		
		//just get for 3 tenors - 0, 0.5 and 1
		YieldCurveSet ycs = new YieldCurveSet();
		
		ycs.times.add(0.0);
		ycs.termStructures.add(calib.day0TermStructure);
		ArrayList<IntRate> prevIntRates = calib.day0TermStructure.intRates;	
		
		logger.fine("simulating curve set -- day0Termstructure: " 
				+ calib.day0TermStructure);
				
		final double dt = 0.01;
		double t = dt;
						
		while (t <= maturity) {				
			ArrayList<Double> slopes = new ArrayList<Double>();				
			for (int i = 0; i < prevIntRates.size(); i++) {
				double slope;
				if (i != prevIntRates.size() -1) {
					slope = (prevIntRates.get(i + 1).rate - prevIntRates.get(i).rate);
					slope = slope / (prevIntRates.get(i + 1).tenor - prevIntRates.get(i).tenor);				
				} else {
					slope = (prevIntRates.get(i).rate - prevIntRates.get(i - 1).rate);
					slope = slope / (prevIntRates.get(i).tenor - prevIntRates.get(i - 1).tenor);				
				}
				slopes.add(slope);
			}
			
			TermStructure ts = new TermStructure();
			for (int i = 0; i < prevIntRates.size(); i++) {
				double tenor = prevIntRates.get(i).tenor;
				double rate = prevIntRates.get(i).rate 
						+ vols.m.get(i) * dt
						+ (vols.vol1 * rand() + vols.vol2.get(i) * rand() + vols.vol3.get(i) * rand()) * Math.sqrt(dt)
						+ slopes.get(i) * dt;
				ts.intRates.add(new IntRate(tenor, rate));
			}
			
			ycs.times.add(t);
			ycs.termStructures.add(ts);
			
			prevIntRates = ts.intRates;
			
			t = t + dt;
		}
				
		return ycs;		
	}		
	
	private double rand() {	
		
		double r = rand.nextGaussian();		
		
//		double r = rand.nextDouble() + rand.nextDouble() + rand.nextDouble() +
//				rand.nextDouble() + rand.nextDouble() + rand.nextDouble() + 
//				rand.nextDouble() + rand.nextDouble() + rand.nextDouble() + 
//				rand.nextDouble() + rand.nextDouble() + rand.nextDouble() - 6;
		
		return r;
	}	
}
