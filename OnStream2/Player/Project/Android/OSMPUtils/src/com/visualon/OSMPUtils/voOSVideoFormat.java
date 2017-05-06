/************************************************************************
 VisualOn Proprietary
 Copyright (c) 2012, VisualOn Incorporated. All Rights Reserved
 
VisualOn, Inc., 4675 Stevens Creek Blvd, Santa Clara, CA 95051, USA
 
All data and information contained in or disclosed by this document are
 confidential and proprietary information of VisualOn, and all rights
 therein are expressly reserved. By accepting this material, the
 recipient agrees that this material and the information contained
 therein are held in confidence and in trust. The material may only be
 used and/or disclosed as authorized in a license agreement controlling
 such use and disclosure.
 ************************************************************************/

/************************************************************************
 * @file voOSVideoFormat.java
 * interface for getting  Video Format information.
 *
 * 
 *
 *
 * @author  Zhang Yi
 * @date    2012-2012 
 ************************************************************************/
package com.visualon.OSMPUtils;

import android.os.Parcel;

public interface voOSVideoFormat {
	/**
	 * @param parc  the Parcel object to convert data into this object
	 * @return true if parse OK,
	 */
	public boolean parse(Parcel parc);

	/**
	 * @return the width
	 */
	public int Width();
	
	/**
	 * @return the height
	 */
	public int Height();
	
	/**
	 * @return the color type
	 */
	public int Type();
	
}
