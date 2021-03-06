'use strict';

module.exports = {
	app: {
		title: 'Community Profiles Dashboard',
		description: 'Full-Stack JavaScript with MongoDB, Express, AngularJS, and Node.js',
		keywords: 'MongoDB, Express, AngularJS, Node.js'//,
		//googleAnalyticsTrackingID: 'UA-83697955-2' // process.env.GOOGLE_ANALYTICS_TRACKING_ID || 
	},
	port: process.env.PORT || 3000,
	sslport: process.env.SSLPORT || 444,
	key_file: './config/cert/localhost-key.pem',
	cert_file: './config/cert/localhost-cert.pem',
	templateEngine: 'swig',
	sessionSecret: 'MEAN',
	assets: {
		lib: {
			css: [
				'public/build/bower/forms-angular/css/forms-angular-with-bs3.css', // in bower.json
				'public/build/bower/bootstrap/css/bootstrap.min.css', // in bower.json
				'public/build/custom/bootstrap/css/bootstrap-theme.min.css', // in bower.json
				//'public/build/custom/leaflet/css/leaflet.css', // in bower.json
                'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/leaflet.css', 
				'public/build/bower/cartodb.js/css/cartodb.css', // in bower.json
				'public/build/bower/angular/css/angular-csp.css', // in bower.json
				'public/build/bower/mdi/css/materialdesignicons.min.css', // in bower.json
				'public/build/bower/dcjs/css/dc.css', // in bower.json
				//'public/build/custom/dc-leaflet/css/dc-leaflet-legend.min.css', // NOT in bower.json
				//'public/build/bower/materialize/css/materialize.css', // in bower.json
				'public/build/bower/angular-loading-bar/css/loading-bar.css', // in bower.json
				'public/build/custom/font-awesome/css/font-awesome.min.css', // NOT in bower.json
				'public/build/custom/dc-addons/dist/leaflet-map/dc-leaflet-legend.css', // NOT in bower.json
				'public/build/custom/leaflet-search/css/leaflet-search.src.css' // NOT in bower.json
				
			],
			js: [

				'public/build/bower/jquery/js/jquery.min.js', // in bower.json
				'public/build/custom/slick/js/slick.min.js', 
				'public/build/bower/crossfilter/js/crossfilter.min.js',
				//'public/lib/jquery-ui/ui/jquery-ui.js',
				'public/build/bower/lodash/js/lodash.underscore.min.js', //in bower.json
				'public/build/bower/angular/js/angular.js', //in bower.json
				'public/build/bower/angular-lodash/js/angular-lodash.js', //in bower.json
				'public/build/bower/angular-route/js/angular-route.js', //in bower.json
				'public/build/bower/angular-resource/js/angular-resource.js', //in bower.json
				'public/build/bower/angular-cookies/js/angular-cookies.js', //in bower.json 
				'public/build/bower/angular-touch/js/angular-touch.js', 
				'public/build/bower/angular-sanitize/js/angular-sanitize.js', 
				'public/build/bower/angular-ui-router/js/angular-ui-router.min.js', 
				'public/build/bower/angular-css/js/angular-css.js',
				'public/lib/angular-translate/angular-translate.js',	//in bower.json
				'public/build/bower/angular-route-styles/js/route-styles.js',
				'public/build/bower/bootstrap/js/bootstrap.min.js',
				'public/build/bower/angular-bootstrap/js/ui-bootstrap-tpls.js',
				//'public/build/bower/leaflet/js/leaflet-src.js',//in bower.json
				//'public/build/bower/leaflet/js/leaflet.js',//in bower.json
                'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/leaflet.js',
				'public/build/bower/angular-leaflet-directive/js/angular-leaflet-directive.js', // in bower.json
				'public/build/custom/leaflet-search/js/leaflet-search.src.js', //NOT in bower.json
				'public/build/bower/leaflet-ajax/js/leaflet.ajax.js',
				'public/build/bower/angular-gettext/js/angular-gettext.js',
				'public/dist/translations.js',
				'public/build/bower/Snap.svg/js/snap.svg-min.js',
				'public/build/bower/d3/js/d3.js',
				'public/build/bower/dcjs/js/dc.js', //in bower.json
				'public/build/custom/dc-leaflet/js/dc-leaflet-dev.js', // NOT in bower.json
				//'public/build/custom/leaflet-map/js/dc-leaflet.js', // NOT in bower.json
				//'public/build/bower/materialize/js/materialize.js',
				'public/build/custom/leaflet-stamen/tile.stamen.js', // NOT in bower.json
				'public/build/custom/angular-dc/js/angular-dc.js', //in bower.json
				'public/build/custom/forms-angular/js/forms-angular.js', //in bower.json
				'public/build/custom/d3-tip/js/d3-tip.js', //NOT in bower.json
				'public/build/bower/angular-messages/js/angular-messages.js', //in bower.json
				'public/build/bower/ngInfiniteScroll/js/ng-infinite-scroll.js',//in bower.json
				'public/build/bower/angular-elastic/js/elastic.js', //in bower.json
				'public/build/bower/underscore/js/underscore.js',//in bower.json
				'public/build/bower/angular-loading-bar/js/loading-bar.js',
				'public/build/bower/leaflet-gps/js/leaflet-gps.min.js', // in bower.json
				'https://maps.googleapis.com/maps/api/js?v=3&sensor=true',
				'public/build/bower/cartodb.js/js/cartodb_noleaflet.js', // in bower.json
				'public/build/custom/jquery-tabslideout/js/tabSlideOut.js', // NOT in bower.json
				'public/build/bower/jquery-countTo/js/jquery.countTo.js', // in bower.json
				'public/build/bower/jquery-scrollTo/js/jquery-scrollTo.js', // in bower.json
				'public/build/bower/jquery-easing/js/jquery.easing.min.js', // in bower.json
				'public/lib/jquery-csv/src/jquery.csv.js', // in bower.json
				'public/build/bower/wow/js/wow.js', // in bower.json
				'https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js',
				'https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.0.272/jspdf.debug.js',
				// 'https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.2/jspdf.min.js',
				// 'https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2014-11-29/FileSaver.min.js',
				// 'http://cdn.uriit.ru/jsPDF/libs/adler32cs.js/adler32cs.js',
				// 'http://cdn.immex1.com/js/jspdf/plugins/jspdf.plugin.addimage.js',
				// 'http://cdn.immex1.com/js/jspdf/plugins/jspdf.plugin.standard_fonts_metrics.js',
				// 'http://cdn.immex1.com/js/jspdf/plugins/jspdf.plugin.split_text_to_size.js',
				// 'http://cdn.immex1.com/js/jspdf/plugins/jspdf.plugin.from_html.js',
				'public/build/custom/dc-addons/dist/leaflet-map/dc-leaflet.js', // in bower.json
				'public/build/bower/topojson/js/topojson.js' // in bower.json
			]
		},
		css: [
			'public/modules/*[!dashboards]*/css/*.css'
		],
		js: [
			'public/config.js',
			'public/application.js',
			'public/modules/*/*.js',
			'public/modules/*/*[!tests]*/*.js'
		],
		tests: [
			'public/lib/angular-mocks/angular-mocks.js',
			'public/modules/*/tests/*.js'
		]
	}
};