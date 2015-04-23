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
	pay: function(array, successCallback, errorCallback) {
		this.execute("pay", array, successCallback, errorCallback);
	}
}
module.exports = WXPay;