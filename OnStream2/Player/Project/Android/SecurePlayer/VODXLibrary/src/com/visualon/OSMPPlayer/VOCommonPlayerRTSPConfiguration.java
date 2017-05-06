/************************************************************************
VisualOn Proprietary
Copyright (c) 2013, VisualOn Incorporated. All Rights Reserved

VisualOn, Inc., 4675 Stevens Creek Blvd, Santa Clara, CA 95051, USA

All data and information contained in or disclosed by this document are
confidential and proprietary information of VisualOn, and all rights
therein are expressly reserved. By accepting this material, the
recipient agrees that this material and the information contained
therein are held in confidence and in trust. The material may only be
used and/or disclosed as authorized in a license agreement controlling
such use and disclosure.
************************************************************************/

package com.visualon.OSMPPlayer;

import com.visualon.OSMPPlayer.VOOSMPType.VO_OSMP_RETURN_CODE;
import com.visualon.OSMPPlayer.VOOSMPType.VO_OSMP_RTSP_CONNECTION_TYPE;

public interface VOCommonPlayerRTSPConfiguration {
	

    /**
     * Set RTSP connection type. The default is {@link VO_OSMP_RTSP_CONNECTION_TYPE#VO_OSMP_RTSP_CONNECTION_AUTOMATIC}.
     *
     * @param   type   [in] Connection type. {@link VO_OSMP_RTSP_CONNECTION_TYPE}
     *
     * @return  {@link VO_OSMP_RETURN_CODE#VO_OSMP_ERR_NONE} if successful.
     */
    VO_OSMP_RETURN_CODE setRTSPConnectionType(VO_OSMP_RTSP_CONNECTION_TYPE type);
    /**
     * Set port number for RTSP connection
     *
     * @param   portNum   [in] port number
     *
     * @return  {@link VO_OSMP_ERR_NONE} if successful.
     */
    
    VO_OSMP_RETURN_CODE setRTSPConnectionPort(VOOSMPRTSPPort portNum);

    /**
     * Get the RTSP module status value
     *
     * @return  A {@link VOOSMPRTSPStatistics} object if successful or null if failed.
     *
     */
    VOOSMPRTSPStatistics getRTSPStatistics();
    
    /**
     * Enable RTSP over HTTP tunneling. The default is disable.
     *
     * @param   enable  [in] Enable/Disable; true to enable, false to disable(default).
     *
     * @return  {@link VO_OSMP_ERR_NONE} if successful
     */
    VO_OSMP_RETURN_CODE enableRTSPOverHTTP(boolean enable);


    /**
     * Set port number for RTSP over HTTP tunneling.
     *
     * @param   portNum   [in] port number
     *
     * @return  {@link VO_OSMP_ERR_NONE} if successful
     */
    VO_OSMP_RETURN_CODE setRTSPOverHTTPConnectionPort(int portNum);
}
