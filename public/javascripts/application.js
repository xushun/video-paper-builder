var VPB = VPB || {};

VPB = {
	// duration selector
	durationSelector: {
		convert:function(time) {
			hours = parseInt( time / 3600 ) % 24;
			minutes = parseInt( time / 60 ) % 60;
			seconds = time % 60;
			result = (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds  < 10 ? "0" + seconds : seconds);
			return result;
		},
		prevStart:undefined,
		prevStop:undefined,
		handleSlide:function(event, ui) {
			var start = VPB.durationSelector.convert(ui.values[0]);
			var end   = VPB.durationSelector.convert(ui.values[1]);
			$j('#section_video_start_time').attr('value', start);
			$j('#section_video_stop_time').attr('value', end);
		},
		handleStop:function(event, ui) {
			if(ui.values[0] !== this.prevStart) {
				$j('#kplayer').get(0).sendNotification('doPlay');
				$j('#kplayer').get(0).sendNotification('doSeek', ui.values[0]);
				$j('#kplayer').get(0).sendNotification('doPause');
			} else if (ui.values[1] !== this.prevStop) {
				$j('#kplayer').get(0).sendNotification('doPlay');
				$j('#kplayer').get(0).sendNotification('doSeek', ui.values[1]);
				$j('#kplayer').get(0).sendNotification('doPause');
			}
			
			$j('#kplayer').get(0).sendNotification('doPause');
			
			// hold this offsets for the next update.
			this.prevStart = ui.values[0];
			this.prevStop  = ui.values[1];
		},
		init: function() {
			// make sure we have time data to work with
			if(!VPB.SectionTimeData) { return; }
			
			// configure slider
			$j('#duration_slider').slider({
				range: true,
				min:0,
				max:VPB.SectionTimeData.length,
				values:[VPB.SectionTimeData.start,VPB.SectionTimeData.stop],
				slide:this.handleSlide,
				stop:this.handleStop
			});
			
			
		}
	},
	homePageSlideShow: {
		init:function() {
			// if there's no slideshow to work with, return.
			if(! $j('#slideshow').length) { return; }
			
			$j('#slideshow').after('<div class="paging"><ul id="thumbs">').cycle({ 
				fx: 'fade',
				pager: '#thumbs',
				pagerAnchorBuilder: function(idx, slide) {
					return '<li><a href="#"></a></li>';
				},
				activePagerClass: 'active',
				pause: 1,
				pauseOnPagerHover: 1
			});
		}
	},
	// initialize page
	init:function() {
		VPB.homePageSlideShow.init();
		VPB.durationSelector.init();
	}
};


// kick off page load
$j(document).ready(VPB.init);