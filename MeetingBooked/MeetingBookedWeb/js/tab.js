	
//教师成长tab
	$(function(){
			$(".yy_tab .yy_tabheader").find("a").click(function(){
				var index = $(this).parent().index();
				$(this).parent().addClass("selected").siblings().removeClass("selected");
				$(this).parents(".yy_tab").find(".tc").eq(index).show().siblings().hide();	
			});	
		});
		
	//+更多	
	$(function(){
		 $(".J-more").click(function(){
  			$(this).html($(this).html() == "更多" ? "收起" : "更多");
  			$(this).parents('.boxmore').siblings('.con_text').find('.con_con').toggle();
 		});
	})
	//教师科研tab
	$(function(){
			$(".ky_tab .ky_tabheader").find("a").click(function(){
				var index = $(this).parent().index();
				$(this).parent().addClass("selected");
				$(this).parents(".ky_tab").find(".tc").eq(index).show().siblings().hide();	
			});	
		});