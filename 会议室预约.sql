USE [master]
GO
/****** Object:  Database [MeetingBooked]    Script Date: 2016/10/21 15:39:20 ******/
CREATE DATABASE [MeetingBooked]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MeetingBooked', FILENAME = N'C:\Relase\DB\MeetingBooked.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MeetingBooked_log', FILENAME = N'C:\Relase\DB\MeetingBooked_log.ldf' , SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MeetingBooked] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MeetingBooked].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MeetingBooked] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MeetingBooked] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MeetingBooked] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MeetingBooked] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MeetingBooked] SET ARITHABORT OFF 
GO
ALTER DATABASE [MeetingBooked] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MeetingBooked] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MeetingBooked] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MeetingBooked] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MeetingBooked] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MeetingBooked] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MeetingBooked] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MeetingBooked] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MeetingBooked] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MeetingBooked] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MeetingBooked] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MeetingBooked] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MeetingBooked] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MeetingBooked] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MeetingBooked] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MeetingBooked] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MeetingBooked] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MeetingBooked] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MeetingBooked] SET RECOVERY FULL 
GO
ALTER DATABASE [MeetingBooked] SET  MULTI_USER 
GO
ALTER DATABASE [MeetingBooked] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MeetingBooked] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MeetingBooked] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MeetingBooked] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'MeetingBooked', N'ON'
GO
USE [MeetingBooked]
GO
/****** Object:  User [YFBWS2012\Administrator]    Script Date: 2016/10/21 15:39:20 ******/
CREATE USER [YFBWS2012\Administrator] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_BindMeeting]    Script Date: 2016/10/21 15:39:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--根据ID查询会议室信息
create procedure [dbo].[Proc_BindMeeting]
	@id int
AS
BEGIN
       select MeetingName from Meeting where id=@id
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_BindTimeSection]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--根据ID查询时间段信息
create procedure [dbo].[Proc_BindTimeSection]
	@id int
AS
BEGIN
       select TimeSectionName from TimeSection where id=@id
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_BindUserInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--根据ID查询用户信息
create procedure [dbo].[Proc_BindUserInfo]
	@id int
AS
BEGIN
       select * from UserInfo a left join Role b on a.RoleID=b.id where a.id=@id
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetList]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 查询会议室和时间段表
CREATE procedure [dbo].[Proc_GetList]
AS
BEGIN
   select * from Meeting where  IsDelete=0
   select * from TimeSection  where  IsDelete=0
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetLogin]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




 --alter table UserInfo add PassWord varchar(40)
 --alter table UserInfo add LoginName varchar(40)
---登陆
create procedure [dbo].[Proc_GetLogin]
	@LoginName varchar(50),
	@PassWord varchar(40)
AS
BEGIN
    select * from UserInfo where LoginName=@LoginName and PassWord=@PassWord
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetMeeting]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		CREATE procedure [dbo].[Proc_GetMeeting]
	@MeetingName varchar(50)
AS
BEGIN
       select a.id,MeetingName,CreateTime,b.Name as CreatorName ,(case a.IsDelete when 0 then '正常' else '禁用' end ) as IsDeleteName,a.IsDelete  from Meeting a
	   left join UserInfo b on a.Creator=b.id
	    where MeetingName like '%'+@MeetingName+'%'
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_getMeetingBooked]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---获取当前会议室是否被占用
CREATE procedure [dbo].[Proc_getMeetingBooked]
	@BookedDate varchar(50),
	@MeetingID int
AS
BEGIN


 select  a.id,a.TimeSectionName ,(case c.Name when '' then C.Name else  (case b.Status when 0 then '待审核' else '预定中' end)+'：'+c.Name end) as Name ,c.Phone,b.Status,b.id as MeetingID,b.MeetingTitle from TimeSection a 
left join MeetingBooked b on a.id=b.TimeSectionID and b.BookedDate=@BookedDate and b.MeetingID=@MeetingID
left join UserInfo c on b.UserInfoID=c.id
	
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetMenuInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---获取树功能菜单
create procedure [dbo].[Proc_GetMenuInfo]
	@RoleId int
AS
BEGIN
    if @RoleId=1
	begin
	    select b.* from RoleOfMenu a left join MenuInfo b on a.MenuId=b.Id
		where a.RoleID=@RoleId
	end
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_getUserInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---钉钉登陆判断账号所属
CREATE procedure [dbo].[Proc_getUserInfo]
	@UserName varchar(50),
	@UserPhone varchar(20)
AS
BEGIN
   select * from UserInfo where Name=@UserName and Phone=@UserPhone
  
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_InMeeting]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--添加/修改会议室
create procedure [dbo].[Proc_InMeeting]
	@MeetingName varchar(50),
	@userid int,
	@id int,
	@Type varchar(20)
AS
BEGIN
     if(select COUNT(*) from Meeting where MeetingName=@MeetingName)>0
	 begin
	    select 'CF'
	 end
	 else
	 begin
	    if @type='Up'
		begin
		   update Meeting set MeetingName=@MeetingName where id=@id 
		    if @@RowCount >0
              select 'OK'
            else
              select 'NO'
		  end
		else
		begin
           insert into Meeting values(@MeetingName,GETDATE(),@userid,0)
	       if @@RowCount >0
              select 'OK'
            else
              select 'NO'
		 end
	  end
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_InTimeSection]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--添加/修改时间段
create procedure [dbo].[Proc_InTimeSection]
	@TimeSectionName varchar(50),
	@userid int,
	@id int,
	@Type varchar(20)
AS
BEGIN
     if(select COUNT(*) from TimeSection where TimeSectionName=@TimeSectionName)>0
	 begin
	    select 'CF'
	 end
	 else
	 begin
	    if @type='Up'
		begin
		   update TimeSection set TimeSectionName=@TimeSectionName where id=@id 
		    if @@RowCount >0
              select 'OK'
            else
              select 'NO'
		  end
		else
		begin
           insert into TimeSection values(@TimeSectionName,GETDATE(),@userid,0)
	       if @@RowCount >0
              select 'OK'
            else
              select 'NO'
		 end
	  end
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_InUserInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--添加/修改人员信息
create procedure [dbo].[Proc_InUserInfo]
	@Name varchar(50),
	@IDCard varchar(18),
    @Phone varchar(20),
	@RoleID int,
	@LoginName varchar(40),
	@id int,
	@Type varchar(20)
AS
BEGIN
	    if @type='Up'
		begin
		   update UserInfo set IDCard=@IDCard,Phone=@Phone,RoleID=@RoleID where id=@id 
		    if @@RowCount >0
              select 'OK'
            else
              select 'NO'
	    end
		else
		begin
		   if(select COUNT(*) from UserInfo where Name=@Name and Phone=@Phone)>0
		   begin
				select 'CF'
		   end
		   else
		   begin
			   insert into UserInfo values(@Name,@IDCard,@Phone,@RoleID,'96e79218965eb72c92a549dd5a330112',@LoginName,0)  --默认密码6个1
			   if @@RowCount >0
				  select 'OK'
				else
				  select 'NO'
		   end
	    end
	 
END

GO
/****** Object:  StoredProcedure [dbo].[PROC_InUserLog]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PROC_InUserLog]
   @Name varchar(50) ='',
   @phone varchar(50)=''
AS
BEGIN
   insert into UserInfo values(@Name,'',@phone,2,'96e79218965eb72c92a549dd5a330112',@phone,0)
     if @@RowCount >0
		select 'OK'
	else
		select 'NO'
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_qxBooked]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[Proc_qxBooked]
	@id int
AS
BEGIN
     delete MeetingBooked where bs=@id
	 if @@RowCount >0
           select 'OK'
       else
           select 'NO'
	
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_SeeMeeting]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---查询申请信息
CREATE procedure [dbo].[Proc_SeeMeeting]
@id int =0,
@Name varchar(20),
@Phone varchar(20)
AS
BEGIN
	       DECLARE @index int
		   IF Object_id('Tempdb..#LSMeetingBooked') IS NOT NULL   
           DROP TABLE #LSMeetingBooked 
		   create table #LSMeetingBooked
		   (
		    id int not null identity (1,1),
      	    MeetingBookedid int,
            Status varchar(50),
			Name nvarchar(50),
			BookedDate nvarchar(50),
			TimeSectionID int,
			MeetingTitle  nvarchar(50),
			MeetingName nvarchar(50),
			TimeSectionName nvarchar(50),
			RoleID varchar(50),
			bs int
        	)

         
		   IF Object_id('Tempdb..#LSMeetingBookedSC') IS NOT NULL   
           DROP TABLE #LSMeetingBookedSC 
		   create table #LSMeetingBookedSC
		   (
		    id int not null identity (1,1),
            Status varchar(50),
			Name nvarchar(50),
			BookedDate nvarchar(50),
			MeetingTitle  nvarchar(50),
			MeetingName nvarchar(50),
			TimeSectionName nvarchar(50),
			RoleID varchar(50),
			bs int
        	)

  
          IF Object_id('Tempdb..#LSMeetingBookedbs') IS NOT NULL   
           DROP TABLE #LSMeetingBookedbs 
		   create table #LSMeetingBookedbs
		   (
		    id int not null identity (1,1),
         	 bs int
        	)
		
		 if ((select RoleID from UserInfo where Name=@Name and Phone=@Phone)=1)
		   begin
		      insert into #LSMeetingBooked    select a.id,(case a.Status when 0 then '待审核' when 1 then '预定中'else '驳回' end ) as Status,b.Name,CONVERT(varchar(10), a.BookedDate, 23) as BookedDate,a.TimeSectionID,a.MeetingTitle,c.MeetingName,d.TimeSectionName,b.RoleID,a.bs from  UserInfo b 
			   join MeetingBooked a on  a.UserInfoID=b.id 
			   left join Meeting c on a.MeetingID=c.id
			   left join TimeSection d on a.TimeSectionID=d.id
			   where ((b.Name=@Name and b.Phone=@Phone) or a.status=0) 
			   and (a.id=@id or @id=0)
		   end
		   else
		   begin
		      insert into #LSMeetingBooked    select a.id,(case a.Status when 0 then '待审核' when 1 then '预定中'else '驳回' end ) as Status,b.Name,CONVERT(varchar(10), a.BookedDate, 23) as BookedDate,a.TimeSectionID,a.MeetingTitle,c.MeetingName,d.TimeSectionName,b.RoleID,a.bs from  UserInfo b 
			   join MeetingBooked a on  a.UserInfoID=b.id 
			   left join Meeting c on a.MeetingID=c.id
			   left join TimeSection d on a.TimeSectionID=d.id
			   where b.Name=@Name and b.Phone=@Phone
			 
		   end

	   insert into #LSMeetingBookedbs select bs from #LSMeetingBooked group by bs

	   set @index= 1
	   WHILE @index<= (select count(*)  from #LSMeetingBookedbs)
		BEGIN
			declare @date varchar(20)
		    set @date=( ( select top 1 left(TimeSectionName,charindex('-',TimeSectionName)-1) from #LSMeetingBooked where bs=(select bs  from #LSMeetingBookedbs where id=@index) order by id ) +'-'+ 
			 ( select top 1 RIGHT(TimeSectionName,charindex('-',TimeSectionName)-1) from #LSMeetingBooked where bs=(select bs  from #LSMeetingBookedbs where id=@index) order by id  desc))
			 insert into #LSMeetingBookedSC select top 1 status,Name,bookeddate,MeetingTitle,MeetingName,@date,RoleID,bs from #LSMeetingBooked where bs=(select bs  from #LSMeetingBookedbs where id=@index)
			
		    set @index=@index+1
		END

		select * from #LSMeetingBookedSC order by BookedDate desc
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SeeMeeting1]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---查询申请信息
CREATE procedure [dbo].[Proc_SeeMeeting1]
@id int =0,
@Name varchar(20),
@Phone varchar(20)
AS
BEGIN
	       DECLARE @index int
		   IF Object_id('Tempdb..#LSMeetingBooked') IS NOT NULL   
           DROP TABLE #LSMeetingBooked 
		   create table #LSMeetingBooked
		   (
		    id int not null identity (1,1),
      	    MeetingBookedid int,
            Status varchar(50),
			Name varchar(50),
			BookedDate varchar(50),
			TimeSectionID int,
			MeetingTitle  varchar(50),
			MeetingName varchar(50),
			TimeSectionName varchar(50),
			RoleID varchar(50),
			bs int
        	)

         
		   IF Object_id('Tempdb..#LSMeetingBookedSC') IS NOT NULL   
           DROP TABLE #LSMeetingBookedSC 
		   create table #LSMeetingBookedSC
		   (
		    id int not null identity (1,1),
            Status varchar(50),
			Name varchar(50),
			BookedDate varchar(50),
			MeetingTitle  varchar(50),
			MeetingName varchar(50),
			TimeSectionName varchar(50),
			RoleID varchar(50),
			bs int
        	)

  
          IF Object_id('Tempdb..#LSMeetingBookedbs') IS NOT NULL   
           DROP TABLE #LSMeetingBookedbs 
		   create table #LSMeetingBookedbs
		   (
		    id int not null identity (1,1),
         	 bs int
        	)
		
		 if ((select RoleID from UserInfo where Name=@Name and Phone=@Phone)=1)
		   begin
		      insert into #LSMeetingBooked    select a.id,(case a.Status when 0 then '待审核' when 1 then '预定中'else '驳回' end ) as Status,b.Name,CONVERT(varchar(10), a.BookedDate, 23) as BookedDate,a.TimeSectionID,a.MeetingTitle,c.MeetingName,d.TimeSectionName,b.RoleID,a.bs from  UserInfo b 
			   join MeetingBooked a on  a.UserInfoID=b.id 
			   left join Meeting c on a.MeetingID=c.id
			   left join TimeSection d on a.TimeSectionID=d.id
			   where ((b.Name=@Name and b.Phone=@Phone) or a.status=0) 
			   and (a.id=@id or @id=0)
		   end
		   else
		   begin
		      insert into #LSMeetingBooked    select a.id,(case a.Status when 0 then '待审核' when 1 then '预定中'else '驳回' end ) as Status,b.Name,CONVERT(varchar(10), a.BookedDate, 23) as BookedDate,a.TimeSectionID,a.MeetingTitle,c.MeetingName,d.TimeSectionName,b.RoleID,a.bs from  UserInfo b 
			   join MeetingBooked a on  a.UserInfoID=b.id 
			   left join Meeting c on a.MeetingID=c.id
			   left join TimeSection d on a.TimeSectionID=d.id
			   where b.Name=@Name and b.Phone=@Phone
			 
		   end

	   insert into #LSMeetingBookedbs select bs from #LSMeetingBooked group by bs

	   set @index= 1
	   WHILE @index<= (select count(*)  from #LSMeetingBookedbs)
		BEGIN
			declare @date varchar(20)
		    set @date=( ( select top 1 left(TimeSectionName,charindex('-',TimeSectionName)-1) from #LSMeetingBooked where bs=(select bs  from #LSMeetingBookedbs where id=@index) order by id ) +'-'+ 
			 ( select top 1 RIGHT(TimeSectionName,charindex('-',TimeSectionName)-1) from #LSMeetingBooked where bs=(select bs  from #LSMeetingBookedbs where id=@index) order by id  desc))
			 insert into #LSMeetingBookedSC select top 1 status,Name,bookeddate,MeetingTitle,MeetingName,@date,RoleID,bs from #LSMeetingBooked where bs=(select bs  from #LSMeetingBookedbs where id=@index)
			
		    set @index=@index+1
		END

		select * from #LSMeetingBookedSC order by BookedDate desc
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SeeMeetings]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---查询申请信息详细
CREATE procedure [dbo].[Proc_SeeMeetings]
	@id int =0,
	@Name varchar(20),
    @Phone varchar(20)
AS
BEGIN
 
         
		   IF Object_id('Tempdb..#LSSeeMeetingBooked') IS NOT NULL   
           DROP TABLE #LSSeeMeetingBooked 
		   create table #LSSeeMeetingBooked
		   (
		    id int not null identity (1,1),
            StatusID varchar(50),
			Status varchar(50),
			Name varchar(50),
			BookedDate varchar(50),
			MeetingTitle  varchar(50),
			MeetingName varchar(50),
			TimeSectionName varchar(50),
			RoleID varchar(50),
			bs int
        	)
	    insert into #LSSeeMeetingBooked   select a.Status as StatusID,(case a.Status when 0 then '待审核' when 1 then '预定中'else '不通过' end ) as Status,b.Name,CONVERT(varchar(10), a.BookedDate, 23) as BookedDate,
		a.MeetingTitle,c.MeetingName,d.TimeSectionName,b.RoleID,a.bs from MeetingBooked a 
		   left join UserInfo b on a.UserInfoID=b.id
		   left join Meeting c on a.MeetingID=c.id
		   left join TimeSection d on a.TimeSectionID=d.id
		   where  a.bs=@id
		   declare @date varchar(20)
		     set @date=( select top 1 left(TimeSectionName,charindex('-',TimeSectionName)-1) from #LSSeeMeetingBooked order by id )   +'-'+ 
			 ( select top 1 RIGHT(TimeSectionName,charindex('-',TimeSectionName)-1) from #LSSeeMeetingBooked order by id  desc)
			 select top 1  StatusID ,Status,	Name ,BookedDate ,MeetingTitle ,MeetingName ,@date as TimeSectionName ,RoleID ,bs int from #LSSeeMeetingBooked


END
GO
/****** Object:  StoredProcedure [dbo].[Proc_SetList]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---添加预约信息
CREATE  procedure [dbo].[Proc_SetList]
   @MeetingTitle varchar(100) = null,
   @MeetingID int = null,
   @TimeSectionID int =null,
   @BookedDate date = null,
   @Remark varchar(200) = null,
   @Name varchar(50),
   @Phone varchar(20),
   @bs varchar(50)
AS
BEGIN
    DECLARE @id int
    DECLARE @index int
    DECLARE @WhatBooked int
		select @index=count(*) from MeetingBooked where MeetingID=@MeetingID and TimeSectionID=@TimeSectionID and BookedDate=@BookedDate
	if(@index>0)
	begin
	 select 'CF'
	end
	else
	begin
	    if((select top 1 WhatBooked from Meeting)=1)
		begin
		  set  @WhatBooked=0  --需要审核
		end
		else
		begin
		  set  @WhatBooked=1  --不需要审核
		end
		select @id=id from [dbo].[UserInfo] where Name=@Name and Phone=@Phone
	   
	    insert into MeetingBooked values(@MeetingTitle,@MeetingID,@TimeSectionID,@id,@BookedDate,@WhatBooked,@Remark,'',@bs)
	    if @@RowCount >0
		  select 'OK'
	    else
		 select 'NO'
	 end

END

GO
/****** Object:  StoredProcedure [dbo].[Proc_SetMeeting]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[Proc_SetMeeting]
	@IsDelete int,
	@id int
AS
BEGIN
        update Meeting set IsDelete=@IsDelete where id=@id
		if @@RowCount >0
           select 'OK'
         else
           select 'NO'
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_SetTimeSection]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--启用/禁用时间段
create procedure [dbo].[Proc_SetTimeSection]
	@IsDelete int,
	@id int
AS
BEGIN
        update TimeSection set IsDelete=@IsDelete where id=@id
		if @@RowCount >0
           select 'OK'
         else
           select 'NO'
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_SetUserInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---修改密码
create procedure [dbo].[Proc_SetUserInfo]
	@id int,
	@oldpwd varchar(40),--旧密码
	@pwd varchar(40)  --新密码

AS
BEGIN
    if(select COUNT(*) from UserInfo where id=@id and PassWord=@oldpwd)>0
	begin
	    update UserInfo set PassWord=@pwd where id=@id
		if @@RowCount >0
           select 'OK'
         else
           select 'NO'
	end
	else
	begin
	    select 'CW'
	end

END

GO
/****** Object:  StoredProcedure [dbo].[Proc_SetUserInfoIsDelete]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--启用/禁用账号
create procedure [dbo].[Proc_SetUserInfoIsDelete]
	@IsDelete int,
	@id int
AS
BEGIN
        update UserInfo set IsDelete=@IsDelete where id=@id
		if @@RowCount >0
           select 'OK'
         else
           select 'NO'
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_UpMeetingBooked]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---审核预约信息
CREATE procedure [dbo].[Proc_UpMeetingBooked]
	@id int,
	@status int,
	@BookedRemark varchar(200)
AS
BEGIN
 if @status=1
 begin
	 update MeetingBooked set Status=@status,BookedRemark=@BookedRemark where bs=@id
	  if @@RowCount >0
		  select 'OK'
	   else
		   select 'NO'
 end
 else
 begin
    delete MeetingBooked  where bs=@id
	if @@RowCount >0
		  select 'OK'
	   else
		   select 'NO'
 end
END


GO
/****** Object:  StoredProcedure [dbo].[Proc_WhatBooked]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--设置/取消是否需要审核
create procedure [dbo].[Proc_WhatBooked]
	@index int
AS
BEGIN
      update Meeting set WhatBooked=@index
	   if @@RowCount >0
		  select 'OK'
	   else
		  select 'NO'
END

GO
/****** Object:  Table [dbo].[Meeting]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meeting](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MeetingName] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [nvarchar](50) NULL,
	[IsDelete] [int] NULL,
	[WhatBooked] [int] NOT NULL,
 CONSTRAINT [PK__Meeting__3213E83FF0432A82] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MeetingBooked]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeetingBooked](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MeetingTitle] [nvarchar](100) NULL,
	[MeetingID] [int] NULL,
	[TimeSectionID] [int] NULL,
	[UserInfoID] [int] NULL,
	[BookedDate] [date] NULL,
	[Status] [int] NULL,
	[Remark] [nvarchar](200) NULL,
	[BookedRemark] [nvarchar](200) NULL,
	[bs] [int] NULL,
 CONSTRAINT [PK__MeetingB__3213E83FC47C6F22] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MenuInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Pid] [int] NOT NULL,
	[Url] [nvarchar](200) NULL,
	[Description] [nvarchar](300) NULL,
	[isMeu] [bit] NOT NULL,
	[isShow] [tinyint] NOT NULL,
	[iconClass] [varchar](50) NULL,
	[sortId] [int] NULL,
 CONSTRAINT [PK_MenuInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleOfMenu]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleOfMenu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[MenuId] [int] NOT NULL,
 CONSTRAINT [PK_RoleOfMenu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TimeSection]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TimeSection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TimeSectionName] [varchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Creator] [varchar](50) NULL,
	[IsDelete] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserInfo]    Script Date: 2016/10/21 15:39:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[IDCard] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[RoleID] [int] NULL,
	[PassWord] [nvarchar](50) NULL,
	[LoginName] [nvarchar](50) NULL,
	[IsDelete] [int] NULL,
 CONSTRAINT [PK__UserInfo__3213E83FE0360530] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Meeting] ON 

INSERT [dbo].[Meeting] ([id], [MeetingName], [CreateTime], [Creator], [IsDelete], [WhatBooked]) VALUES (1, N'711室大会议室', NULL, NULL, 0, 0)
INSERT [dbo].[Meeting] ([id], [MeetingName], [CreateTime], [Creator], [IsDelete], [WhatBooked]) VALUES (2, N'711室1号会议室', NULL, NULL, 0, 0)
INSERT [dbo].[Meeting] ([id], [MeetingName], [CreateTime], [Creator], [IsDelete], [WhatBooked]) VALUES (3, N'711室3号会议室', NULL, NULL, 0, 0)
INSERT [dbo].[Meeting] ([id], [MeetingName], [CreateTime], [Creator], [IsDelete], [WhatBooked]) VALUES (4, N'703室4号会议室', NULL, NULL, 0, 0)
INSERT [dbo].[Meeting] ([id], [MeetingName], [CreateTime], [Creator], [IsDelete], [WhatBooked]) VALUES (5, N'716室5号会议室', NULL, NULL, 0, 0)
INSERT [dbo].[Meeting] ([id], [MeetingName], [CreateTime], [Creator], [IsDelete], [WhatBooked]) VALUES (6, N'716室6号会议室', NULL, NULL, 0, 0)
SET IDENTITY_INSERT [dbo].[Meeting] OFF
SET IDENTITY_INSERT [dbo].[MeetingBooked] ON 

INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (5, N'人事部面试', 4, 5, 17, CAST(0xA33B0B00 AS Date), 1, N'', N'', 5)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (6, N'人事部面试', 4, 6, 17, CAST(0xA33B0B00 AS Date), 1, N'', N'', 6)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (9, N'普教销售4个部门培训', 1, 1, 17, CAST(0xA33B0B00 AS Date), 1, N'英语考场项目', N'', 9)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (10, N'普教销售4个部门培训', 1, 2, 17, CAST(0xA33B0B00 AS Date), 1, N'英语考场项目', N'', 10)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (11, N'普教销售4个部门培训', 1, 3, 17, CAST(0xA33B0B00 AS Date), 1, N'英语考场项目', N'', 11)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (12, N'部门会议', 1, 5, 129, CAST(0xA33B0B00 AS Date), 1, N'', N'', 12)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (13, N'画图', 5, 3, 106, CAST(0xA33B0B00 AS Date), 1, N'画图', N'', 13)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (14, N'部门会议', 1, 6, 129, CAST(0xA33B0B00 AS Date), 1, N'', N'', 14)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (15, N'画图', 5, 5, 106, CAST(0xA33B0B00 AS Date), 1, N'画图', N'', 15)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (16, N'画图', 5, 6, 106, CAST(0xA33B0B00 AS Date), 1, N'画图', N'', 16)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (17, N'画图', 5, 7, 106, CAST(0xA33B0B00 AS Date), 1, N'画图', N'', 17)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (18, N'画图', 5, 8, 106, CAST(0xA33B0B00 AS Date), 1, N'画图', N'', 18)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (19, N'组内知识研讨', 1, 4, 8, CAST(0xA33B0B00 AS Date), 1, N'', N'', 19)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (20, N'高教一部客户参观', 1, 2, 87, CAST(0xA43B0B00 AS Date), 1, N'', N'', 20)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (21, N'高教一部客户参观', 1, 3, 87, CAST(0xA43B0B00 AS Date), 1, N'', N'', 21)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (22, N'普教专场培训', 1, 7, 17, CAST(0xA63B0B00 AS Date), 1, N'', N'', 22)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (23, N'普教专场培训', 1, 8, 17, CAST(0xA63B0B00 AS Date), 1, N'', N'', 23)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (24, N'客户来访', 1, 5, 121, CAST(0xA93B0B00 AS Date), 1, N'职教部客户来访', N'', 24)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (25, N'客户来访', 1, 6, 121, CAST(0xA93B0B00 AS Date), 1, N'职教部客户来访', N'', 25)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (26, N'客户来访', 1, 7, 121, CAST(0xA93B0B00 AS Date), 1, N'职教部客户来访', N'', 26)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (27, N'客户参观', 1, 5, 36, CAST(0xAA3B0B00 AS Date), 1, N'', N'', 27)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (28, N'客户参观', 1, 6, 36, CAST(0xAA3B0B00 AS Date), 1, N'', N'', 28)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (29, N'客户参观', 1, 7, 36, CAST(0xAA3B0B00 AS Date), 1, N'', N'', 29)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (30, N'客户参观', 1, 8, 36, CAST(0xAA3B0B00 AS Date), 1, N'', N'', 30)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (31, N'客户参观', 1, 9, 36, CAST(0xAA3B0B00 AS Date), 1, N'', N'', 31)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (32, N'客户参观', 1, 1, 36, CAST(0xAA3B0B00 AS Date), 1, N'', N'', 32)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (33, N'人事部新员工入职培训', 1, 5, 72, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 33)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (34, N'人事部新员工入职培训', 1, 6, 72, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 34)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (35, N'人事部新员工入职培训', 1, 7, 72, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 35)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (36, N'人事部新员工入职培训', 1, 8, 72, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 36)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (38, N'销售二部会议', 1, 1, 17, CAST(0xAB3B0B00 AS Date), 1, N'', N'', 38)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (39, N'销售二部培训会', 1, 5, 17, CAST(0xAB3B0B00 AS Date), 1, N'', N'', 39)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (40, N'销售二部培训会', 1, 6, 17, CAST(0xAB3B0B00 AS Date), 1, N'', N'', 40)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (41, N'销售二部培训会', 1, 7, 17, CAST(0xAB3B0B00 AS Date), 1, N'', N'', 41)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (43, N'启动会', 1, 8, 79, CAST(0xAC3B0B00 AS Date), 1, N'', N'', 43)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (44, N'组内ppt', 2, 5, 37, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 44)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (45, N'组内ppt', 2, 6, 37, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 45)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (46, N'组内ppt', 2, 7, 37, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 46)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (47, N'ppt', 5, 5, 37, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 47)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (48, N'ppt', 5, 6, 37, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 48)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (49, N'ppt', 5, 7, 37, CAST(0xAD3B0B00 AS Date), 1, N'', N'', 49)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (50, N'PPT比赛初赛', 1, 7, NULL, CAST(0xB23B0B00 AS Date), 1, N'', N'', 50)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (51, N'PPT比赛初赛', 1, 8, NULL, CAST(0xB23B0B00 AS Date), 1, N'', N'', 51)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (52, N'高教二部', 1, 5, 60, CAST(0xB13B0B00 AS Date), 1, N'上半年工作总结', N'', 52)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (53, N'高教二部', 1, 6, 60, CAST(0xB13B0B00 AS Date), 1, N'上半年工作总结', N'', 53)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (55, N'高教二部', 1, 7, 60, CAST(0xB13B0B00 AS Date), 1, N'上半年工作总结', N'', 55)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (56, N'高教二部', 1, 8, 60, CAST(0xB13B0B00 AS Date), 1, N'上半年工作总结', N'', 56)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (57, N'延庆客户参观', 1, 1, 67, CAST(0xB23B0B00 AS Date), 1, N'', N'', 57)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (58, N'内部培训', 6, 6, NULL, CAST(0xB23B0B00 AS Date), 1, N'两点到四点', N'', 58)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (59, N'资质评审', 5, 1, 118, CAST(0xB23B0B00 AS Date), 1, N'', N'', 59)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (60, N'资质评审', 5, 2, 118, CAST(0xB23B0B00 AS Date), 1, N'', N'', 60)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (61, N'展览公司汇报方案', 1, 1, NULL, CAST(0xB43B0B00 AS Date), 1, N'', N'', 61)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (62, N'展览公司汇报方案', 1, 2, NULL, CAST(0xB43B0B00 AS Date), 1, N'', N'', 62)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (63, N'展览公司汇报方案', 1, 3, NULL, CAST(0xB43B0B00 AS Date), 1, N'', N'', 63)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (64, N'人民检察院客户接待', 1, 5, NULL, CAST(0xB33B0B00 AS Date), 1, N'', N'', 64)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (65, N'人民检察院客户接待', 1, 6, NULL, CAST(0xB33B0B00 AS Date), 1, N'', N'', 65)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (66, N'PPT比赛初赛', 1, 9, NULL, CAST(0xB23B0B00 AS Date), 1, N'', N'', 66)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (67, N'华人售前培训', 1, 7, NULL, CAST(0xB73B0B00 AS Date), 1, N'', N'', 67)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (68, N'华人售前培训', 1, 8, NULL, CAST(0xB73B0B00 AS Date), 1, N'', N'', 68)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (69, N'研发部培训', 1, 5, 99, CAST(0xB73B0B00 AS Date), 1, N'', N'', 69)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (70, N'研发部培训', 1, 6, 99, CAST(0xB73B0B00 AS Date), 1, N'', N'', 70)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (71, N'部门周例会', 5, 6, NULL, CAST(0xB73B0B00 AS Date), 1, N'', N'', 71)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (72, N'设计公司开会', 1, 1, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 72)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (73, N'设计公司开会', 1, 2, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 73)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (74, N'集成商参观', 1, 2, NULL, CAST(0xB83B0B00 AS Date), 1, N'', N'', 74)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (75, N'启动会', 1, 6, 79, CAST(0xB83B0B00 AS Date), 1, N'', N'', 75)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (76, N'启动会', 1, 7, 79, CAST(0xB83B0B00 AS Date), 1, N'', N'', 76)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (77, N'人事部会议', 4, 3, 17, CAST(0xB83B0B00 AS Date), 1, N'', N'', 77)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (78, N'演讲比赛', 1, 5, 131, CAST(0xB83B0B00 AS Date), 1, N'', N'', 78)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (79, N'演讲比赛', 1, 4, 131, CAST(0xB83B0B00 AS Date), 1, N'', N'', 79)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (80, N'培训', 6, 6, NULL, CAST(0xB83B0B00 AS Date), 1, N'', N'', 80)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (81, N'华人销售部演讲比赛', 1, 5, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 81)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (82, N'华人销售部演讲比赛', 1, 6, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 82)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (83, N'华人销售部演讲比赛', 1, 7, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 83)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (84, N'华人销售部演讲比赛', 1, 8, 17, CAST(0xB83B0B00 AS Date), 1, N'', N'', 84)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (85, N'华人销售部演讲比赛', 1, 3, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 85)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (86, N'华人销售部演讲比赛', 1, 8, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 86)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (87, N'启动会', 4, 7, 79, CAST(0xB83B0B00 AS Date), 1, N'', N'', 87)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (89, N'总结汇报', 1, 5, 44, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 89)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (90, N'总结汇报', 1, 6, 44, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 90)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (91, N'高教二部演讲比赛', 5, 7, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 91)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (92, N'高教二部演讲比赛', 5, 8, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 92)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (93, N'高教二部演讲比赛', 5, 9, 17, CAST(0xB93B0B00 AS Date), 1, N'', N'', 93)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (96, N'销售二部与厂家的会议', 6, 1, 144, CAST(0xB93B0B00 AS Date), 1, N'销售二部与厂家的会议，预计到今天十点半左右结束。', N'', 96)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (97, N'交流会', 6, 8, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 97)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (116, N'集成商会议', 4, 1, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 116)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (117, N'集成商会议', 4, 3, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 117)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (118, N'部门会议', 4, 2, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 118)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (119, N'部门会议', 4, 2, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 119)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (120, N'部门会议', 4, 3, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 120)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (121, N'部门会议', 4, 5, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 121)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (122, N'部门会议', 4, 6, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 122)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (123, N'部门会议', 4, 7, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 123)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (124, N'部门会议', 4, 8, NULL, CAST(0xB93B0B00 AS Date), 1, N'', N'', 124)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (125, N'执行商务采购部', 1, 1, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 125)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (127, N'启动会', 4, 5, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 127)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (128, N'启动会', 4, 6, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 128)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (129, N'启动会', 4, 7, NULL, CAST(0xBA3B0B00 AS Date), 1, N'', N'', 129)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (131, N'部门会议', 1, 5, 129, CAST(0xBE3B0B00 AS Date), 1, N'', N'', 131)
GO
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (136, N'刘珺阳组部门会议', 5, 5, NULL, CAST(0xBE3B0B00 AS Date), 1, N'', N'', 136)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (137, N'刘珺阳组部门会议', 5, 6, NULL, CAST(0xBE3B0B00 AS Date), 1, N'', N'', 137)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (138, N'财务开会', 1, 1, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 138)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (139, N'财务开会', 1, 2, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 139)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (140, N'财务开会', 1, 3, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 140)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (141, N'财务开会', 1, 4, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 141)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (142, N'财务开会', 1, 5, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 142)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (143, N'财务开会', 1, 6, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 143)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (144, N'财务开会', 1, 7, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 144)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (145, N'财务开会', 1, 8, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 145)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (146, N'财务开会', 1, 9, 135, CAST(0xC03B0B00 AS Date), 1, N'', N'', 146)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (149, N'PPT练习', 6, 1, NULL, CAST(0xBF3B0B00 AS Date), 1, N'', N'', 149)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (150, N'PPT练习', 6, 6, NULL, CAST(0xBF3B0B00 AS Date), 1, N'', N'', 150)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (151, N'华录集团培训', 6, 1, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 151)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (152, N'华录集团培训', 6, 2, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 152)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (153, N'华录集团培训', 6, 3, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 153)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (154, N'华录集团培训', 6, 4, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 154)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (155, N'华录集团培训', 6, 5, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 155)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (156, N'华录集团培训', 6, 6, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 156)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (157, N'华录集团培训', 6, 7, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 157)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (158, N'华录集团培训', 6, 8, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 158)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (159, N'华录集团培训', 6, 9, 151, CAST(0xC03B0B00 AS Date), 1, N'', N'', 159)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (168, N'财务部开会', 5, 1, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 168)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (169, N'财务部开会', 5, 2, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 169)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (170, N'财务部开会', 5, 3, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 170)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (172, N'财务部开会', 5, 5, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 172)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (173, N'财务部开会', 5, 6, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 173)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (174, N'财务部开会', 5, 7, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 174)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (175, N'财务部开会', 5, 8, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 175)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (176, N'财务部开会', 5, 9, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 176)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (177, N'财务开会', 5, 4, 104, CAST(0xC03B0B00 AS Date), 1, N'', N'', 177)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (199, N'Ppt比赛', 1, 6, 48, CAST(0xC23B0B00 AS Date), 1, N'', N'', 199)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (200, N'Ppt比赛', 1, 7, 48, CAST(0xC23B0B00 AS Date), 1, N'', N'', 200)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (206, N'产品及方案交流', 1, 5, 31, CAST(0xC23B0B00 AS Date), 1, N'', N'', 206)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (208, N'产品及方案交流', 1, 4, 31, CAST(0xC23B0B00 AS Date), 1, N'', N'', 208)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (213, N'咨询', 5, 2, 118, CAST(0xC23B0B00 AS Date), 1, N'', N'', 213)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (214, N'启动会', 4, 5, 79, CAST(0xC23B0B00 AS Date), 1, N'', N'', 214)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (228, N'俎兴隆组会议', 6, 4, NULL, CAST(0xC23B0B00 AS Date), 1, N'', N'', 228)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (229, N'俎兴隆组会议', 6, 5, NULL, CAST(0xC23B0B00 AS Date), 1, N'', N'', 229)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (230, N'俎兴隆组会议', 6, 6, NULL, CAST(0xC23B0B00 AS Date), 1, N'', N'', 230)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (231, N'俎兴隆组会议', 6, 0, NULL, CAST(0xC23B0B00 AS Date), 1, N'', N'', 231)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (278, N'财务室PPT演讲', 1, 5, 118, CAST(0xC53B0B00 AS Date), 1, N'', N'', 278)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (281, N'回款信息沟通会', 1, 1, 47, CAST(0xC73B0B00 AS Date), 1, N'', N'', 281)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (282, N'回款信息沟通会', 1, 2, 47, CAST(0xC73B0B00 AS Date), 1, N'', N'', 282)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (283, N'部门会议', 1, 1, 121, CAST(0xC53B0B00 AS Date), 1, N'', N'', 283)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (284, N'部门会议', 1, 4, 121, CAST(0xC53B0B00 AS Date), 1, N'', N'', 284)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (285, N'部门会议', 1, 2, 121, CAST(0xC53B0B00 AS Date), 1, N'', N'', 285)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (286, N'部门会议', 1, 3, 121, CAST(0xC53B0B00 AS Date), 1, N'', N'', 286)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (287, N'PPT比赛', 1, 6, 36, CAST(0xC53B0B00 AS Date), 1, N'', N'', 287)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (288, N'PPT比赛', 1, 7, 36, CAST(0xC53B0B00 AS Date), 1, N'', N'', 288)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (289, N'PPT比赛', 1, 8, 36, CAST(0xC53B0B00 AS Date), 1, N'', N'', 289)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (318, N'圣邦执行商务采购组内', 1, 1, 47, CAST(0xC83B0B00 AS Date), 1, N'', N'', 318)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (319, N'圣邦执行商务采购组内', 1, 2, 47, CAST(0xC83B0B00 AS Date), 1, N'', N'', 319)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (320, N'圣邦执行商务采购组内', 1, 3, 47, CAST(0xC83B0B00 AS Date), 1, N'', N'', 320)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (321, N'华人财务组内', 1, 5, 47, CAST(0xC83B0B00 AS Date), 1, N'', N'', 321)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (322, N'华人财务组内', 1, 6, 47, CAST(0xC83B0B00 AS Date), 1, N'', N'', 322)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (591, N'项目信息收集', 1, 7, 99, CAST(0xC93B0B00 AS Date), 1, N'', N'', 326)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (592, N'项目信息收集', 1, 8, 99, CAST(0xC93B0B00 AS Date), 1, N'', N'', 326)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (598, N'财务', 5, 1, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (599, N'财务', 5, 2, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (600, N'财务', 5, 3, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (601, N'财务', 5, 4, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (602, N'财务', 5, 5, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (603, N'财务', 5, 6, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (604, N'财务', 5, 7, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (605, N'财务', 5, 8, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (606, N'财务', 5, 9, 135, CAST(0xC93B0B00 AS Date), 1, N'', N'', 327)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (607, N'财务', 5, 6, 135, CAST(0xC83B0B00 AS Date), 1, N'', N'', 328)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (608, N'财务', 5, 7, 135, CAST(0xC83B0B00 AS Date), 1, N'', N'', 328)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (609, N'财务', 5, 8, 135, CAST(0xC83B0B00 AS Date), 1, N'', N'', 328)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (610, N'财务', 5, 9, 135, CAST(0xC83B0B00 AS Date), 1, N'', N'', 328)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (627, N'内部PPT比赛', 5, 7, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 329)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (628, N'PP T内部比赛', 5, 8, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 330)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (629, N'接待济南客户', 1, 4, 162, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 331)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (630, N'接待济南客户', 1, 5, 162, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 331)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (631, N'接待济南客户', 1, 6, 162, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 331)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (632, N'组内会议', 4, 1, 164, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 332)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (633, N'组内会议', 4, 2, 164, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 332)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (639, N'财务部开会', 5, 1, 104, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 333)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (640, N'财务部开会', 5, 2, 104, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 333)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (641, N'财务部开会', 5, 3, 104, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 333)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (642, N'财务部开会', 5, 4, 104, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 333)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (643, N'财务部开会', 5, 5, 104, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 333)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (644, N'财务部开会', 5, 6, 104, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 333)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (683, N'中医坐诊', 4, 3, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 346)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (685, N'中医', 4, 5, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 348)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (687, N'中医', 4, 6, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 350)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (688, N'中医', 4, 7, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 351)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (689, N'中医', 4, 8, 17, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 352)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (690, N'中医', 4, 1, 17, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 353)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (694, N'中医', 4, 2, 17, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 355)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (695, N'中医', 4, 3, 17, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 356)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (696, N'中医', 4, 5, 17, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 357)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (697, N'中医', 4, 6, 17, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 358)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (698, N'中医', 4, 7, 17, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 359)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (699, N'中医', 4, 1, 17, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 360)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (700, N'中医', 4, 2, 17, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 361)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (701, N'中医', 4, 3, 17, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 362)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (702, N'中医', 4, 5, 17, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 363)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (703, N'中医', 4, 6, 17, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 364)
GO
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (705, N'中医', 4, 7, 17, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 365)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (712, N'部门培训', 1, 7, 119, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 370)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (713, N'部门PPT评比', 1, 1, 129, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 371)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (714, N'部门PPT评比', 1, 2, 129, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 371)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (715, N'部门PPT评比', 1, 3, 129, CAST(0xCD3B0B00 AS Date), 1, N'', N'', 371)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (716, N'财务', 6, 5, 135, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 372)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (717, N'财务', 6, 6, 135, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 372)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (718, N'财务', 6, 7, 135, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 372)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (719, N'财务', 6, 8, 135, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 372)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (720, N'部门培训', 1, 8, 119, CAST(0xCC3B0B00 AS Date), 1, N'', N'', 373)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (724, N'项目回款及实施沟通会', 1, 1, 47, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 374)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (725, N'项目回款及实施沟通会', 1, 2, 47, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 374)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (726, N'项目回款及实施沟通会', 1, 3, 47, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 374)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (729, N'系统集成二级', 1, 1, 118, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 376)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (730, N'系统集成二级', 1, 2, 118, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 376)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (731, N'系统集成二级', 1, 3, 118, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 376)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (732, N'系统集成二级', 1, 4, 118, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 376)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (733, N'系统集成二级', 1, 5, 118, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 376)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (734, N'集成二级评审', 2, 1, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (735, N'集成二级评审', 2, 2, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (736, N'集成二级评审', 2, 3, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (737, N'集成二级评审', 2, 4, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (738, N'集成二级评审', 2, 5, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (739, N'集成二级评审', 2, 6, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (740, N'集成二级评审', 2, 7, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (741, N'集成二级评审', 2, 8, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (742, N'集成二级评审', 2, 9, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 377)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (743, N'集成二级评审', 3, 1, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (744, N'集成二级评审', 3, 2, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (745, N'集成二级评审', 3, 3, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (746, N'集成二级评审', 3, 4, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (747, N'集成二级评审', 3, 5, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (748, N'集成二级评审', 3, 6, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (749, N'集成二级评审', 3, 7, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (750, N'集成二级评审', 3, 8, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (751, N'集成二级评审', 3, 9, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 378)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (752, N'集成二级评审', 1, 6, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 379)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (753, N'集成二级评审', 1, 7, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 379)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (754, N'集成二级评审', 1, 8, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 379)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (755, N'集成二级评审', 1, 9, 171, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 379)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (756, N'客户参观讲解ppt。', 1, 6, 152, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 380)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (759, N'财务', 5, 2, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (760, N'财务', 5, 3, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (761, N'财务', 5, 4, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (762, N'财务', 5, 5, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (763, N'财务', 5, 6, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (764, N'财务', 5, 7, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (765, N'财务', 5, 8, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (766, N'财务', 5, 9, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 381)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (767, N'厂家交流', 6, 5, 163, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 382)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (768, N'厂家交流', 6, 6, 163, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 382)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (784, N'研发PPT比赛', 6, 7, 173, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 386)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (785, N'研发PPT比赛', 6, 8, 173, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 386)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (786, N'研发PPT比赛', 6, 9, 173, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 386)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (787, N'评审', 1, 7, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 387)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (788, N'评审', 1, 8, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 387)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (789, N'评审', 1, 9, 135, CAST(0xCE3B0B00 AS Date), 1, N'', N'', 387)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (790, N'新人培训', 1, 6, 144, CAST(0xD03B0B00 AS Date), 1, N'', N'', 388)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (791, N'新人培训', 1, 7, 144, CAST(0xD03B0B00 AS Date), 1, N'', N'', 388)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (792, N'新人培训', 1, 8, 144, CAST(0xD03B0B00 AS Date), 1, N'', N'', 388)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (820, N'华人销售一部会议', 6, 7, 152, CAST(0xD03B0B00 AS Date), 1, N'', N'', 389)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (821, N'华人销售一部会议', 6, 8, 152, CAST(0xD03B0B00 AS Date), 1, N'', N'', 389)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (822, N'部门会议', 5, 1, 129, CAST(0xD03B0B00 AS Date), 1, N'', N'', 390)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (823, N'部门会议', 5, 2, 129, CAST(0xD03B0B00 AS Date), 1, N'', N'', 390)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (824, N'部门会议', 5, 3, 129, CAST(0xD03B0B00 AS Date), 1, N'', N'', 390)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (829, N'测试', 6, 8, 30, CAST(0xD23B0B00 AS Date), 1, N'', N'', 393)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (832, N'测试', 6, 3, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 395)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (833, N'测试', 6, 4, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 395)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (836, N'测试', 6, 6, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 396)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (837, N'测试', 5, 8, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 397)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (838, N'测试', 5, 6, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 398)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (839, N'测试', 5, 1, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 399)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (840, N'测试', 5, 3, 30, CAST(0xD13B0B00 AS Date), 1, N'', N'', 400)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (847, N'厂商培训', 5, 8, 119, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 403)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (848, N'厂商培训', 5, 9, 119, CAST(0xCF3B0B00 AS Date), 1, N'', N'', 404)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (905, N'发顺丰', 1, 4, 158, CAST(0xD03B0B00 AS Date), 1, N'', N'', 406)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (906, N'发顺丰', 1, 5, 158, CAST(0xD03B0B00 AS Date), 1, N'', N'', 406)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (909, N'小组会议总结', 5, 2, 176, CAST(0xD33B0B00 AS Date), 1, N'', N'', 408)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (910, N'小组会议总结', 5, 3, 176, CAST(0xD33B0B00 AS Date), 1, N'', N'', 408)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (911, N'小组会议总结', 5, 4, 176, CAST(0xD33B0B00 AS Date), 1, N'', N'', 408)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (912, N'产品部部门会', 4, 2, 99, CAST(0xD33B0B00 AS Date), 1, N'', N'', 409)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (916, N'部门会议', 2, 5, 44, CAST(0xD33B0B00 AS Date), 1, N'', N'', 411)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (917, N'部门会议', 2, 6, 44, CAST(0xD33B0B00 AS Date), 1, N'', N'', 411)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (919, N'客户参观', 1, 5, 53, CAST(0xD63B0B00 AS Date), 1, N'', N'', 413)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (920, N'客户参观', 1, 6, 53, CAST(0xD63B0B00 AS Date), 1, N'', N'', 413)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (921, N'客户参观', 1, 7, 53, CAST(0xD63B0B00 AS Date), 1, N'', N'', 413)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (922, N'客户参观', 1, 8, 53, CAST(0xD63B0B00 AS Date), 1, N'', N'', 413)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (923, N'部门会议', 5, 5, 176, CAST(0xD33B0B00 AS Date), 1, N'', N'', 414)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (924, N'部门会议', 5, 6, 176, CAST(0xD33B0B00 AS Date), 1, N'', N'', 414)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (925, N'部门会议', 5, 7, 176, CAST(0xD33B0B00 AS Date), 1, N'', N'', 414)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (926, N'厂家过来', 5, 8, 163, CAST(0xD33B0B00 AS Date), 1, N'', N'', 415)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (927, N'财务开会', 1, 1, 135, CAST(0xD43B0B00 AS Date), 1, N'', N'', 416)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (928, N'财务开会', 1, 2, 135, CAST(0xD43B0B00 AS Date), 1, N'', N'', 416)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (929, N'普教一部部门会议', 1, 7, 139, CAST(0xD43B0B00 AS Date), 1, N'', N'', 417)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (930, N'普教一部部门会议', 1, 8, 139, CAST(0xD43B0B00 AS Date), 1, N'', N'', 417)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (931, N'回款及实施沟通会', 1, 1, 47, CAST(0xD53B0B00 AS Date), 1, N'', N'', 418)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (932, N'回款及实施沟通会', 1, 2, 47, CAST(0xD53B0B00 AS Date), 1, N'', N'', 418)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (933, N'回款及实施沟通会', 1, 3, 47, CAST(0xD53B0B00 AS Date), 1, N'', N'', 418)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (934, N'公司参观考察', 1, 1, 91, CAST(0xD73B0B00 AS Date), 1, N'', N'', 419)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (935, N'公司参观考察', 1, 2, 91, CAST(0xD73B0B00 AS Date), 1, N'', N'', 419)
GO
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (936, N'公司参观考察', 1, 3, 91, CAST(0xD73B0B00 AS Date), 1, N'', N'', 419)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (939, N'投屏项目讨论', 1, 5, 123, CAST(0xD43B0B00 AS Date), 1, N'', N'', 420)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (940, N'投屏项目讨论', 1, 6, 123, CAST(0xD43B0B00 AS Date), 1, N'', N'', 420)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (941, N'投屏项目讨论会', 1, 5, 123, CAST(0xD53B0B00 AS Date), 1, N'', N'', 421)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (942, N'项目沟通会', 6, 6, 152, CAST(0xD53B0B00 AS Date), 1, N'', N'', 422)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (943, N'厂家交流', 6, 7, 163, CAST(0xD53B0B00 AS Date), 1, N'', N'', 423)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (944, N'厂商', 5, 2, 163, CAST(0xD63B0B00 AS Date), 1, N'', N'', 424)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (945, N'标书会', 1, 7, 69, CAST(0xD73B0B00 AS Date), 1, N'', N'', 425)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (946, N'标书会', 1, 8, 69, CAST(0xD73B0B00 AS Date), 1, N'', N'', 425)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (947, N'部门会议', 1, 5, 129, CAST(0xDA3B0B00 AS Date), 1, N'', N'', 426)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (948, N'部门例会', 1, 1, 99, CAST(0xDC3B0B00 AS Date), 1, N'', N'', 427)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (949, N'华科活动方案', 6, 1, 179, CAST(0xE03B0B00 AS Date), 1, N'', N'', 428)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (950, N'华科活动方案', 6, 2, 179, CAST(0xE03B0B00 AS Date), 1, N'', N'', 428)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (951, N'华科活动方案', 6, 3, 179, CAST(0xE03B0B00 AS Date), 1, N'', N'', 428)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (954, N'部门会议', 1, 8, 129, CAST(0xE13B0B00 AS Date), 1, N'', N'', 429)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (955, N'方案探讨', 5, 5, 179, CAST(0xE03B0B00 AS Date), 1, N'', N'', 430)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (956, N'人事部例会', 4, 5, 17, CAST(0xE03B0B00 AS Date), 1, N'', N'', 431)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (957, N'淳中科技培训', 1, 6, 90, CAST(0xE13B0B00 AS Date), 1, N'', N'', 432)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (958, N'淳中科技培训', 1, 7, 90, CAST(0xE13B0B00 AS Date), 1, N'', N'', 432)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (959, N'厂家培训', 5, 7, 29, CAST(0xE13B0B00 AS Date), 1, N'', N'', 433)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (960, N'厂家培训', 5, 8, 29, CAST(0xE13B0B00 AS Date), 1, N'', N'', 433)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (961, N'北方工业大学老师参观', 1, 2, 143, CAST(0xE23B0B00 AS Date), 1, N'', N'', 434)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (962, N'北方工业大学老师参观', 1, 3, 143, CAST(0xE23B0B00 AS Date), 1, N'', N'', 434)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (963, N'外包公司沟通', 4, 5, 170, CAST(0xE23B0B00 AS Date), 1, N'', N'', 435)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (964, N'外包公司沟通', 4, 6, 170, CAST(0xE23B0B00 AS Date), 1, N'', N'', 435)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (965, N'人事部例会', 5, 3, 17, CAST(0xE43B0B00 AS Date), 1, N'', N'', 436)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (966, N'研发二部开会要用', 4, 8, 144, CAST(0xE53B0B00 AS Date), 1, N'', N'', 437)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (967, N'正方厂家', 5, 1, 179, CAST(0xE53B0B00 AS Date), 1, N'', N'', 438)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (968, N'正方厂家', 5, 2, 179, CAST(0xE53B0B00 AS Date), 1, N'', N'', 438)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (969, N'研发部例会', 1, 2, 30, CAST(0xE53B0B00 AS Date), 1, N'', N'', 439)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (970, N'研发部例会', 1, 3, 30, CAST(0xE53B0B00 AS Date), 1, N'', N'', 439)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (971, N'销售一部小组会议', 5, 8, 165, CAST(0xE53B0B00 AS Date), 1, N'', N'', 440)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (972, N'回款及项目进度沟通会', 1, 1, 47, CAST(0xEA3B0B00 AS Date), 1, N'', N'', 441)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (973, N'回款及项目进度沟通会', 1, 2, 47, CAST(0xEA3B0B00 AS Date), 1, N'', N'', 441)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (974, N'回款及项目进度沟通会', 1, 3, 47, CAST(0xEA3B0B00 AS Date), 1, N'', N'', 441)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (975, N'部门会议', 5, 7, 175, CAST(0xE83B0B00 AS Date), 1, N'', N'', 442)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (976, N'部门会议', 5, 8, 175, CAST(0xE83B0B00 AS Date), 1, N'', N'', 442)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (977, N'智慧教室机房监控厂家陪训', 1, 7, 29, CAST(0xE83B0B00 AS Date), 1, N'', N'', 443)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (978, N'智慧教室机房监控厂家陪训', 1, 8, 29, CAST(0xE83B0B00 AS Date), 1, N'', N'', 443)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (979, N'人事部例会', 5, 5, 17, CAST(0xE93B0B00 AS Date), 1, N'', N'', 444)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (980, N'人事部例会', 5, 6, 17, CAST(0xE93B0B00 AS Date), 1, N'', N'', 445)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (981, N'成都展会产品讲解培训', 1, 9, 148, CAST(0xE93B0B00 AS Date), 1, N'', N'', 446)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (982, N'售前内部培训', 1, 6, 119, CAST(0xEA3B0B00 AS Date), 1, N'', N'', 447)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (983, N'售前内部培训', 1, 7, 119, CAST(0xEA3B0B00 AS Date), 1, N'', N'', 447)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (984, N'成都展会产品讲解培训', 1, 9, 148, CAST(0xEA3B0B00 AS Date), 1, N'', N'', 448)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (985, N'核对展会相关图纸', 1, 7, 150, CAST(0xEB3B0B00 AS Date), 1, N'', N'', 449)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (986, N'组内培训', 1, 5, 164, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 450)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (987, N'组内培训', 1, 6, 164, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 450)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (988, N'新员工培训', 1, 7, 17, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 451)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (989, N'新员工培训', 1, 8, 17, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 452)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (990, N'销售三部组内培训', 6, 5, 144, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 453)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (991, N'销售三部组内培训', 6, 6, 144, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 453)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (992, N'普教二部组内会议', 5, 5, 35, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 454)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (993, N'普教二部组内会议', 5, 6, 35, CAST(0xEC3B0B00 AS Date), 1, N'', N'', 455)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (998, N'部门PPT总结', 1, 5, 44, CAST(0xF43B0B00 AS Date), 1, N'', N'', 457)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (999, N'部门PPT总结', 1, 6, 44, CAST(0xF43B0B00 AS Date), 1, N'', N'', 457)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1000, N'人事部例会', 4, 5, 17, CAST(0xF43B0B00 AS Date), 1, N'', N'', 458)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1001, N'部门例会', 1, 5, 99, CAST(0xF53B0B00 AS Date), 1, N'', N'', 459)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1002, N'地大项目启动会', 1, 5, 142, CAST(0xF63B0B00 AS Date), 1, N'', N'', 460)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1003, N'地大项目启动会', 1, 6, 142, CAST(0xF63B0B00 AS Date), 1, N'', N'', 460)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1006, N'需求讲解会', 6, 3, 99, CAST(0xF63B0B00 AS Date), 1, N'', N'', 461)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1007, N'组内方案培训会', 1, 8, 164, CAST(0xF73B0B00 AS Date), 1, N'', N'', 462)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1008, N'组内方案培训会', 1, 9, 164, CAST(0xF73B0B00 AS Date), 1, N'', N'', 462)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1009, N'回款和项目沟通会', 1, 1, 47, CAST(0xF83B0B00 AS Date), 1, N'', N'', 463)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1010, N'回款和项目沟通会', 1, 2, 47, CAST(0xF83B0B00 AS Date), 1, N'', N'', 463)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1011, N'回款和项目沟通会', 1, 3, 47, CAST(0xF83B0B00 AS Date), 1, N'', N'', 463)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1012, N'培训', 1, 5, 118, CAST(0xF73B0B00 AS Date), 1, N'', N'', 464)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1013, N'培训', 1, 6, 118, CAST(0xF73B0B00 AS Date), 1, N'', N'', 464)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1014, N'培训', 1, 7, 118, CAST(0xF73B0B00 AS Date), 1, N'', N'', 464)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1015, N'产品测试', 2, 1, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1016, N'产品测试', 2, 2, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1017, N'产品测试', 2, 3, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1018, N'产品测试', 2, 4, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1019, N'产品测试', 2, 5, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1020, N'产品测试', 2, 6, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1021, N'产品测试', 2, 7, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1022, N'产品测试', 2, 8, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1023, N'产品测试', 2, 9, 121, CAST(0xF83B0B00 AS Date), 1, N'', N'', 465)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1024, N'产品测试', 2, 1, 121, CAST(0xF93B0B00 AS Date), 1, N'', N'', 466)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1025, N'产品测试', 2, 2, 121, CAST(0xF93B0B00 AS Date), 1, N'', N'', 466)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1026, N'产品测试', 2, 3, 121, CAST(0xF93B0B00 AS Date), 1, N'', N'', 466)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1027, N'会议', 5, 6, 73, CAST(0xF83B0B00 AS Date), 1, N'', N'', 467)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1028, N'项目推进会', 1, 7, 99, CAST(0xF83B0B00 AS Date), 1, N'', N'', 468)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1029, N'项目推进会', 1, 8, 99, CAST(0xF83B0B00 AS Date), 1, N'', N'', 468)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1030, N'产品交互优化会', 1, 1, 99, CAST(0xF93B0B00 AS Date), 1, N'', N'', 469)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1031, N'产品交互优化会', 1, 2, 99, CAST(0xF93B0B00 AS Date), 1, N'', N'', 469)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1041, N'长城', 1, 7, 158, CAST(0xFB3B0B00 AS Date), 1, N'', N'', 470)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1042, N'长城', 1, 8, 158, CAST(0xFB3B0B00 AS Date), 1, N'', N'', 470)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1043, N'长城', 1, 9, 158, CAST(0xFB3B0B00 AS Date), 1, N'', N'', 470)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1044, N'销售培训', 1, 8, 17, CAST(0xFA3B0B00 AS Date), 1, N'', N'', 471)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1045, N'销售培训', 1, 9, 17, CAST(0xFA3B0B00 AS Date), 1, N'', N'', 472)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1046, N'新人培训', 1, 1, 150, CAST(0xFA3B0B00 AS Date), 1, N'', N'', 473)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1047, N'产品例会', 1, 6, 99, CAST(0xFA3B0B00 AS Date), 1, N'', N'', 474)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1048, N'产品例会', 1, 7, 99, CAST(0xFA3B0B00 AS Date), 1, N'', N'', 475)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1849, N'项目沟通会', 1, 5, 91, CAST(0xFD3B0B00 AS Date), 1, N'', N'', 476)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1850, N'项目沟通会', 1, 6, 91, CAST(0xFD3B0B00 AS Date), 1, N'', N'', 477)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1851, N'人事部会议', 4, 6, 144, CAST(0xFD3B0B00 AS Date), 1, N'', N'', 478)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1852, N'人事部会议', 4, 7, 144, CAST(0xFD3B0B00 AS Date), 1, N'', N'', 478)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1853, N'产品中心PPT演讲培训', 1, 7, 182, CAST(0xFF3B0B00 AS Date), 1, N'', N'', 479)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1854, N'产品中心PPT演讲培训', 1, 8, 182, CAST(0xFF3B0B00 AS Date), 1, N'', N'', 479)
GO
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1855, N'丰台东高地四所小学参观', 1, 6, 122, CAST(0x013C0B00 AS Date), 1, N'', N'', 480)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1856, N'丰台东高地四所小学参观', 1, 7, 122, CAST(0x013C0B00 AS Date), 1, N'', N'', 480)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1859, N'产品会议', 1, 6, 30, CAST(0x003C0B00 AS Date), 1, N'', N'', 481)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1860, N'产品会议', 1, 7, 30, CAST(0x003C0B00 AS Date), 1, N'', N'', 481)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1861, N'财务部相关资质审核', 6, 1, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1862, N'财务部相关资质审核', 6, 2, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1863, N'财务部相关资质审核', 6, 3, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1864, N'财务部相关资质审核', 6, 4, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1865, N'财务部相关资质审核', 6, 5, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1866, N'财务部相关资质审核', 6, 6, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
INSERT [dbo].[MeetingBooked] ([id], [MeetingTitle], [MeetingID], [TimeSectionID], [UserInfoID], [BookedDate], [Status], [Remark], [BookedRemark], [bs]) VALUES (1867, N'财务部相关资质审核', 6, 7, 184, CAST(0x013C0B00 AS Date), 1, N'', N'', 482)
SET IDENTITY_INSERT [dbo].[MeetingBooked] OFF
SET IDENTITY_INSERT [dbo].[MenuInfo] ON 

INSERT [dbo].[MenuInfo] ([Id], [Name], [Pid], [Url], [Description], [isMeu], [isShow], [iconClass], [sortId]) VALUES (1, N'会议室管理', 0, N'', NULL, 1, 3, N'icon-teaching', 0)
INSERT [dbo].[MenuInfo] ([Id], [Name], [Pid], [Url], [Description], [isMeu], [isShow], [iconClass], [sortId]) VALUES (2, N'会议室管理', 1, N'/Meeting/Meeting.aspx', NULL, 1, 3, NULL, 0)
INSERT [dbo].[MenuInfo] ([Id], [Name], [Pid], [Url], [Description], [isMeu], [isShow], [iconClass], [sortId]) VALUES (3, N'时间段管理', 1, N'/TimeSection/TimeSection.aspx', NULL, 1, 3, NULL, 0)
INSERT [dbo].[MenuInfo] ([Id], [Name], [Pid], [Url], [Description], [isMeu], [isShow], [iconClass], [sortId]) VALUES (4, N'人员信息管理', 0, N'', NULL, 1, 3, N'icon-teaching', 0)
INSERT [dbo].[MenuInfo] ([Id], [Name], [Pid], [Url], [Description], [isMeu], [isShow], [iconClass], [sortId]) VALUES (5, N'人员信息', 4, N'/UserInfo/UserInfo.aspx', NULL, 1, 3, NULL, 0)
SET IDENTITY_INSERT [dbo].[MenuInfo] OFF
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([id], [RoleName]) VALUES (1, N'会议室管理员')
INSERT [dbo].[Role] ([id], [RoleName]) VALUES (2, N'普通用户')
SET IDENTITY_INSERT [dbo].[Role] OFF
SET IDENTITY_INSERT [dbo].[RoleOfMenu] ON 

INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (1, 1, 1)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (2, 1, 2)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (3, 1, 3)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (4, 1, 4)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (5, 1, 5)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (6, 2, 1)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (7, 2, 2)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (8, 2, 3)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (9, 2, 4)
INSERT [dbo].[RoleOfMenu] ([Id], [RoleId], [MenuId]) VALUES (10, 2, 5)
SET IDENTITY_INSERT [dbo].[RoleOfMenu] OFF
SET IDENTITY_INSERT [dbo].[TimeSection] ON 

INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (1, N'09:00-10:00', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (2, N'10:00-11:00', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (3, N'11:00-12:00', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (4, N'12:00-13:30', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (5, N'13:30-14:30', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (6, N'14:30-15:30', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (7, N'15:30-16:30', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (8, N'16:30-17:30', NULL, NULL, 0)
INSERT [dbo].[TimeSection] ([id], [TimeSectionName], [CreateTime], [Creator], [IsDelete]) VALUES (9, N'17:30-24:00', NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[TimeSection] OFF
SET IDENTITY_INSERT [dbo].[UserInfo] ON 

INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (1, N'王学伟', NULL, N'18610053056', 2, N'96e79218965eb72c92a549dd5a330112', N'18610053056', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (2, N'杨国庆', NULL, N'15801522074', 2, N'96e79218965eb72c92a549dd5a330112', N'15801522074', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (3, N'范永清', NULL, N'13718836866', 2, N'96e79218965eb72c92a549dd5a330112', N'13718836866', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (4, N'葛春雨', NULL, N'17701335315', 2, N'96e79218965eb72c92a549dd5a330112', N'17701335315', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (5, N'李红燕', NULL, N'18201408093', 2, N'96e79218965eb72c92a549dd5a330112', N'18201408093', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (6, N'李晓玮', NULL, N'13552203096', 2, N'96e79218965eb72c92a549dd5a330112', N'13552203096', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (7, N'郭阳', NULL, N'18831691855', 2, N'96e79218965eb72c92a549dd5a330112', N'18831691855', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (8, N'王彦召', NULL, N'15210266003', 2, N'96e79218965eb72c92a549dd5a330112', N'15210266003', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (9, N'李燕飞', NULL, N'15811485562', 2, N'96e79218965eb72c92a549dd5a330112', N'15811485562', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (10, N'王振洪', NULL, N'13910408075', 2, N'96e79218965eb72c92a549dd5a330112', N'13910408075', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (11, N'翟志峰', NULL, N'13910823068', 2, N'96e79218965eb72c92a549dd5a330112', N'13910823068', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (12, N'宫天航', NULL, N'15910837327', 2, N'96e79218965eb72c92a549dd5a330112', N'15910837327', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (13, N'王超', NULL, N'13811903007', 2, N'96e79218965eb72c92a549dd5a330112', N'13811903007', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (14, N'赵晶晶', NULL, N'13581946511', 2, N'96e79218965eb72c92a549dd5a330112', N'13581946511', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (15, N'张海霞', NULL, N'18600806510', 2, N'96e79218965eb72c92a549dd5a330112', N'18600806510', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (16, N'袁林', NULL, N'18001263929', 2, N'96e79218965eb72c92a549dd5a330112', N'18001263929', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (17, N'姜玲娜', NULL, N'13810250811', 1, N'96e79218965eb72c92a549dd5a330112', N'13810250811', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (19, N'陈曹振', NULL, N'15620990709', 2, N'96e79218965eb72c92a549dd5a330112', N'15620990709', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (20, N'吕泽', NULL, N'18618351427', 2, N'96e79218965eb72c92a549dd5a330112', N'18618351427', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (21, N'邢亮', NULL, N'18710297897', 2, N'96e79218965eb72c92a549dd5a330112', N'18710297897', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (22, N'李少华', NULL, N'18511690475', 2, N'96e79218965eb72c92a549dd5a330112', N'18511690475', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (23, N'刘文超', NULL, N'13911343470', 2, N'96e79218965eb72c92a549dd5a330112', N'13911343470', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (24, N'王欢', NULL, N'13810657316', 2, N'96e79218965eb72c92a549dd5a330112', N'13810657316', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (25, N'张保进', NULL, N'18612054861', 2, N'96e79218965eb72c92a549dd5a330112', N'18612054861', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (26, N'刘文远', NULL, N'13811166003', 2, N'96e79218965eb72c92a549dd5a330112', N'13811166003', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (27, N'郑新磊', NULL, N'18618405890', 2, N'96e79218965eb72c92a549dd5a330112', N'18618405890', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (28, N'郭晨晓', NULL, N'18001208177', 2, N'96e79218965eb72c92a549dd5a330112', N'18001208177', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (29, N'赵鑫', NULL, N'18518129496', 2, N'96e79218965eb72c92a549dd5a330112', N'18518129496', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (30, N'刘云诚', NULL, N'18612859600', 2, N'96e79218965eb72c92a549dd5a330112', N'18612859600', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (31, N'段红宇', NULL, N'13311458525', 2, N'96e79218965eb72c92a549dd5a330112', N'13311458525', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (32, N'周艺虹', NULL, N'18311036126', 2, N'96e79218965eb72c92a549dd5a330112', N'18311036126', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (33, N'谢章峰', NULL, N'13263167067', 2, N'96e79218965eb72c92a549dd5a330112', N'13263167067', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (34, N'李跃龙', NULL, N'15811084516', 2, N'96e79218965eb72c92a549dd5a330112', N'15811084516', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (35, N'高建军', NULL, N'13381492345', 2, N'96e79218965eb72c92a549dd5a330112', N'13381492345', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (36, N'王岩岩', NULL, N'13661030700', 2, N'96e79218965eb72c92a549dd5a330112', N'13661030700', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (37, N'龚宝冬', NULL, N'13911552152', 2, N'96e79218965eb72c92a549dd5a330112', N'13911552152', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (38, N'鲁伟超', NULL, N'18513065329', 2, N'96e79218965eb72c92a549dd5a330112', N'18513065329', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (39, N'张东明', NULL, N'18701062706', 2, N'96e79218965eb72c92a549dd5a330112', N'18701062706', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (40, N'郭新营', NULL, N'17710832007', 2, N'96e79218965eb72c92a549dd5a330112', N'17710832007', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (41, N'陈立影', NULL, N'13522954494', 2, N'96e79218965eb72c92a549dd5a330112', N'13522954494', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (42, N'梁红宇', NULL, N'13910752977', 2, N'96e79218965eb72c92a549dd5a330112', N'13910752977', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (43, N'唐宾阁', NULL, N'15303363783', 2, N'96e79218965eb72c92a549dd5a330112', N'15303363783', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (44, N'王义', NULL, N'15911050066', 2, N'96e79218965eb72c92a549dd5a330112', N'15911050066', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (45, N'车懿达', NULL, N'13552210035', 2, N'96e79218965eb72c92a549dd5a330112', N'13552210035', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (46, N'康健', NULL, N'13911954296', 2, N'96e79218965eb72c92a549dd5a330112', N'13911954296', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (47, N'尹志宇', NULL, N'13811902462', 2, N'96e79218965eb72c92a549dd5a330112', N'13811902462', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (48, N'刘志强', NULL, N'13366782330', 2, N'96e79218965eb72c92a549dd5a330112', N'13366782330', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (49, N'高亮', NULL, N'18910233865', 2, N'96e79218965eb72c92a549dd5a330112', N'18910233865', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (50, N'王飞', NULL, N'18810982354', 2, N'96e79218965eb72c92a549dd5a330112', N'18810982354', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (51, N'李慧龙', NULL, N'13810265457', 2, N'96e79218965eb72c92a549dd5a330112', N'13810265457', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (52, N'李明远', NULL, N'15210411320', 2, N'96e79218965eb72c92a549dd5a330112', N'15210411320', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (53, N'孙思雨', NULL, N'13717752021', 2, N'96e79218965eb72c92a549dd5a330112', N'13717752021', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (54, N'苗路', NULL, N'15188624640', 2, N'96e79218965eb72c92a549dd5a330112', N'15188624640', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (55, N'徐亦先', NULL, N'17000108248', 2, N'96e79218965eb72c92a549dd5a330112', N'17000108248', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (56, N'王慧', NULL, N'13126959755', 2, N'96e79218965eb72c92a549dd5a330112', N'13126959755', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (57, N'卢珊珊', NULL, N'13621382842', 2, N'96e79218965eb72c92a549dd5a330112', N'13621382842', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (59, N'张光翊', NULL, N'13126914999', 2, N'96e79218965eb72c92a549dd5a330112', N'13126914999', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (60, N'彭子进', NULL, N'13264253088', 2, N'96e79218965eb72c92a549dd5a330112', N'13264253088', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (61, N'吴向南', NULL, N'13651205208', 2, N'96e79218965eb72c92a549dd5a330112', N'13651205208', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (62, N'张远欣', NULL, N'18513175308', 2, N'96e79218965eb72c92a549dd5a330112', N'18513175308', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (63, N'亢宁宁', NULL, N'13683070945', 2, N'96e79218965eb72c92a549dd5a330112', N'13683070945', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (64, N'左瀚雄', NULL, N'13241033501', 2, N'96e79218965eb72c92a549dd5a330112', N'13241033501', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (65, N'邸进才', NULL, N'13522837301', 2, N'96e79218965eb72c92a549dd5a330112', N'13522837301', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (66, N'李贵宾', NULL, N'13220185555', 2, N'96e79218965eb72c92a549dd5a330112', N'13220185555', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (67, N'姜超', NULL, N'13521156987', 2, N'96e79218965eb72c92a549dd5a330112', N'13521156987', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (68, N'罗秋香', NULL, N'18811337493', 2, N'96e79218965eb72c92a549dd5a330112', N'18811337493', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (69, N'毕云龙', NULL, N'18510238098', 2, N'96e79218965eb72c92a549dd5a330112', N'18510238098', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (70, N'王延峰', NULL, N'15801250063', 2, N'96e79218965eb72c92a549dd5a330112', N'15801250063', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (71, N'郭勇', NULL, N'18600493906', 2, N'96e79218965eb72c92a549dd5a330112', N'18600493906', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (72, N'刘艳平', NULL, N'15538971332', 2, N'96e79218965eb72c92a549dd5a330112', N'15538971332', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (73, N'杜鑫', NULL, N'13146762500', 2, N'96e79218965eb72c92a549dd5a330112', N'13146762500', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (74, N'陈亚果', NULL, N'13552990702', 2, N'96e79218965eb72c92a549dd5a330112', N'13552990702', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (75, N'史向飞', NULL, N'18600638558', 2, N'96e79218965eb72c92a549dd5a330112', N'18600638558', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (76, N'常金硕', NULL, N'15232339717', 2, N'96e79218965eb72c92a549dd5a330112', N'15232339717', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (77, N'韩大伟', NULL, N'15210632194', 2, N'96e79218965eb72c92a549dd5a330112', N'15210632194', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (78, N'赵明超', NULL, N'13811055964', 2, N'96e79218965eb72c92a549dd5a330112', N'13811055964', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (79, N'王海玉', NULL, N'15811573776', 2, N'96e79218965eb72c92a549dd5a330112', N'15811573776', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (80, N'张磊', NULL, N'18201575059', 2, N'96e79218965eb72c92a549dd5a330112', N'18201575059', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (81, N'苟华琼', NULL, N'18202873893', 2, N'96e79218965eb72c92a549dd5a330112', N'18202873893', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (82, N'刘峻嵩', NULL, N'13901006876', 2, N'96e79218965eb72c92a549dd5a330112', N'13901006876', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (83, N'王英锐', NULL, N'18611746247', 2, N'96e79218965eb72c92a549dd5a330112', N'18611746247', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (84, N'孙企阳', NULL, N'15810507255', 2, N'96e79218965eb72c92a549dd5a330112', N'15810507255', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (85, N'冯宇', NULL, N'18201382237', 2, N'96e79218965eb72c92a549dd5a330112', N'18201382237', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (86, N'邵继贵', NULL, N'13611155761', 2, N'96e79218965eb72c92a549dd5a330112', N'13611155761', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (87, N'丁晓宁', NULL, N'18810880688', 2, N'96e79218965eb72c92a549dd5a330112', N'18810880688', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (88, N'李洪峰', NULL, N'13910143705', 2, N'96e79218965eb72c92a549dd5a330112', N'13910143705', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (89, N'刘霞', NULL, N'18911827965', 2, N'96e79218965eb72c92a549dd5a330112', N'18911827965', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (90, N'孟仁意', NULL, N'18515201143', 2, N'96e79218965eb72c92a549dd5a330112', N'18515201143', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (91, N'卞玉娜', NULL, N'13716976697', 2, N'96e79218965eb72c92a549dd5a330112', N'13716976697', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (92, N'曾凡月', NULL, N'15110076995', 2, N'96e79218965eb72c92a549dd5a330112', N'15110076995', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (93, N'唐灵云', NULL, N'13260154382', 2, N'96e79218965eb72c92a549dd5a330112', N'13260154382', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (94, N'李春雨', NULL, N'18010225272', 2, N'96e79218965eb72c92a549dd5a330112', N'18010225272', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (95, N'丁红梅', NULL, N'13520789316', 2, N'96e79218965eb72c92a549dd5a330112', N'13520789316', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (96, N'刘丽华', NULL, N'18254157367', 2, N'96e79218965eb72c92a549dd5a330112', N'18254157367', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (97, N'赵灵可', NULL, N'15246039888', 2, N'96e79218965eb72c92a549dd5a330112', N'15246039888', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (98, N'冯培梦', NULL, N'18601937776', 2, N'96e79218965eb72c92a549dd5a330112', N'18601937776', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (99, N'黄泳绮', NULL, N'18301121788', 1, N'96e79218965eb72c92a549dd5a330112', N'18301121788', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (100, N'孙延卿', NULL, N'13240920800', 2, N'96e79218965eb72c92a549dd5a330112', N'13240920800', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (101, N'贺文龙', NULL, N'17701332367', 2, N'96e79218965eb72c92a549dd5a330112', N'17701332367', 0)
GO
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (102, N'张恒远', NULL, N'18610308120', 2, N'96e79218965eb72c92a549dd5a330112', N'18610308120', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (103, N'尤永林', NULL, N'13439275299', 2, N'96e79218965eb72c92a549dd5a330112', N'13439275299', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (104, N'赵文琪', NULL, N'13717670821', 2, N'96e79218965eb72c92a549dd5a330112', N'13717670821', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (105, N'孙立路', NULL, N'18410296855', 2, N'96e79218965eb72c92a549dd5a330112', N'18410296855', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (106, N'张丽娜', NULL, N'13641314870', 2, N'96e79218965eb72c92a549dd5a330112', N'13641314870', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (107, N'刘文杰', NULL, N'18618110658', 2, N'96e79218965eb72c92a549dd5a330112', N'18618110658', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (108, N'刘佳辉', NULL, N'18301173679', 2, N'96e79218965eb72c92a549dd5a330112', N'18301173679', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (109, N'张健', NULL, N'18601342013', 2, N'96e79218965eb72c92a549dd5a330112', N'18601342013', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (110, N'常海洋', NULL, N'15910451523', 2, N'96e79218965eb72c92a549dd5a330112', N'15910451523', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (111, N'刘磊', NULL, N'15010931986', 2, N'96e79218965eb72c92a549dd5a330112', N'15010931986', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (112, N'閤红元', NULL, N'13693603868', 2, N'96e79218965eb72c92a549dd5a330112', N'13693603868', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (113, N'张鑫', NULL, N'13681172797', 2, N'96e79218965eb72c92a549dd5a330112', N'13681172797', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (114, N'崔贺', NULL, N'13691399636', 2, N'96e79218965eb72c92a549dd5a330112', N'13691399636', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (115, N'万振宁', NULL, N'15801262285', 2, N'96e79218965eb72c92a549dd5a330112', N'15801262285', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (116, N'陈超', NULL, N'15801623086', 2, N'96e79218965eb72c92a549dd5a330112', N'15801623086', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (117, N'薛国华', NULL, N'18304760526', 2, N'96e79218965eb72c92a549dd5a330112', N'18304760526', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (118, N'曲乐扬', NULL, N'13661168560', 2, N'96e79218965eb72c92a549dd5a330112', N'13661168560', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (119, N'赵鹏', NULL, N'15811288825', 2, N'96e79218965eb72c92a549dd5a330112', N'15811288825', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (120, N'郭富', NULL, N'13311255189', 2, N'96e79218965eb72c92a549dd5a330112', N'13311255189', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (121, N'范磊磊', NULL, N'13910600595', 2, N'96e79218965eb72c92a549dd5a330112', N'13910600595', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (122, N'张萍萍', NULL, N'15010971918', 2, N'96e79218965eb72c92a549dd5a330112', N'15010971918', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (123, N'关业龙', NULL, N'13031190350', 2, N'96e79218965eb72c92a549dd5a330112', N'13031190350', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (124, N'刘喆', NULL, N'18510072844', 2, N'96e79218965eb72c92a549dd5a330112', N'18510072844', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (125, N'刘建会', NULL, N'18600918359', 2, N'96e79218965eb72c92a549dd5a330112', N'18600918359', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (126, N'李亚维', NULL, N'18810608803', 2, N'96e79218965eb72c92a549dd5a330112', N'18810608803', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (127, N'陈东革', NULL, N'15811301949', 2, N'96e79218965eb72c92a549dd5a330112', N'15811301949', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (128, N'胡永娣', NULL, N'13581707732', 2, N'96e79218965eb72c92a549dd5a330112', N'13581707732', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (129, N'张功全', NULL, N'13911665621', 2, N'96e79218965eb72c92a549dd5a330112', N'13911665621', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (130, N'普教一部-于晓龙', NULL, N'13810521216', 2, N'96e79218965eb72c92a549dd5a330112', N'13810521216', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (131, N'郭鹏超', NULL, N'18910411145', 2, N'96e79218965eb72c92a549dd5a330112', N'18910411145', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (132, N'林玉瑶', NULL, N'13716752331', 2, N'96e79218965eb72c92a549dd5a330112', N'13716752331', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (133, N'杨鹤', NULL, N'13141258680', 2, N'96e79218965eb72c92a549dd5a330112', N'13141258680', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (134, N'姜皓天', NULL, N'18301495386', 2, N'96e79218965eb72c92a549dd5a330112', N'18301495386', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (135, N'张越', NULL, N'13811692841', 2, N'96e79218965eb72c92a549dd5a330112', N'13811692841', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (136, N'阚贵春', NULL, N'15948055687', 2, N'96e79218965eb72c92a549dd5a330112', N'15948055687', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (137, N'孙娜', NULL, N'18210640076', 2, N'96e79218965eb72c92a549dd5a330112', N'18210640076', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (138, N'白俊', NULL, N'13381202724', 2, N'96e79218965eb72c92a549dd5a330112', N'13381202724', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (139, N'张倩倩', NULL, N'18511324214', 2, N'96e79218965eb72c92a549dd5a330112', N'18511324214', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (140, N'刘坤', NULL, N'13611221137', 2, N'96e79218965eb72c92a549dd5a330112', N'13611221137', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (141, N'孙茜', NULL, N'15801468934', 2, N'96e79218965eb72c92a549dd5a330112', N'15801468934', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (142, N'包磊', NULL, N'18310713235', 2, N'96e79218965eb72c92a549dd5a330112', N'18310713235', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (143, N'张雷鸣', NULL, N'18600407925', 2, N'96e79218965eb72c92a549dd5a330112', N'18600407925', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (144, N'庞卫鹏', NULL, N'15512124576', 2, N'96e79218965eb72c92a549dd5a330112', N'15512124576', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (145, N'李伟杰', NULL, N'18610661481', 2, N'96e79218965eb72c92a549dd5a330112', N'18610661481', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (146, N'周金亮', NULL, N'13436888675', 2, N'96e79218965eb72c92a549dd5a330112', N'13436888675', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (147, N'韩枭男', NULL, N'15910665052', 2, N'96e79218965eb72c92a549dd5a330112', N'15910665052', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (148, N'刘汉宇', NULL, N'15524678924', 2, N'96e79218965eb72c92a549dd5a330112', N'15524678924', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (149, N'陈若宁', NULL, N'18519337723', 2, N'96e79218965eb72c92a549dd5a330112', N'18519337723', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (150, N'沈忱', NULL, N'18500315036', 2, N'96e79218965eb72c92a549dd5a330112', N'18500315036', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (151, N'刘珺阳', NULL, N'13520034515', 2, N'96e79218965eb72c92a549dd5a330112', N'13520034515', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (152, N'王江彬', NULL, N'18811031804', 2, N'96e79218965eb72c92a549dd5a330112', N'18811031804', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (153, N'冯立', NULL, N'15001118932', 2, N'96e79218965eb72c92a549dd5a330112', N'15001118932', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (154, N'徐剑魁', NULL, N'15801399414', 2, N'96e79218965eb72c92a549dd5a330112', N'15801399414', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (158, N'刘泽', N'', N'13716753217', 2, N'96e79218965eb72c92a549dd5a330112', N'13716753217', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (159, N'谭敏', N'', N'18390868098', 2, N'96e79218965eb72c92a549dd5a330112', N'18390868098', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (160, N'李立胜', N'', N'18813154168', 2, N'96e79218965eb72c92a549dd5a330112', N'18813154168', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (161, N'马延昭', N'', N'18910898238', 2, N'96e79218965eb72c92a549dd5a330112', N'18910898238', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (162, N'唐金玉', N'', N'13651197397', 2, N'96e79218965eb72c92a549dd5a330112', N'13651197397', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (163, N'卢文凯', N'', N'13141212302', 2, N'96e79218965eb72c92a549dd5a330112', N'13141212302', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (164, N'魏鑫', N'', N'18701643893', 2, N'96e79218965eb72c92a549dd5a330112', N'18701643893', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (165, N'曾浩然', N'', N'18514462040', 2, N'96e79218965eb72c92a549dd5a330112', N'18514462040', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (166, N'王金成', N'', N'13161735298', 2, N'96e79218965eb72c92a549dd5a330112', N'13161735298', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (167, N'程鹏', N'', N'15122276284', 2, N'96e79218965eb72c92a549dd5a330112', N'15122276284', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (168, N'袁飞', N'', N'13811938146', 2, N'96e79218965eb72c92a549dd5a330112', N'13811938146', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (169, N'秋香', N'', N'18811337493', 2, N'96e79218965eb72c92a549dd5a330112', N'18811337493', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (170, N'司晓林', N'', N'13121603883', 2, N'96e79218965eb72c92a549dd5a330112', N'13121603883', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (171, N'龙志妹', N'', N'13311599705', 2, N'96e79218965eb72c92a549dd5a330112', N'13311599705', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (172, N'迟海亮', N'', N'18610716612', 2, N'96e79218965eb72c92a549dd5a330112', N'18610716612', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (173, N'李荣明', N'', N'13811660181', 2, N'96e79218965eb72c92a549dd5a330112', N'13811660181', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (174, N'永娣', N'', N'13581707732', 2, N'96e79218965eb72c92a549dd5a330112', N'13581707732', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (175, N'俎兴隆', N'', N'18600002440', 2, N'96e79218965eb72c92a549dd5a330112', N'18600002440', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (176, N'陶士浪', N'', N'18401739399', 2, N'96e79218965eb72c92a549dd5a330112', N'18401739399', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (177, N'董勇', N'', N'13146874221', 2, N'96e79218965eb72c92a549dd5a330112', N'13146874221', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (178, N'鲍章旺', N'', N'13671221324', 2, N'96e79218965eb72c92a549dd5a330112', N'13671221324', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (179, N'魏延星', N'', N'18511839879', 2, N'96e79218965eb72c92a549dd5a330112', N'18511839879', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (180, N'周傲', N'', N'15810275370', 2, N'96e79218965eb72c92a549dd5a330112', N'15810275370', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (181, N'李红娟', N'', N'15811086853', 2, N'96e79218965eb72c92a549dd5a330112', N'15811086853', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (182, N'裴瀚翔', N'', N'18701405363', 2, N'96e79218965eb72c92a549dd5a330112', N'18701405363', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (183, N'谢青', N'', N'15321005701', 2, N'96e79218965eb72c92a549dd5a330112', N'15321005701', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (184, N'王爽', N'', N'15701679357', 2, N'96e79218965eb72c92a549dd5a330112', N'15701679357', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (185, N'杨永锋', N'', N'18522690177', 2, N'96e79218965eb72c92a549dd5a330112', N'18522690177', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (186, N'韩伟伟', N'', N'18614061340', 2, N'96e79218965eb72c92a549dd5a330112', N'18614061340', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (187, N'刘林姜', N'', N'13501034783', 2, N'96e79218965eb72c92a549dd5a330112', N'13501034783', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (1175, N'赵华伟', N'', N'18911556895', 2, N'96e79218965eb72c92a549dd5a330112', N'18911556895', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (1176, N'王静松', N'', N'13611159778', 2, N'96e79218965eb72c92a549dd5a330112', N'13611159778', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (1177, N'常辰', N'', N'15910860669', 2, N'96e79218965eb72c92a549dd5a330112', N'15910860669', 0)
INSERT [dbo].[UserInfo] ([id], [Name], [IDCard], [Phone], [RoleID], [PassWord], [LoginName], [IsDelete]) VALUES (1178, N'王园', N'', N'13552543510', 2, N'96e79218965eb72c92a549dd5a330112', N'13552543510', 0)
SET IDENTITY_INSERT [dbo].[UserInfo] OFF
ALTER TABLE [dbo].[Meeting] ADD  CONSTRAINT [DF__Meeting__IsDelet__48CFD27E]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [dbo].[Meeting] ADD  CONSTRAINT [DF_Meeting_WhatBooked]  DEFAULT ((0)) FOR [WhatBooked]
GO
ALTER TABLE [dbo].[MeetingBooked] ADD  CONSTRAINT [DF__MeetingBo__Statu__182C9B23]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[MenuInfo] ADD  CONSTRAINT [DF_MenuInfo_sortId]  DEFAULT ((0)) FOR [sortId]
GO
ALTER TABLE [dbo].[TimeSection] ADD  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF__UserInfo__IsDele__4AB81AF0]  DEFAULT ((0)) FOR [IsDelete]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'菜单名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'菜单父Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'Pid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'菜单Url' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'Url'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'菜单描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否菜单(0.非菜单；1.菜单)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'isMeu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否显示菜单(0.不显示;1.显示导航;2.显示权限列表;3.都显示)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'isShow'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'样式名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'iconClass'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'排序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo', @level2type=N'COLUMN',@level2name=N'sortId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'菜单信息表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MenuInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RoleOfMenu', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'角色Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RoleOfMenu', @level2type=N'COLUMN',@level2name=N'RoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'菜单Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RoleOfMenu', @level2type=N'COLUMN',@level2name=N'MenuId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'角色菜单关系表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RoleOfMenu'
GO
USE [master]
GO
ALTER DATABASE [MeetingBooked] SET  READ_WRITE 
GO
