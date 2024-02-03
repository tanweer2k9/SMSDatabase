
CREATE PROC [dbo].[usp_ParentProfile]

@UserId numeric 


AS


--declare @UserId numeric = 181066

select u.USER_ID UserLoginId, p.PARNT_ID Id, u.USER_HD_ID HdId,u.USER_BR_ID BrId,b.BR_ADM_NAME BranchName,u.USER_NAME Username,u.USER_PASSWORD Password, p.PARNT_FIRST_NAME Name, p.PARNT_PERM_ADDR Address,a.AREA_NAME Area,c.CITY_NAME City,p.PARNT_CELL_NO MobileNo, p.PARNT_EMAIL Email from PARENT_INFO p
join USER_INFO u on u.USER_CODE = p.PARNT_ID and u.USER_TYPE = 'Parent'
join BR_ADMIN b on b.BR_ADM_ID = p.PARNT_BR_ID
left join AREA_INFO a on a.AREA_ID = p.PARNT_AREA
left join CITY_INFO c on c.CITY_ID = p.PARNT_CITY


where u.USER_ID = @UserId