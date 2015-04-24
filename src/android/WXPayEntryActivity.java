package net.ztmobile.letingche.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.mobishift.cordova.plugins.wxpay.WXPay;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

/**
 * Created by Gamma on 15/4/24.
 */
public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

    private IWXAPI api;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        api = WXAPIFactory.createWXAPI(this, WXPay.appID);
        api.handleIntent(getIntent(), this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        api.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        if(baseResp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX){
            switch (baseResp.errCode){
                case 0:
                    if(WXPay.callbackContext != null){
                        WXPay.callbackContext.success();
                    }
                    break;
                default:
                    if(WXPay.callbackContext != null){
                        WXPay.callbackContext.error("微信支付失败：" + baseResp.errCode);
                    }
                    break;
            }
        }else{
            if(WXPay.callbackContext != null){
                WXPay.callbackContext.error("发生了奇怪的事");
            }
        }
        this.finish();
    }
}
