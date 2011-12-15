// jQuery Right-Click Plugin
//
// Version 1.01
//
// Cory S.N. LaViska
// A Beautiful Site (http://abeautifulsite.net/)
// 20 December 2008
//
// Visit http://abeautifulsite.net/notebook/68 for more information
//
// Usage:
//
//		// Capture right click
//		$("#selector").rightClick( function(e) {
//			// Do something
//		});
//		
//		// Capture right mouse down
//		$("#selector").rightMouseDown( function(e) {
//			// Do something
//		});
//		
//		// Capture right mouseup
//		$("#selector").rightMouseUp( function(e) {
//			// Do something
//		});
//		
//		// Disable context menu on an element
//		$("#selector").noContext();
// 
// History:
//
//		1.01 - Updated (20 December 2008)
//		     - References to 'this' now work the same way as other jQuery plugins, thus
//		       the el parameter has been deprecated.  Use this or $(this) instead
//		     - The mouse event is now passed to the callback function
//		     - Changed license to GNU GPL
//
//		1.00 - Released (13 May 2008)
//
// License:
// 
// This plugin is dual-licensed under the GNU General Public License and the MIT License
// and is copyright 2008 A Beautiful Site, LLC. 
//
if(jQuery) (function(){
	
	$j.extend($j.fn, {
		
		rightClick: function(handler) {
			$j(this).each( function() {
				$j(this).mousedown( function(e) {
					var evt = e;
					$j(this).mouseup( function() {
						$j(this).unbind('mouseup');
						if( evt.button == 2 ) {
							handler.call( $j(this), evt );
							return false;
						} else {
							return true;
						}
					});
				});
				$j(this)[0].oncontextmenu = function() {
					return false;
				}
			});
			return $j(this);
		},		
		
		rightMouseDown: function(handler) {
			$j(this).each( function() {
				$j(this).mousedown( function(e) {
					if( e.button == 2 ) {
						handler.call( $j(this), e );
						return false;
					} else {
						return true;
					}
				});
				$j(this)[0].oncontextmenu = function() {
					return false;
				}
			});
			return $j(this);
		},
		
		rightMouseUp: function(handler) {
			$j(this).each( function() {
				$j(this).mouseup( function(e) {
					if( e.button == 2 ) {
						handler.call( $j(this), e );
						return false;
					} else {
						return true;
					}
				});
				$j(this)[0].oncontextmenu = function() {
					return false;
				}
			});
			return $j(this);
		},
		
		noContext: function() {
			$j(this).each( function() {
				$j(this)[0].oncontextmenu = function() {
					return false;
				}
			});
			return $j(this);
		}
		
	});
	
})(jQuery);	