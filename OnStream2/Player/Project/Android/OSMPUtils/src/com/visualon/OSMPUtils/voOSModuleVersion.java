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

/**
 * @file voOSModuleVersion.java
 * interface of module version info
 */
package com.visualon.OSMPUtils;

public interface voOSModuleVersion {
    /** [in]Indicator module type,refer to VOOSMP_MODULE_TYPE*/
    public int          GetModuleType();        
    
    /** [out]Output the version information */
    public String          GetVersion();  


}
