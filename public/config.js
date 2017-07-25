'use strict';

// Init the application configuration module for AngularJS application
var ApplicationConfiguration = (function() {
	// Init module configuration options
	var applicationModuleName = 'Nederlandse Rode Kruis Dashboards';
	var applicationModuleVendorDependencies = ['ngResource', 'ngRoute',/*'routeStyles'*/,'ngCookies', 'ngTouch', 'ngSanitize', 'ui.router','ui.bootstrap', 'leaflet-directive', 'angular-lodash', 'gettext', 'AngularDc', 'formsAngular','angular-loading-bar'];

	// Add a new vertical module
	var registerModule = function(moduleName) {
		// Create angular module
		angular.module(moduleName, []);

		// Add the module to the AngularJS configuration file
		angular.module(applicationModuleName).requires.push(moduleName);
	};

	return {
		applicationModuleName: applicationModuleName,
		applicationModuleVendorDependencies: applicationModuleVendorDependencies,
		registerModule: registerModule
	};
})();