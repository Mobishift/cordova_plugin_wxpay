package com.mobishift.cordova.plugins.wxpay;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

/**
 * This class echoes a string called from JavaScript.
 */
public class WXPay extends CordovaPlugin {
    public static CallbackContext callbackContext = null;
    public static String appID = null;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("pay")) {

            String appId, partnerId, prepayId, packageValue, nonceStr, timeStamp, sign;
            IWXAPI msgApi = WXAPIFactory.createWXAPI(cordova.getActivity(), null);
            if(!msgApi.isWXAppInstalled()){
                callbackContext.error("您未安装微信");
                return false;
            }
            try{
                appId = args.getString(0);
                partnerId = args.getString(1);
                prepayId = args.getString(2);
                packageValue = args.getString(3);
                nonceStr = args.getString(4);
                timeStamp = args.getString(5);
                sign = args.getString(6);
            } catch (JSONException e) {
                callbackContext.error(e.getMessage());
                return false;
            }
            WXPay.callbackContext = callbackContext;
            WXPay.appID = appId;
            PayReq req;
            req = new PayReq();
            
            req.appId = appId;
            req.partnerId = partnerId;
            req.prepayId = prepayId;
            req.packageValue = packageValue;
            req.nonceStr = nonceStr;
            req.timeStamp = timeStamp;
            req.sign = sign;
            
            msgApi.registerApp(appId);
            msgApi.sendReq(req);
            
            return true;
        }
        return false;
    }
}
