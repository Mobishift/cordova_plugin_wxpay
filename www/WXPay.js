window.WXPay = {
	execute: function(action, array, successCallback, errorCallback) {
		cordova.exec(    
			successCallback, 
			errorCallback,
			"WXPay",
			action,
			array
		)
	},
	pay: function(host, out_trade_no, successCallback, errorCallback) {
        var randomString = function (length) {
            var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('');
            
            if (! length) {
                length = Math.floor(Math.random() * chars.length);
            }
            
            var str = '';
            for (var i = 0; i < length; i++) {
                str += chars[Math.floor(Math.random() * chars.length)];
            }
            return str;
        }
        var request = new XMLHttpRequest();
        request.onreadystatechange = function(){
            if (request.readyState == 4) {
                if (request.status == 200) {
                    var data = JSON.parse(request.responseText);
                    if(data.sign){
                        this.execute("pay", [data.appId, data.partnerId, data.prepayId, data.packageValue, data.nonceStr, data.timeStamp, data.sign], successCallback, errorCallback);
                    }else{
                        errorCallback(null);
                    }
                }else{
                    errorCallback(null);
                }
            }
        }
        request.open("GET", host + "/wxpay/prepay_params?trade_type=APP&out_trade_no=" + out_trade_no, true);
        request.send();
	}
}
module.exports = WXPay;