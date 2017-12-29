// JavaScript Document

//导航JS
	$(function(){	
	 	var pageURl=window.location.href;
		function navjs(obj){
			obj.each(function(){
				var href=$(this).children('a').attr('href');
				if(href.length<3){
		 			href=window.location.host;
		 		}
				if(window.location.href.indexOf(href)>-1){	 					if(href==window.location.href||window.location.href=="http://"+href+"/"){			 	
		 						jQuery(this).attr("class",jQuery(this).attr("currentClass"));	
			 		}else{
			 			if(href!=window.location.host&&href!="http://"+window.location.host+"/"&&window.location.href.indexOf(href)>-1){
							jQuery(this).attr("class",jQuery(this).attr("currentClass"));	
			 			}else{	 		 							jQuery(this).attr("class",jQuery(this).attr("bakClass"));		
						}	
					}
				}else{
		 				if(jQuery(this).children("div").children().is("ul")){
							var isHas=false;
							jQuery(this).children("div").children("ul").children("li").each(function(){
								if(pageURl.indexOf(jQuery(this).children("a").attr("href"))>-1){
									isHas=true;
									return false;
								}
								if(isHas){
									jQuery(this).attr("class",jQuery(this).attr("currentClass"));
								}else{
									jQuery(this).attr("class",jQuery(this).attr("bakClass"));
								}
					});	
				}
			}
			});
		}
		navjs($('.menu_mid ul li'));
	});