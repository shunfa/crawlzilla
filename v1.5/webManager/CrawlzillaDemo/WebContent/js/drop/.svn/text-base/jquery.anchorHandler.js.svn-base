/*
  jQuery anchor handler - 0.5
  http://code.google.com/p/jquery-utils/

  (c) Maxime Haineault <haineault@gmail.com>
  http://haineault.com   

  MIT License (http://www.opensource.org/licenses/mit-license.php)

*/

(function($){
    var hash = window.location.hash;
    var handlers  = [];
    var opt = {};

	$.extend({
		anchorHandler: {
            apply: function() {
                $.map(handlers, function(handler){
                    var match = hash.match(handler.r) && hash.match(handler.r)[0] || false;
                    if (match)  { handler.cb.apply($('a[href*='+match+']').get(0), [handler.r, hash || '']); }
                });
                return $.anchorHandler;
            },
			add: function(regexp, callback, options) {
                var opt  = $.extend({handleClick: true, preserveHash: true}, options);
                if (opt.handleClick) { 
                    $('a[href*=#]').each(function(i, a){
                        if (a.href.match(regexp)) {
                            $(a).bind('click.anchorHandler', function(){
                                if (opt.preserveHash) { window.location.hash = a.hash; }
                                return callback.apply(this, [regexp, a.href]);
                                });
                        }
                    }); 
                }
				handlers.push({r: regexp, cb: callback});
                $($.anchorHandler.apply);
				return $.anchorHandler;
			}
		}
	});
})(jQuery);
